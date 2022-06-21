import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:Tiba_Gates/Data/Models/guard/perHour.dart';
import 'package:Tiba_Gates/Presentation/guard/widgets/print_time_ticket.dart';
import 'package:Tiba_Gates/Presentation/guard/widgets/ticket_divider.dart';
import 'package:Tiba_Gates/Presentation/guard/widgets/ticket_footer.dart';
import 'package:Tiba_Gates/Utilities/Shared/dotted_divider.dart';
import 'package:Tiba_Gates/Utilities/Shared/noInternet.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../Utilities/Shared/tiba_logo.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import '../login_screen/Screens/login.dart';
import '../../ViewModel/guard/authProv.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'entryScreen.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../Utilities/Shared/qr.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import '../../Utilities/connectivityStatus.dart';
import 'widgets/gate_id_ticket.dart';
import 'widgets/gate_name_ticket.dart';
import 'widgets/guard_name_ticket.dart';
import 'widgets/hourly_parking_ticket.dart';
import 'widgets/qr_ticket.dart';
import 'widgets/tibaRose_header_ticket.dart';
import 'widgets/ticket_lost_fine.dart';
import 'widgets/vip_logo_ticket.dart';

List<CameraDescription> cameras;

class PrintScreen extends StatefulWidget {
  final  typeId;
  final int militaryCount;
  final int civilCount;
  final String from;
  final String resendType;
  final int logId;
  final int reasonId;
  final double reasonPrice;
  final PerHour perHourObj;

  const PrintScreen(
      {Key key,
      this.typeId,
      this.militaryCount,
      this.civilCount,
      this.from,
      this.logId,
      this.reasonId,
      this.reasonPrice,
      this.resendType,
      this.perHourObj})
      : super(key: key);

  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List _imageFile;
  Map<String, dynamic> config = {};
  List<LineText> list = [];
  bool isLoading = false;
  bool _connected = false;
  BluetoothDevice _device;
  String base64Image;
  final visibleNotifier = ValueNotifier<bool>(false);
  bool finishScanning = false;

  @override
  void initState() {
    super.initState();

    debugPrint(
        'mac address is ${Provider.of<AuthProv>(context, listen: false).printerAddress}');
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  void printScreenShot() {
    screenshotController.capture().then((Uint8List image) async {
      //Capture Done
      setState(() {
        _imageFile = image;
        log('image is $_imageFile');
      });

      try {
        config['width'] = 40;
        config['height'] = 70;
        config['gap'] = 2;

        base64Image = base64Encode(_imageFile);

        list.add(LineText(
          type: LineText.TYPE_IMAGE,
          x: 10,
          y: 0,
          content: base64Image,
        ));

        await bluetoothPrint.printReceipt(config, list).then((value) {
          debugPrint('value is $value');
          Navigator.pop(context);
          navigateReplacementTo(context, const EntryScreen());
        }).onError((error, stackTrace) {
          debugPrint('this is error $error');
        });
      } on PlatformException catch (err) {
        debugPrint('error ==> $err');
      } catch (error) {
        debugPrint('*error  $error');
      }
    }).catchError((onError) {
      debugPrint('onError $onError');
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint
        .startScan(timeout: const Duration(seconds: 5))
        .whenComplete(() => finishScanning = true);

    bool isConnected = await bluetoothPrint.isConnected;
    debugPrint('** is connected = $isConnected');

    bluetoothPrint.state.listen((state) {
      debugPrint('device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            debugPrint('*** connected');
            _connected = true;
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          if (mounted) {
            setState(() {
              debugPrint('*** dis_connected');

              _connected = false;
            });
          }

          break;
        default:
          debugPrint('state is else $isConnected');
          break;
      }
    });

    if (!mounted) {
      return;
    }

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    VisitorProv visitorProv = Provider.of<VisitorProv>(context, listen: false);
    VisitorProv visitorProvT = Provider.of<VisitorProv>(context, listen: true);
    AuthProv authProv = Provider.of<AuthProv>(context, listen: false);
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        if (widget.from == 'resend' ||
            widget.typeId == null ||
            widget.resendType == 'perHour') {
          navigateReplacementTo(context, const EntryScreen());
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {},
                  child: const AutoSizeText('Connect your printer')),
              InkWell(
                  onTap: () {
                    bluetoothPrint
                        .startScan(timeout: const Duration(seconds: 4))
                        .then((value) => debugPrint('scan result is $value'));
                  },
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 36,
                  ))
            ],
          ),
        ),
        body: connectionStatus == ConnectivityStatus.Offline
            ? NoInternet()
            : RefreshIndicator(
                onRefresh: () => bluetoothPrint.startScan(
                    timeout: const Duration(seconds: 4)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Screenshot(
                        controller: screenshotController,
                        child: (widget.resendType == 'perHour' ||
                                widget.resendType == 'المحاسبه بالساعه')
                            ? PerHourView(height, width, context)
                            : CheckinView(height, width, context, visitorProv),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: StreamBuilder<List<BluetoothDevice>>(
                            stream: bluetoothPrint.scanResults,
                            initialData: const [],
                            builder: (c, snapshot) {
                              debugPrint('snapshot = ${snapshot.data.length}');

                              return snapshot.data.isNotEmpty
                                  ? Column(
                                      children: snapshot.data.map((d) {
                                        debugPrint(
                                            'founded mac address = ${d.address.toString()}');
                                        debugPrint(
                                            'server mac address = ${authProv.printerAddress}');

                                        print(d.address.toString().trim() ==
                                            //  'DC:0D:30:CC:27:07'
                                            authProv.printerAddress
                                                .toString()
                                                .trim());

                                        if (d.address.toString().trim() ==
                                            // 'DC:0D:30:CC:27:07'
                                            authProv.printerAddress
                                                .toString()
                                                .trim()) {
                                          return RoundedButton(
                                            height: 60,
                                            width: 220,
                                            ontap: () async {
                                              showLoaderDialog(
                                                  context, 'Loading...');

                                              /**

                                      ?*********** CHECKOUT PER HOUR CASE ************
                                   */

                                              if (widget.perHourObj != null) {

                                                debugPrint('perHour');

                                                debugPrint(
                                                    'userId ${authProv.userId}  logId ${widget.perHourObj.id}');
                                                setState(() {
                                                  _device = d;
                                                });


                                                visitorProv
                                                    .confirmPerHour(
                                                  widget.perHourObj.id,
                                                  authProv.userId,
                                                )
                                                    .then((value) async {
                                                  debugPrint(
                                                      'message is $value');
                                                  debugPrint(
                                                      'userId ${authProv.userId}  logId ${widget.perHourObj.id}');
                                                  if (value == 'Success') {
                                                    // we will connect the printer
                                                    if (!_connected) {
                                                      debugPrint(
                                                          'printer is not connected');

                                                      if (_device != null &&
                                                          _device.address !=
                                                              null) {
                                                        await bluetoothPrint
                                                            .connect(_device)
                                                            .then((value) {
                                                          Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          6))
                                                              .whenComplete(
                                                                  () async {
                                                            // take screenshot
                                                            printScreenShot();
                                                          });
                                                        });
                                                      } else {
                                                        debugPrint(
                                                            'device is null 1');
                                                      }
                                                    } else {
                                                      debugPrint(
                                                          'printer is connected asln');
                                                      // we will take screenshot
                                                      printScreenShot();
                                                    }
                                                  }
                                                });
                                              }

                                              /**
                                      ?*********** RE-PRINT CASE ************
                                   */
                                              else if (widget.from ==
                                                  'resend') {
                                                if (widget.resendType ==
                                                        'Normal' ||
                                                    widget.resendType ==
                                                        'VIP Invitation') {
                                                  Future.delayed(const Duration(
                                                          milliseconds: 1500))
                                                      .whenComplete(() async {
                                                    setState(() {
                                                      _device = d;
                                                    });

                                                    visitorProv
                                                        .confirmPrint(
                                                            authProv.userId,
                                                            visitorProv.logId,
                                                            widget.reasonId)
                                                        .then((value) async {
                                                      if (value == 'Success') {
                                                        // we will connect the printer
                                                        if (!_connected) {
                                                          debugPrint(
                                                              'printer is not connected');

                                                          if (_device != null &&
                                                              _device.address !=
                                                                  null) {
                                                            await bluetoothPrint
                                                                .connect(
                                                                    _device)
                                                                .then((value) {
                                                              Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              6))
                                                                  .whenComplete(
                                                                      () async {
                                                                // take screenshot
                                                                printScreenShot();
                                                              });
                                                            });
                                                          } else {
                                                            debugPrint(
                                                                'device is null 1');
                                                          }
                                                        } else {
                                                          debugPrint(
                                                              'printer is connected asln');
                                                          // we will take screenshot
                                                          printScreenShot();
                                                        }
                                                      }
                                                    });
                                                  });
                                                } else if (widget.resendType ==
                                                    'المحاسبه بالساعه') {
                                                  Future.delayed(const Duration(
                                                          milliseconds: 1500))
                                                      .whenComplete(() async {
                                                    setState(() {
                                                      _device = d;
                                                    });

                                                    visitorProv
                                                        .confirmPrint(
                                                            authProv.userId,
                                                            visitorProv.logId,
                                                            widget.reasonId)
                                                        .then((value) async {
                                                      if (value == 'Success') {
                                                        // we will connect the printer
                                                        if (!_connected) {
                                                          debugPrint(
                                                              'printer is not connected');

                                                          if (_device != null &&
                                                              _device.address !=
                                                                  null) {
                                                            await bluetoothPrint
                                                                .connect(
                                                                    _device)
                                                                .then((value) {
                                                              Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              6))
                                                                  .whenComplete(
                                                                      () async {
                                                                // take screenshot
                                                                 printScreenShot();
                                                              });
                                                            });
                                                          } else {
                                                            debugPrint(
                                                                'device is null 1');
                                                          }
                                                        } else {
                                                          debugPrint(
                                                              'printer is connected asln');
                                                          // we will take screenshot
                                                           printScreenShot();
                                                        }
                                                      }
                                                    });
                                                  });
                                                } else {
                                                  Future.delayed(const Duration(
                                                          milliseconds: 1500))
                                                      .whenComplete(() async {
                                                    setState(() {
                                                      _device = d;
                                                    });
                                                    visitorProv
                                                        .confirmPrint(
                                                            authProv.userId,
                                                            visitorProv.logId,
                                                            widget.reasonId)
                                                        .then((value) async {
                                                      if (value == 'Success') {
                                                        // we will connect the printer
                                                        if (!_connected) {
                                                          debugPrint(
                                                              'printer is not connected');

                                                          if (_device != null &&
                                                              _device.address !=
                                                                  null) {
                                                            await bluetoothPrint
                                                                .connect(
                                                                    _device)
                                                                .then((value) {
                                                              Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              6))
                                                                  .whenComplete(
                                                                      () async {
                                                                // take screenshot
                                                                await printScreenShot();
                                                              });
                                                            });
                                                          } else {
                                                            debugPrint(
                                                                'device is null 2');
                                                          }
                                                        } else {
                                                          debugPrint(
                                                              'printer is connected asln');
                                                          // we will take screenshot
                                                          printScreenShot();
                                                        }
                                                      }
                                                    });
                                                  });
                                                }
                                              }

                                              /**
                                      ?*********** NORMAL PRINT CASE ************
                                   */

                                              else if (widget.from == 'send') {
                                                if (widget.resendType ==
                                                        'Normal' ||
                                                    widget.resendType ==
                                                        'VIP Invitation') {
                                                  debugPrint('invitation');
                                                  visitorProv
                                                      .checkInInvitation(
                                                    authProv.userId,
                                                    visitorProv.invitationID,
                                                    context,
                                                    visitorProv.rokhsa,
                                                    visitorProv.idCard,
                                                  )
                                                      .then((value) async {
                                                    if (value.message ==
                                                        'Success') {
                                                      Future.delayed(
                                                              const Duration(
                                                                  seconds: 1))
                                                          .whenComplete(
                                                              () async {
                                                        setState(() {
                                                          _device = d;
                                                        });

                                                        // first we will connect the printer
                                                        if (!_connected) {
                                                          print(
                                                              'printer is not connected in invitation');

                                                          if (_device != null &&
                                                              _device.address !=
                                                                  null) {
                                                            await bluetoothPrint
                                                                .connect(
                                                                    _device)
                                                                .then((value) {
                                                              print(
                                                                  'printer is connected with value $value');
                                                              Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              6))
                                                                  .whenComplete(
                                                                      () async {
                                                                printScreenShot();
                                                              });
                                                            });
                                                          } else {
                                                            print(
                                                                'device is null 3');
                                                          }
                                                        } else {
                                                          await printScreenShot();
                                                        }
                                                      });
                                                    }
                                                  });
                                                } else if (widget.resendType ==
                                                    'perHour') {
                                                  debugPrint('perHour');

                                                  setState(() {
                                                    _device = d;
                                                  });
                                                  if (!_connected) {
                                                    debugPrint(
                                                        'printer is not connected');

                                                    if (_device != null &&
                                                        _device.address !=
                                                            null) {
                                                      await bluetoothPrint
                                                          .connect(_device)
                                                          .then((value) {
                                                        Future.delayed(
                                                                const Duration(
                                                                    seconds: 6))
                                                            .whenComplete(
                                                                () async {
                                                          // take screenshot
                                                          await printScreenShot();
                                                        });
                                                      });
                                                    } else {
                                                      debugPrint(
                                                          'device is null 1');
                                                    }
                                                  } else {
                                                    debugPrint(
                                                        'printer is connected asln');
                                                    // we will take screenshot
                                                    printScreenShot();
                                                  }
                                                } else {
                                                  if (visitorProv
                                                          .memberShipModel !=
                                                      null) {
                                                    // keda hwa gy mn scan membership , hanshof lw el swr empty hn5lihom null 34an nb3thom ll database null
                                                    if (visitorProv
                                                        .memberShipModel
                                                        .carImagePath
                                                        .contains('empty')) {
                                                      visitorProv
                                                          .memberShipModel
                                                          .carImagePath = null;
                                                    } else if (visitorProv
                                                        .memberShipModel
                                                        .identityImagePath
                                                        .contains('empty')) {
                                                      visitorProv
                                                              .memberShipModel
                                                              .identityImagePath =
                                                          null;
                                                    }

                                                    // hna b2a hn-call checkInMembership
                                                    visitorProv
                                                        .checkInMemberShip(
                                                            visitorProv
                                                                .memberShipModel
                                                                .id,
                                                            authProv.userId,
                                                            context,
                                                            Provider.of<VisitorProv>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .memberShipModel
                                                                .carImagePath,
                                                            Provider.of<VisitorProv>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .memberShipModel
                                                                .identityImagePath)
                                                        .then((value) async {
                                                      if (value.message ==
                                                          'Success') {
                                                        Future.delayed(
                                                                const Duration(
                                                                    seconds: 1))
                                                            .whenComplete(
                                                                () async {
                                                          setState(() {
                                                            _device = d;
                                                          });

                                                          // first we will connect the printer
                                                          if (!_connected) {
                                                            debugPrint(
                                                                'printer is not connected');

                                                            if (_device !=
                                                                    null &&
                                                                _device.address !=
                                                                    null) {
                                                              await bluetoothPrint
                                                                  .connect(
                                                                      _device)
                                                                  .then(
                                                                      (value) {
                                                                debugPrint(
                                                                    'printer is connected with value $value');
                                                                Future.delayed(const Duration(
                                                                        seconds:
                                                                            6))
                                                                    .whenComplete(
                                                                        () async {
                                                                  printScreenShot();
                                                                });
                                                              });
                                                            } else {
                                                              debugPrint(
                                                                  'device is null 4');
                                                            }
                                                          } else {
                                                            debugPrint(
                                                                'printer is connected 2');
                                                            // secondly we will print
                                                            await printScreenShot();
                                                          }
                                                        });
                                                      } else if (value
                                                              .message ==
                                                          'unAuth') {
                                                        cameras =
                                                            await availableCameras();
                                                        showToast(
                                                            'برجاء تسجيل الدخول من جديد');
                                                        navigateReplacementTo(
                                                            context,
                                                            LoginScreen(
                                                              camera:
                                                                  cameras[1],
                                                            ));
                                                      }
                                                    });
                                                  } else {
                                                    visitorProv
                                                        .checkIn(
                                                      visitorProv.rokhsa,
                                                      visitorProv.idCard,
                                                      authProv.userId,
                                                      int.parse(widget.typeId
                                                          .toString()),
                                                      widget.civilCount,
                                                      widget.militaryCount,
                                                      context,
                                                    )
                                                        .then((value) async {
                                                      if (value.message ==
                                                          'Success') {
                                                        Future.delayed(
                                                                const Duration(
                                                                    seconds: 1))
                                                            .whenComplete(
                                                                () async {
                                                          setState(() {
                                                            _device = d;
                                                          });

                                                          // first we will connect the printer
                                                          if (!_connected) {
                                                            debugPrint(
                                                                'printer is not connected');

                                                            if (_device !=
                                                                    null &&
                                                                _device.address !=
                                                                    null) {
                                                              await bluetoothPrint
                                                                  .connect(
                                                                      _device)
                                                                  .then(
                                                                      (value) {
                                                                debugPrint(
                                                                    'printer is connected with value $value');
                                                                Future.delayed(const Duration(
                                                                        seconds:
                                                                            6))
                                                                    .whenComplete(
                                                                        () async {
                                                                  printScreenShot();
                                                                });
                                                              });
                                                            } else {
                                                              debugPrint(
                                                                  'device is null 4');
                                                            }
                                                          } else {
                                                            debugPrint(
                                                                'printer is connected 2');
                                                            // secondly we will print
                                                            await printScreenShot();
                                                          }
                                                        });
                                                      } else if (value
                                                              .message ==
                                                          'unAuth') {
                                                        cameras =
                                                            await availableCameras();
                                                        showToast(
                                                            'برجاء تسجيل الدخول من جديد');
                                                        navigateReplacementTo(
                                                            context,
                                                            LoginScreen(
                                                              camera:
                                                                  cameras[1],
                                                            ));
                                                      } else if (value
                                                              .message ==
                                                          'Forbidden') {
                                                        Navigator.pop(context);
                                                        showToast(
                                                            'Status Code : 403 \n access to the requested resource is forbidden');
                                                      }
                                                    });
                                                  }
                                                }
                                              }
                                            },
                                            title: 'تأكيد',
                                            buttonColor: ColorManager.primary,
                                            titleColor:
                                                ColorManager.backGroundColor,
                                          );
                                        } else if (snapshot.data.length == 1) {
                                          return RoundedButton(
                                            height: 60,
                                            width: 220,
                                            ontap: () async {
                                              try {
                                                visibleNotifier.value = true;
                                                if (finishScanning == true) {
                                                  bluetoothPrint
                                                      .startScan(
                                                          timeout:
                                                              const Duration(
                                                                  seconds: 4))
                                                      .then((value) {
                                                    debugPrint(
                                                        'scan result is $value');
                                                    if (snapshot.data.isEmpty) {
                                                      showToast(
                                                          'Make Sure to open Bluetooth and Location');
                                                    }
                                                    visibleNotifier.value =
                                                        false;
                                                  });
                                                } else {
                                                  Future.delayed(const Duration(
                                                          seconds: 2))
                                                      .whenComplete(() {
                                                    visibleNotifier.value =
                                                        false;
                                                  });
                                                }
                                              } catch (error) {
                                                debugPrint('error = $error');
                                              }
                                            },
                                            title: 'Refresh',
                                            buttonColor: ColorManager.primary,
                                            titleColor:
                                                ColorManager.backGroundColor,
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }).toList(),
                                    )
                                  : ValueListenableBuilder(
                                      valueListenable: visibleNotifier,
                                      builder: (context, value, child) {
                                        return value == false
                                            ? RoundedButton(
                                                height: 60,
                                                width: 220,
                                                ontap: () async {
                                                  try {
                                                    visibleNotifier.value =
                                                        true;
                                                    if (finishScanning ==
                                                        true) {
                                                      bluetoothPrint
                                                          .startScan(
                                                              timeout:
                                                                  const Duration(
                                                                      seconds:
                                                                          4))
                                                          .then((value) {
                                                        debugPrint(
                                                            'scan result is $value');
                                                        if (snapshot
                                                            .data.isEmpty) {
                                                          showToast(
                                                              'Make Sure to open Bluetooth and Location');
                                                        }
                                                        visibleNotifier.value =
                                                            false;
                                                      });
                                                    } else {
                                                      Future.delayed(
                                                              const Duration(
                                                                  seconds: 2))
                                                          .whenComplete(() {
                                                        visibleNotifier.value =
                                                            false;
                                                      });
                                                    }
                                                  } catch (error) {
                                                    debugPrint(
                                                        'error = $error');
                                                  }
                                                },
                                                title: 'Refresh',
                                                buttonColor:
                                                    ColorManager.primary,
                                                titleColor: ColorManager
                                                    .backGroundColor,
                                              )
                                            : const CircularProgressIndicator(
                                                backgroundColor: Colors.green,
                                              );
                                      },
                                    );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Padding CheckinView(double height, double width, BuildContext context,
      VisitorProv visitorProv) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      TibaLogo(
                        height: height,
                        width: width,
                      ),
                      const TibaRoseHeader(),
                      SizedBox(
                        height: 20.h,
                      ),
                      Provider.of<VisitorProv>(context, listen: true)
                                  .printTime !=
                              null
                          ? const PrintTime()
                          : Container(),
                      SizedBox(
                        height: 12.h,
                      ),
                      const GuardName(),
                      SizedBox(
                        height: 12.h,
                      ),
                      const GateName(),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Column(
                    children: [
                      widget.resendType == 'VIP Invitation'
                          ? VipLogo(
                              width: width,
                              height: height,
                            )
                          : Container(),
                      const QrTicket(),
                      SizedBox(
                        height: 8.h,
                      ),
                      Provider.of<VisitorProv>(context, listen: true).logId !=
                              null
                          ? Column(
                              children: const [
                                GateID(),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  children: [
                    (widget.resendType != ('VIP Invitation') &&
                            widget.resendType != ('Normal'))
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Park Fee  :  ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: setResponsiveFontSize(30),
                                      fontWeight: FontManager.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: visitorProv.parkPrice.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: setResponsiveFontSize(32),
                                        )),
                                    TextSpan(
                                        text: ' LE',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          color: Colors.black,
                                          fontSize: setResponsiveFontSize(24),
                                        )),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 12.h,
                              ),
                              visitorProv.citizenPrice != 0
                                  ? RichText(
                                      text: TextSpan(
                                        text: 'Civilian Entry Fee  :  ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: setResponsiveFontSize(30),
                                            fontWeight: FontManager.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: visitorProv.citizenPrice
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize:
                                                    setResponsiveFontSize(32),
                                              )),
                                          TextSpan(
                                              text: ' LE',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5,
                                                color: Colors.black,
                                                fontSize:
                                                    setResponsiveFontSize(24),
                                              )),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 12.h,
                              ),
                              visitorProv.militaryPrice != 0
                                  ? RichText(
                                      text: TextSpan(
                                        text: 'Military Entry Fee :  ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: setResponsiveFontSize(30),
                                            fontWeight: FontManager.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: visitorProv.militaryPrice
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize:
                                                    setResponsiveFontSize(32),
                                              )),
                                          TextSpan(
                                              text: ' LE',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5,
                                                color: Colors.black,
                                                fontSize:
                                                    setResponsiveFontSize(24),
                                              )),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 12.h,
                              ),
                              const DottedDivider(),
                              //  Divider(thickness: 2,),
                              SizedBox(
                                height: 12.h,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Total : ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: setResponsiveFontSize(30),
                                      fontWeight: FontManager.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: visitorProv.totalPrice.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: setResponsiveFontSize(32),
                                        )),
                                    TextSpan(
                                        text: ' LE',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          letterSpacing: 1.5,
                                          fontSize: setResponsiveFontSize(24),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              const Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                            ],
                          )
                        : Container(),
                    TicketLostFine(widget: widget),
                    SizedBox(
                      height: 20.h,
                    ),
                    const TicketFooter(),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding PerHourView(double height, double width, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      TibaLogo(height: height, width: width),
                      const TibaRoseHeader(),
                      SizedBox(
                        height: 20.h,
                      ),
                      Provider.of<VisitorProv>(context, listen: true)
                                  .printTime !=
                              null
                          ? const PrintTime()
                          : Container(),
                      SizedBox(
                        height: 12.h,
                      ),
                      const GuardName(),
                      SizedBox(
                        height: 12.h,
                      ),
                      const GateName(),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Column(
                    children: [
                      HourlyParking(
                        height: height,
                        width: width,
                      ),
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 2.w, color: Colors.green)),
                        child: Qr(
                          data: widget.perHourObj != null
                              ? widget.perHourObj.qrCode
                              : Provider.of<VisitorProv>(context, listen: false)
                                      .qrCode ??
                                  'default',
                          size: 270.0.w,
                          version: QrVersions.auto,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'G-${widget.perHourObj != null ? widget.perHourObj.id : Provider.of<VisitorProv>(context, listen: true).logId}',
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(36),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  children: [
                    widget.perHourObj != null
                        ? Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 20.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText(
                                      '${widget.perHourObj.inTime.toString().substring(0, 10)}   ${widget.perHourObj.inTime.toString().substring(11)}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: setResponsiveFontSize(28),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Flexible(
                                      child: AutoSizeText(
                                          'وقت الدخول              ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize:
                                                  setResponsiveFontSize(26),
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              const TicketDivider(),
                              SizedBox(
                                height: 10.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 20.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText(
                                      '${widget.perHourObj.outTime.toString().substring(0, 10)}   ${widget.perHourObj.outTime.toString().substring(11)}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: setResponsiveFontSize(28),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Flexible(
                                      child: AutoSizeText(
                                          'وقت الخروج              ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize:
                                                  setResponsiveFontSize(26),
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              const TicketDivider(),
                              SizedBox(
                                height: 10.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 20.w),
                                child: Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AutoSizeText('الإجمالى :             ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize:
                                                  setResponsiveFontSize(28),
                                              fontWeight: FontWeight.bold)),
                                      AutoSizeText(
                                        '${widget.perHourObj.total}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: setResponsiveFontSize(30),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h)
                            ],
                          )
                        : Container(),
                    widget.perHourObj == null
                        ? Container(
                            decoration: DottedDecoration(
                              shape: Shape.box,
                              color: Colors.black,
                              strokeWidth: 2.w,
                              borderRadius: BorderRadius.circular(
                                  10), //remove this to get plane rectange
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, left: 4, right: 4),
                              child: Center(
                                child: Column(children: [
                                  AutoSizeText(
                                    'برجاء الإحتفاظ بالفاتورة لتقديمها عند المغادرة',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        height: 2.h,
                                        fontSize: setResponsiveFontSize(28),
                                        fontWeight: FontManager.bold),
                                  ),
                                  AutoSizeText(
                                    ' غرامة فقد التذكرة ${Provider.of<AuthProv>(context, listen: false).lostTicketPrice.toString() ?? 0} جنيه',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        height: 2.h,
                                        fontSize: setResponsiveFontSize(28),
                                        fontWeight: FontManager.bold),
                                  ),
                                ]),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 10.h,
                    ),
                    const TicketFooter()
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
