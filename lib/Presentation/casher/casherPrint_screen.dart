import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:Tiba_Gates/Presentation/casher/casherEntry_screen.dart';
import 'package:Tiba_Gates/Utilities/Shared/noInternet.dart';
import 'package:Tiba_Gates/Utilities/Shared/tiba_logo.dart';
import 'package:Tiba_Gates/ViewModel/casher/servicesProv.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../login_screen/Screens/login.dart';
import '../../ViewModel/guard/authProv.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../Utilities/Shared/qr.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import '../../Utilities/connectivityStatus.dart';

class CasherPrintScreen extends StatefulWidget {
  final int typeId;
  final int count;
  final double totalPrice;
  final String serviceName;
  final militaryCount, civilCount;
  final from;
  final resendType;
  final logId;
  final reasonId;
  final reasonPrice;

  const CasherPrintScreen(
      {Key key,
        this.typeId,
        this.militaryCount,
        this.civilCount,
        this.from,
        this.logId,
        this.reasonId,
        this.reasonPrice,
        this.resendType,
        this.count,
        this.totalPrice,
        this.serviceName})
      : super(key: key);

  @override
  _CasherPrintScreenState createState() => _CasherPrintScreenState();
}

class _CasherPrintScreenState extends State<CasherPrintScreen> {
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
        print('image is $_imageFile');
      });

      try {
        config['width'] = 40;
        config['height'] = 70;
        config['gap'] = 2;

        base64Image = base64Encode(_imageFile);

        list.add(LineText(
          type: LineText.TYPE_IMAGE,
          x: 10,
          //   width: 58,
          y: 0,
          content: base64Image,
        ));

        await bluetoothPrint.printReceipt(config, list).then((value) {
          debugPrint('value is $value');
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const CasherEntryScreen()));
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

  Future<void> initBluetooth() async {
    bluetoothPrint
        .startScan(timeout: const Duration(seconds: 5))
        .whenComplete(() => finishScanning = true);

    bool isConnected = await bluetoothPrint.isConnected;
    debugPrint('is connected = $isConnected');

    bluetoothPrint.state.listen((state) {
      debugPrint('cur device status: $state');

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ServicesProv serviceProv =
    Provider.of<ServicesProv>(context, listen: false);
    ServicesProv trueVisitorProv =
    Provider.of<ServicesProv>(context, listen: true);
    AuthProv authProv = Provider.of<AuthProv>(context, listen: false);
    ConnectivityStatus connectionStatus =
    Provider.of<ConnectivityStatus>(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        navigateReplacementTo(context, const CasherEntryScreen());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text('Connect your printer'),
              InkWell(
                  onTap: (){bluetoothPrint
                      .startScan(
                      timeout:
                      const Duration(
                          seconds: 4)).then((value) =>   debugPrint(
                      'scan result is $value'));},
                  child: const Icon(Icons.refresh_rounded,size: 36,))
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
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 8),
                                      child: TibaLogo(
                                        height: height,
                                        width: width,
                                      ),
                                    ),
                                    Text(
                                        'دار الدفاع الجوى - التجمع الخامس',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                            setResponsiveFontSize(26),
                                            fontWeight:
                                            FontManager.bold)),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    trueVisitorProv.printTime != null
                                        ? Text(
                                      'Date : ${                      DateFormat('yyyy-MM-dd / hh:mm')
                                          .format(DateTime.parse(trueVisitorProv.printTime))
                                          .toString()                   }',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                          setResponsiveFontSize(
                                              26),
                                          fontWeight:
                                          FontManager.bold),
                                    )
                                        : Container(),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Text(
                                      'User Name : ${(Provider.of<AuthProv>(context, listen: true).guardName)??'  -  '}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                          setResponsiveFontSize(26),
                                          fontWeight: FontManager.bold),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Text(
                                      'Gate : ${(Provider.of<AuthProv>(context, listen: true).gateName)??'  -  '}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                          setResponsiveFontSize(26),
                                          fontWeight: FontManager.bold),
                                    ),
                                  ],
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                ),
                                Column(
                                  children: [
                                    /*          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: SizedBox(
                                              height: (height * 0.2),
                                              width: (width * 0.3),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 6.w,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/casherMachine.jpg')),
                                                  *//*   shape: BoxShape
                                                 .circle,*//*
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                          Text(
                                            'نظام الكاشير المتنقل',
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(23),
                                                fontWeight: FontWeight.bold),
                                          ),*/
                                    Container(
                                      padding:
                                      const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.w,
                                              color: Colors.green)),
                                      child: Qr(
                                        data:
                                        Provider.of<ServicesProv>(context, listen: true).billId.toString() ??
                                            'abc',
                                        size: 270.0.w,
                                        version: QrVersions.auto,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Provider.of<ServicesProv>(context, listen: true).billId !=
                                        null
                                        ? Column(
                                      children: [
                                        Text(
                                          'S-${Provider.of<ServicesProv>(context, listen: true).billId}',
                                          style: TextStyle(
                                              fontSize:
                                              setResponsiveFontSize(
                                                  36),
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
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
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Service Name  :  ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                              setResponsiveFontSize(
                                                  30),
                                              fontWeight:
                                              FontManager.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: widget.serviceName,
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize:
                                                  setResponsiveFontSize(
                                                      32),
                                                )),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Service Fee :  ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                              setResponsiveFontSize(
                                                  30),
                                              fontWeight:
                                              FontManager.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: (widget.totalPrice /
                                                    widget.count)
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize:
                                                  setResponsiveFontSize(
                                                      32),
                                                )),
                                            TextSpan(
                                                text: ' LE',
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  letterSpacing: 1.5,
                                                  color: Colors.black,
                                                  fontSize:
                                                  setResponsiveFontSize(
                                                      24),
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Count :  ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                              setResponsiveFontSize(
                                                  30),
                                              fontWeight:
                                              FontManager.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: widget.count
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize:
                                                  setResponsiveFontSize(
                                                      32),
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(right: 250.w),
                                        child: Container(
                                          decoration: DottedDecoration(
                                              shape: Shape.line,
                                              linePosition:
                                              LinePosition.bottom,
                                              color: Colors.black),
                                        ),
                                      ),
                                      //  Divider(thickness: 2,),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Total : ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                              setResponsiveFontSize(
                                                  30),
                                              fontWeight:
                                              FontManager.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: widget.totalPrice
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize:
                                                  setResponsiveFontSize(
                                                      32),
                                                )),
                                            TextSpan(
                                                text: ' LE',
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black,
                                                  letterSpacing: 1.5,
                                                  fontSize:
                                                  setResponsiveFontSize(
                                                      24),
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
                                  ),

                                  Center(
                                    child: Text(
                                      'It\'s our pleasure to serve you \n                  يسعدنا خدمتك',
                                      style: TextStyle(
                                          color: Colors.black,
                                          height: 2.h,
                                          fontSize:
                                          setResponsiveFontSize(28),
                                          fontWeight: FontManager.bold),
                                    ),
                                  ),
                                ],
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                            debugPrint('d.address = ${d.address.toString()}');
                            debugPrint('mac address = ${authProv.printerAddress}');

                            // debugPrint(d.address.toString().trim() == Provider.of<AuthProv>(context, listen: false).printerAddress.toString().trim());

                            if (
                            d.address ==
                                authProv.printerAddress
                               // 'DC:0D:30:A0:64:74'

                            //'DC:0D:30:CC:27:07'
                            ) {
                              return RoundedButton(
                                height: 60,
                                width: 220,
                                ontap: () async {
                                  showLoaderDialog(
                                      context, 'جارى التحميل..');
                                  serviceProv
                                      .addBill(
                                      widget.typeId,
                                      widget.totalPrice,
                                      widget.count,prefs.getString('guardId'))
                                      .then(((value) async {
                                    if (value ==
                                        'Success') {

                                      /*      prefs.setDouble(
                                                      'balance',
                                                      authProv.balance +
                                                          widget.totalPrice);

                                                  authProv.balance =
                                                      prefs.getDouble('balance');
                                                  debugPrint(
                                                      'new balance is ${prefs.getDouble('balance')}');*/
                                      Future.delayed(const Duration(
                                          seconds: 1))
                                          .whenComplete(() async {
                                        setState(() {
                                          _device = d;
                                        });

                                        // first we will connect the printer
                                        if (!_connected) {
                                          print(
                                              'printer is not connected');

                                          if (_device != null &&
                                              _device.address !=
                                                  null) {
                                            await bluetoothPrint
                                                .connect(_device)
                                                .then((value) {
                                              debugPrint(
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
                                                'device is null ');
                                          }
                                        } else {
                                          printScreenShot();
                                        }
                                      });
                                    }
                                  }));
                                },
                                title: 'تأكيد',
                                buttonColor: ColorManager.primary,
                                titleColor:
                                ColorManager.backGroundColor,
                              );
                            }
                            else if(  snapshot.data.length==1) {
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
                                          showToast('Make Sure to open Bluetooth and Location');
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
                            }else {
                              return Container();
                            }
                          }

                          ).toList(),
                        )
                            : ValueListenableBuilder(
                          valueListenable: visibleNotifier,
                          builder: (context, value, child) {
                            return value == false
                                ? RoundedButton(
                              height: 60,
                              width: 300,
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
                                        Fluttertoast.showToast(
                                            msg:
                                            'Make Sure to open Bluetooth and Location',
                                            backgroundColor:
                                            Colors.green,
                                            toastLength: Toast
                                                .LENGTH_LONG);
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
}
