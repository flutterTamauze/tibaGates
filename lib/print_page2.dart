import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:clean_app/Core/Fonts/fontsManager.dart';
import 'package:clean_app/ViewModel/authProv.dart';
import 'package:clean_app/ViewModel/visitorProv.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Core/Colors/colorManager.dart';
import 'Core/Constants/constants.dart';
import 'Core/Shared/dialogs/loading_dialog.dart';
import 'Core/Shared/qr.dart';
import 'Core/Shared/sharedWidgets.dart';
import 'Presentation/entry_screen/entryScreen.dart';

class PrintScreen2 extends StatefulWidget {
  final typeId, militaryCount, civilCount;
  final from;
  final resendType;
  final logId;
  final reasonId;
  final reasonPrice;

  const PrintScreen2(
      {Key key,
      this.typeId,
      this.militaryCount,
      this.civilCount,
      this.from,
      this.logId,
      this.reasonId,
      this.reasonPrice,
      this.resendType})
      : super(key: key);

  @override
  _PrintScreen2State createState() => _PrintScreen2State();
}

class _PrintScreen2State extends State<PrintScreen2> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List _imageFile;
  Map<String, dynamic> config = Map();
  List<LineText> list = [];
  bool isLoading = false;
  bool _connected = false;
  BluetoothDevice _device;
  String base64Image;
  final visibleNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    print(
        'mac address is ${Provider.of<AuthProv>(context, listen: false).printerAddress}');
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  printScreenShot() {
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
          y: 0,
          content: base64Image,
        ));

        await bluetoothPrint.printReceipt(config, list).then((value) {
          print('value is $value');
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => EntryScreen()));
        }).onError((error, stackTrace) {
          print('this is error $error');
        });
      } on PlatformException catch (err) {
        print('error ==> $err');
      } catch (error) {
        print('*error  $error');
      }
    }).catchError((onError) {
      print('onError $onError');
    });
  }

  bool finishScanning = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint
        .startScan(timeout: Duration(seconds: 5))
        .whenComplete(() => finishScanning = true);

    bool isConnected = await bluetoothPrint.isConnected;
    print('** is connected = $isConnected');

    bluetoothPrint.state.listen((state) {
      print('cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            print('*** connected');
            _connected = true;
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            print('*** dis_connected');

            _connected = false;
          });
          break;
        default:
          print('state is else $isConnected');
          break;
      }
    });

    if (!mounted) return;

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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var visitorProv = Provider.of<VisitorProv>(context, listen: false);
    var authProv = Provider.of<AuthProv>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        if (widget.from == 'resend' || widget.typeId == null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => EntryScreen()));
        } else
          Navigator.pop(context);
        throw '';
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Connect your printer'),
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              bluetoothPrint.startScan(timeout: Duration(seconds: 4)),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 8),
                                      child: Container(
                                        height: (height * 0.18),
                                        width: (width * 0.34),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/tipasplash.png")),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text('دار الدفاع الجوى - التجمع الخامس',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: setResponsiveFontSize(26),
                                            // fontFamily: GoogleFonts.getFont('Reem Kufi').fontFamily,
                                            fontFamily: GoogleFonts.getFont(
                                                    'Staatliches')
                                                .fontFamily,
                                            fontWeight: FontManager.bold)),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    /*    Container(
                                       // height: 20.h,
                                        width: 90.w
                                        ,
                                        child: Image.asset('assets/images/decoration.png')),*/
                                    Provider.of<VisitorProv>(context,
                                                    listen: true)
                                                .printTime !=
                                            null
                                        ? Text(
                                            'Date : ${Provider.of<VisitorProv>(context, listen: true).printTime}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    setResponsiveFontSize(26),
                                                fontWeight: FontManager.bold),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Text(
                                      'Guard Name : ${Provider.of<AuthProv>(context, listen: true).guardName}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: setResponsiveFontSize(26),
                                          fontWeight: FontManager.bold),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Text(
                                      'Gate : ${Provider.of<AuthProv>(context, listen: true).gateName}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: setResponsiveFontSize(26),
                                          fontWeight: FontManager.bold),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                Column(
                                  children: [
                                    widget.resendType == 'VIP Invitation'
                                        ? Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Container(
                                                height: (height * 0.13),
                                                width: (width * 0.3),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/vip.png")),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            )

                                            /* Text(
                                             'VIP',
                                             textAlign: TextAlign.center,
                                             style: TextStyle(
                                                 color: Colors.black,
                                                 height: 2.h,
                                                 fontSize:
                                                 setResponsiveFontSize(30),
                                                 fontWeight: FontManager.bold),
                                           ),*/
                                            )
                                        : Container(),
                                    Container(
                                      //    margin: const EdgeInsets.only(top: 0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.w, color: Colors.green)),
                                      child: Qr(
                                        data: Provider.of<VisitorProv>(context,
                                                    listen: true)
                                                .qrCode ??
                                            "abc",
                                        size: 280.0.w,
                                        version: QrVersions.auto,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Provider.of<VisitorProv>(context,
                                                    listen: true)
                                                .logId !=
                                            null
                                        ? Column(
                                            children: [
                                              Text(
                                                'G-${Provider.of<VisitorProv>(context, listen: true).logId}',
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Park Fee  :  ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        setResponsiveFontSize(
                                                            30),
                                                    fontWeight:
                                                        FontManager.bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: visitorProv
                                                          .parkPrice
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
                                            visitorProv.citizenPrice != 0
                                                ? RichText(
                                                    text: TextSpan(
                                                      text:
                                                          'Civilian Entry Fee  :  ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              setResponsiveFontSize(
                                                                  30),
                                                          fontWeight:
                                                              FontManager.bold),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: visitorProv
                                                                .citizenPrice
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  setResponsiveFontSize(
                                                                      32),
                                                            )),
                                                        TextSpan(
                                                            text: ' LE',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.5,
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  setResponsiveFontSize(
                                                                      24),
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
                                                      text:
                                                          'Military Entry Fee :  ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              setResponsiveFontSize(
                                                                  30),
                                                          fontWeight:
                                                              FontManager.bold),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: visitorProv
                                                                .militaryPrice
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  setResponsiveFontSize(
                                                                      32),
                                                            )),
                                                        TextSpan(
                                                            text: ' LE',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.5,
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  setResponsiveFontSize(
                                                                      24),
                                                            )),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
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
                                                      text: visitorProv
                                                          .totalPrice
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
                                            Divider(
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
                                  Container(
                                    decoration: DottedDecoration(
                                      shape: Shape.box,
                                      color: Colors.black,
                                      strokeWidth: 2.w,
                                      borderRadius: BorderRadius.circular(
                                          10), //remove this to get plane rectange
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 4,
                                          right: 4),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              'برجاء الإحتفاظ بالفاتورة لتقديمها عند المغادرة',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  height: 2.h,
                                                  fontSize:
                                                      setResponsiveFontSize(28),
                                                  fontWeight: FontManager.bold),
                                            ),
                                            (widget.resendType !=
                                                        ('VIP Invitation') &&
                                                    widget.resendType !=
                                                        ('Normal'))
                                                ? Text(
                                                    ' غرامة فقد التذكرة ${Provider.of<AuthProv>(context, listen: false).lostTicketPrice.toString() ?? 0} جنيه',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        height: 2.h,
                                                        fontSize:
                                                            setResponsiveFontSize(
                                                                28),
                                                        fontWeight:
                                                            FontManager.bold),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Center(
                                    child: Text(
                                      'It\'s our pleasure to serve you \n                  يسعدنا خدمتك',
                                      style: TextStyle(
                                          color: Colors.black,
                                          height: 2.h,
                                          fontSize: setResponsiveFontSize(28),
                                          fontWeight: FontManager.bold),
                                    ),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 22.h,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: StreamBuilder<List<BluetoothDevice>>(
                      stream: bluetoothPrint.scanResults,
                      initialData: [],
                      builder: (c, snapshot) {
                        print('snapshot = ${snapshot.data.length}');

                        return snapshot.data.length != 0
                            ? Column(
                                children: snapshot.data
                                    .map((d) => d.address ==
                                            Provider.of<AuthProv>(context,
                                                    listen: false)
                                                .printerAddress
                                        ? RoundedButton(
                                            height: 60,
                                            width: 220,
                                            ontap: () async {
                                              bool isDeviceNotNull =
                                                  (_device != null &&
                                                      _device.address != null);

                                              showLoaderDialog(
                                                  context, 'Loading...');
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();

                                              if (widget.from == 'resend') {
                                                if (widget.resendType ==
                                                        'Normal' ||
                                                    widget.resendType ==
                                                        'VIP Invitation') {
                                                  Future.delayed(Duration(
                                                          milliseconds: 1500))
                                                      .whenComplete(() async {
                                                    setState(() {
                                                      _device = d;
                                                    });

                                                    visitorProv
                                                        .confirmPrint(
                                                            authProv.guardId,
                                                            visitorProv.logId,
                                                            widget.reasonId)
                                                        .then((value) async {
                                                      if (value == 'Success') {
                                                        // we will connect the printer
                                                        if (!_connected) {
                                                          print(
                                                              'printer is not connected');

                                                          if (_device != null &&
                                                              _device.address !=
                                                                  null) {
                                                            await bluetoothPrint
                                                                .connect(
                                                                    _device)
                                                                .then((value) {
                                                              Future.delayed(
                                                                      Duration(
                                                                          seconds:
                                                                              6))
                                                                  .whenComplete(
                                                                      () async {
                                                                // take screenshot
                                                                await printScreenShot();
                                                              });
                                                            });
                                                          } else
                                                            print(
                                                                'device is null 1');
                                                        } else {
                                                          print(
                                                              'printer is connected asln');
                                                          // we will take screenshot
                                                          await printScreenShot();
                                                        }
                                                      }
                                                    });
                                                  });
                                                } else {
                                                  Future.delayed(Duration(
                                                          milliseconds: 1500))
                                                      .whenComplete(() async {
                                                    setState(() {
                                                      _device = d;
                                                    });
                                                    visitorProv
                                                        .confirmPrint(
                                                            authProv.guardId,
                                                            visitorProv.logId,
                                                            widget.reasonId)
                                                        .then((value) async {
                                                      if (value == 'Success') {
                                                        // we will update balance
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        prefs.setDouble(
                                                            'balance',
                                                            authProv.balance +
                                                                widget
                                                                    .reasonPrice);
                                                        authProv.balance =
                                                            prefs.getDouble(
                                                                'balance');
                                                        print(
                                                            'new balance in resend is ${authProv.balance}');

                                                        // we will connect the printer
                                                        if (!_connected) {
                                                          print(
                                                              'printer is not connected');

                                                          if (_device != null &&
                                                              _device.address !=
                                                                  null) {
                                                            await bluetoothPrint
                                                                .connect(
                                                                    _device)
                                                                .then((value) {
                                                              Future.delayed(
                                                                      Duration(
                                                                          seconds:
                                                                              6))
                                                                  .whenComplete(
                                                                      () async {
                                                                // take screenshot
                                                                await printScreenShot();
                                                              });
                                                            });
                                                          } else
                                                            print(
                                                                'device is null 2');
                                                        } else {
                                                          print(
                                                              'printer is connected asln');
                                                          // we will take screenshot
                                                          await printScreenShot();
                                                        }
                                                      }
                                                    });
                                                  });
                                                }
                                              } else if (widget.from ==
                                                  'send') {
                                                if (widget.resendType ==
                                                        'Normal' ||
                                                    widget.resendType ==
                                                        'VIP Invitation') {
                                                  //  print('image is ${visitorProv.rokhsa.path}');
                                                  visitorProv
                                                      .checkInInvitation(
                                                    authProv.guardId,
                                                    visitorProv.invitationID,
                                                    context,
                                                    visitorProv.rokhsa,
                                                    visitorProv.idCard,
                                                  )
                                                      .then((value) async {
                                                    if (value.message ==
                                                        'Success') {
                                                      Future.delayed(Duration(
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
                                                                      Duration(
                                                                          seconds:
                                                                              6))
                                                                  .whenComplete(
                                                                      () async {
                                                                await printScreenShot();
                                                              });
                                                            });
                                                          } else
                                                            print(
                                                                'device is null 3');
                                                        } else {
                                                          await printScreenShot();
                                                        }
                                                      });
                                                    }
                                                  });
                                                } else {
                                                  visitorProv
                                                      .checkIn(
                                                          visitorProv.rokhsa,
                                                          visitorProv.idCard,
                                                          authProv.guardId,
                                                          widget.typeId,
                                                          widget.civilCount,
                                                          widget.militaryCount,
                                                          context)
                                                      .then((value) async {
                                                    if (value.message ==
                                                        'Success') {
                                                      prefs.setDouble(
                                                          'balance',
                                                          authProv.balance +
                                                              visitorProv
                                                                  .totalPrice);
                                                      authProv.balance = prefs
                                                          .getDouble('balance');
                                                      print(
                                                          'new balance is ${prefs.getDouble('balance')}');

                                                      Future.delayed(Duration(
                                                              seconds: 1))
                                                          .whenComplete(
                                                              () async {
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
                                                                .connect(
                                                                    _device)
                                                                .then((value) {
                                                              print(
                                                                  'printer is connected with value $value');
                                                              Future.delayed(
                                                                      Duration(
                                                                          seconds:
                                                                              6))
                                                                  .whenComplete(
                                                                      () async {
                                                                await printScreenShot();
                                                              });
                                                            });
                                                          } else
                                                            print(
                                                                'device is null 4');
                                                        } else {
                                                          print(
                                                              'printer is connected 2');
                                                          // secondly we will print
                                                          await printScreenShot();
                                                        }
                                                      });
                                                    }
                                                  });
                                                }
                                              }

                                              /*      ((widget.from!='Normal'  && widget.from!='VIP Invitation' && widget.from!=null))
                                                  ? Future.delayed(Duration(
                                                          milliseconds: 1500))
                                                      .whenComplete(() async {
                                                      print('resend case');
                                                      setState(() {
                                                        _device = d;
                                                      });
                                                      visitorProv.confirmPrint(authProv.guardId, visitorProv.logId, widget.reasonId)
                                                          .then((value) async {
                                                        if (value ==
                                                            'Success') {

                                                          // we will update balance
                                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                                          prefs.setDouble('balance', authProv.balance + widget.reasonPrice);
                                                          authProv.balance = prefs.getDouble('balance');
                                                          print('new balance in resend is ${authProv.balance}');

                                                          // we will connect the printer
                                                          if (!_connected) {
                                                            print('printer is not connected');

                                                            if (isDeviceNotNull) {
                                                              await bluetoothPrint
                                                                  .connect(
                                                                      _device)
                                                                  .then(
                                                                      (value) {
                                                                Future.delayed(Duration(
                                                                        seconds:
                                                                            6))
                                                                    .whenComplete(() async {
                                                                  // take screenshot
                                                                  await printScreenShot();
                                                                });
                                                              });
                                                            } else
                                                              print(
                                                                  'device is null');
                                                          } else {
                                                            print(
                                                                'printer is connected asln');
                                                            // we will take screenshot
                                                            await printScreenShot();
                                                          }
                                                        }
                                                      });
                                                    })


*/

                                              /*        // invitation case
                                                  : (widget.from=='Normal'  || widget.from=='VIP Invitation')
                                                      ? visitorProv
                                                          .checkInInvitation(
                                                          authProv.guardId,
                                                          visitorProv
                                                              .invitationID,
                                                          context,
                                                          visitorProv.rokhsa,
                                                          visitorProv.idCard,
                                                        )
                                                          .then((value) async {
                                                          print('vip case');
                                                          if (value.message ==
                                                              'Success') {
                                                            Future.delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            1))
                                                                .whenComplete(
                                                                    () async {
                                                              setState(() {
                                                                _device = d;
                                                              });

                                                              // first we will connect the printer
                                                              if (!_connected) {
                                                                print(
                                                                    'printer is not connected in vip');

                                                                if (isDeviceNotNull) {
                                                                  await bluetoothPrint
                                                                      .connect(
                                                                          _device)
                                                                      .then(
                                                                          (value) {
                                                                    print(
                                                                        'printer is connected with value $value');
                                                                    Future.delayed(Duration(
                                                                            seconds:
                                                                                6))
                                                                        .whenComplete(
                                                                            () async {
                                                                      await printScreenShot();
                                                                    });
                                                                  });
                                                                } else
                                                                  print(
                                                                      'device is null');
                                                              } else {
                                                                await printScreenShot();
                                                              }
                                                            });
                                                          }
                                                        })


*/
                                            },
                                            title: 'تأكيد',
                                            buttonColor: ColorManager.primary,
                                            titleColor:
                                                ColorManager.backGroundColor,
                                          )
                                        : Container())
                                    .toList(),
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
                                              visibleNotifier.value = true;

                                              if (finishScanning == true) {
                                                bluetoothPrint
                                                    .startScan(
                                                        timeout: Duration(
                                                            seconds: 4))
                                                    .then((value) {
                                                  print(
                                                      'scan result is $value');
                                                  if (snapshot.data.length ==
                                                      0) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Make Sure to open Bluetooth and Location',
                                                        backgroundColor:
                                                            Colors.green,
                                                        toastLength:
                                                            Toast.LENGTH_LONG);
                                                  }
                                                  visibleNotifier.value = false;
                                                });
                                              } else {
                                                Future.delayed(
                                                        Duration(seconds: 2))
                                                    .whenComplete(() {
                                                  visibleNotifier.value = false;
                                                });
                                              }
                                            } catch (error) {
                                              print('error = &error');
                                            }
                                          },
                                          title: 'Refresh',
                                          buttonColor: ColorManager.primary,
                                          titleColor:
                                              ColorManager.backGroundColor,
                                        )
                                      : CircularProgressIndicator(
                                          color: Colors.green,
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
