import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:Tiba_Gates/Utilities/Shared/tiba_logo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
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
import 'entry_screen/entryScreen.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../Utilities/Shared/qr.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import '../../Utilities/connectivityStatus.dart';

List<CameraDescription> cameras;

class PrintScreen2 extends StatefulWidget {
  final typeId, militaryCount, civilCount;
  final from;
  final resendType;
  final logId;
  final reasonId;
  final reasonPrice;
  final perHourObj;

  const PrintScreen2(
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
  _PrintScreen2State createState() => _PrintScreen2State();
}

class _PrintScreen2State extends State<PrintScreen2> {
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

    /* debugPrint(
        'widget.resendType  ${Provider.of<VisitorProv>(context, listen: false).memberShipModel.identityImagePath}');*/
    debugPrint(
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
          debugPrint('value is $value');
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const EntryScreen()));
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var visitorProv = Provider.of<VisitorProv>(context, listen: false);
    var authProv = Provider.of<AuthProv>(context, listen: false);
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);
    return WillPopScope(
      onWillPop: () {
        if (widget.from == 'resend' ||
            widget.typeId == null ||
            widget.resendType == 'perHour') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const EntryScreen()));
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: InkWell(
              onTap: (){
                if (visitorProv.memberShipModel != null) {
                  // keda hwa gy mn scan membership , hanshof lw el swr empty hn5lihom null 34an nb3thom ll database null
                  if (visitorProv.memberShipModel.carImagePath.contains('empty')) {
                    visitorProv.memberShipModel.carImagePath = null;
                  } else if (visitorProv
                      .memberShipModel
                      .identityImagePath
                      .contains(
                      'empty')) {
                    visitorProv
                        .memberShipModel
                        .identityImagePath = null;
                  }

                  // hna b2a hn-call checkInMembership
                  visitorProv
                      .checkInMemberShip(
                      visitorProv.memberShipModel.id
                      ,
                      authProv.userId,

                      context,
                      Provider.of<VisitorProv>(context, listen: false)
                          .memberShipModel
                          .carImagePath
                      ,
                      Provider.of<VisitorProv>(context, listen: false)
                          .memberShipModel
                          .identityImagePath )
                      .then(
                          (value) async {
                        if (value
                            .message ==
                            'Success') {
                          prefs.setDouble(
                              'balance',
                              authProv.balance +
                                  visitorProv.totalPrice);
                          authProv.balance =
                              prefs.getDouble(
                                  'balance');
                          debugPrint(
                              'new balance is ${prefs.getDouble('balance')}');


                        } else if (value
                            .message ==
                            'unAuth') {
                          cameras =
                          await availableCameras();
                          Fluttertoast.showToast(
                              msg:
                              'برجاء تسجيل الدخول من جديد',
                              backgroundColor:
                              Colors
                                  .green,
                              toastLength:
                              Toast.LENGTH_LONG);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                    camera: cameras[1],
                                  )));
                        }
                      });
                }
              },
              child: const Text('Connect your printer')),
        ),
        body: connectionStatus == ConnectivityStatus.Offline
            ? Center(
                child: SizedBox(
                height: 400.h,
                width: 400.w,
                child: Lottie.asset('assets/lotties/noInternet.json'),
              ))
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
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 12.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                TibaLogo(height: height, width: width),
                                                Text(
                                                    'دار الدفاع الجوى - التجمع الخامس',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            setResponsiveFontSize(
                                                                26),
                                                        fontWeight:
                                                            FontManager.bold)),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Provider.of<VisitorProv>(
                                                                context,
                                                                listen: true)
                                                            .printTime !=
                                                        null
                                                    ? Text(
                                                        'Date : ${Provider.of<VisitorProv>(context, listen: true).printTime}',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                setResponsiveFontSize(
                                                                    26),
                                                            fontWeight:
                                                                FontManager
                                                                    .bold),
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
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              26),
                                                      fontWeight:
                                                          FontManager.bold),
                                                ),
                                                SizedBox(
                                                  height: 12.h,
                                                ),
                                                Text(
                                                  'Gate : ${Provider.of<AuthProv>(context, listen: true).gateName}',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              26),
                                                      fontWeight:
                                                          FontManager.bold),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 15),
                                                      child: SizedBox(
                                                        height: (height * 0.13),
                                                        width: (width * 0.3),
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.white,
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/images/hourlyParking.PNG')),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2.w,
                                                          color: Colors.green)),
                                                  child: Qr(
                                                    data: widget.perHourObj !=
                                                            null
                                                        ? widget
                                                            .perHourObj.qrCode
                                                        : Provider.of<VisitorProv>(
                                                                    context,
                                                                    listen:
                                                                        false)
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
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              36),
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      10.h,
                                                                  horizontal:
                                                                      20.w),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${widget.perHourObj.inTime.toString().substring(0, 10)}   ${widget.perHourObj.inTime.toString().substring(11)}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        setResponsiveFontSize(
                                                                            28),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                    'وقت الدخول              ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            setResponsiveFontSize(
                                                                                26),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20.w),
                                                          child: Divider(
                                                            thickness: 1,
                                                            height: 2.h,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      10.h,
                                                                  horizontal:
                                                                      20.w),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${widget.perHourObj.outTime.toString().substring(0, 10)}   ${widget.perHourObj.outTime.toString().substring(11)}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        setResponsiveFontSize(
                                                                            28),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                    'وقت الخروج              ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            setResponsiveFontSize(
                                                                                26),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20.w),
                                                          child: Divider(
                                                            thickness: 1,
                                                            height: 2.h,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      10.h,
                                                                  horizontal:
                                                                      20.w),
                                                          child: Directionality(
                                                            textDirection: ui
                                                                .TextDirection
                                                                .rtl,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    'الإجمالى :             ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            setResponsiveFontSize(
                                                                                28),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(
                                                                  '${widget.perHourObj.total}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          setResponsiveFontSize(
                                                                              30),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
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
                                                      decoration:
                                                          DottedDecoration(
                                                        shape: Shape.box,
                                                        color: Colors.black,
                                                        strokeWidth: 2.w,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10), //remove this to get plane rectange
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 12,
                                                                bottom: 12,
                                                                left: 4,
                                                                right: 4),
                                                        child: Center(
                                                          child:
                                                              Column(children: [
                                                            Text(
                                                              'برجاء الإحتفاظ بالفاتورة لتقديمها عند المغادرة',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  height: 2.h,
                                                                  fontSize:
                                                                      setResponsiveFontSize(
                                                                          28),
                                                                  fontWeight:
                                                                      FontManager
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              ' غرامة فقد التذكرة ${Provider.of<AuthProv>(context, listen: false).lostTicketPrice.toString() ?? 0} جنيه',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  height: 2.h,
                                                                  fontSize:
                                                                      setResponsiveFontSize(
                                                                          28),
                                                                  fontWeight:
                                                                      FontManager
                                                                          .bold),
                                                            ),
                                                          ]),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Center(
                                                child: Text(
                                                  'It\'s our pleasure to serve you \n                  يسعدنا خدمتك',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      height: 2.h,
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              28),
                                                      fontWeight:
                                                          FontManager.bold),
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
                              )
                            : Padding(
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15, right: 8),
                                                  child: SizedBox(
                                                    height: (height * 0.18),
                                                    width: (width * 0.34),
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/tipasplash.png')),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    'دار الدفاع الجوى - التجمع الخامس',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            setResponsiveFontSize(
                                                                26),
                                                        fontWeight:
                                                            FontManager.bold)),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Provider.of<VisitorProv>(
                                                                context,
                                                                listen: true)
                                                            .printTime !=
                                                        null
                                                    ? Text(
                                                        'Date : ${Provider.of<VisitorProv>(context, listen: true).printTime}',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                setResponsiveFontSize(
                                                                    26),
                                                            fontWeight:
                                                                FontManager
                                                                    .bold),
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
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              26),
                                                      fontWeight:
                                                          FontManager.bold),
                                                ),
                                                SizedBox(
                                                  height: 12.h,
                                                ),
                                                Text(
                                                  'Gate : ${Provider.of<AuthProv>(context, listen: true).gateName}',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              26),
                                                      fontWeight:
                                                          FontManager.bold),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                widget.resendType == 'VIP Invitation'
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15,
                                                                  right: 15),
                                                          child: SizedBox(
                                                            height:
                                                                (height * 0.13),
                                                            width:
                                                                (width * 0.3),
                                                            child: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/images/vip.png')),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          ),
                                                        ))
                                                    : Container(),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2.w,
                                                          color: Colors.green)),
                                                  child: Qr(
                                                    data:
                                                        Provider.of<VisitorProv>(
                                                                    context,
                                                                    listen:
                                                                        true)
                                                                .qrCode ??
                                                            'abc',
                                                    size: 270.0.w,
                                                    version: QrVersions.auto,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8.h,
                                                ),
                                                Provider.of<VisitorProv>(
                                                                context,
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
                                                                    FontWeight
                                                                        .bold),
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
                                              (widget.resendType !=
                                                          ('VIP Invitation') &&
                                                      widget.resendType !=
                                                          ('Normal'))
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text:
                                                                'Park Fee  :  ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    setResponsiveFontSize(
                                                                        30),
                                                                fontWeight:
                                                                    FontManager
                                                                        .bold),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: visitorProv
                                                                      .parkPrice
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        setResponsiveFontSize(
                                                                            32),
                                                                  )),
                                                              TextSpan(
                                                                  text: ' LE',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    letterSpacing:
                                                                        1.5,
                                                                    color: Colors
                                                                        .black,
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
                                                        visitorProv.citizenPrice !=
                                                                0
                                                            ? RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      'Civilian Entry Fee  :  ',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          setResponsiveFontSize(
                                                                              30),
                                                                      fontWeight:
                                                                          FontManager
                                                                              .bold),
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                        text: visitorProv
                                                                            .citizenPrice
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              setResponsiveFontSize(32),
                                                                        )),
                                                                    TextSpan(
                                                                        text:
                                                                            ' LE',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          letterSpacing:
                                                                              1.5,
                                                                          color:
                                                                              Colors.black,
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
                                                        visitorProv.militaryPrice !=
                                                                0
                                                            ? RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      'Military Entry Fee :  ',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          setResponsiveFontSize(
                                                                              30),
                                                                      fontWeight:
                                                                          FontManager
                                                                              .bold),
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                        text: visitorProv
                                                                            .militaryPrice
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              setResponsiveFontSize(32),
                                                                        )),
                                                                    TextSpan(
                                                                        text:
                                                                            ' LE',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          letterSpacing:
                                                                              1.5,
                                                                          color:
                                                                              Colors.black,
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
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 250.w),
                                                          child: Container(
                                                            decoration: DottedDecoration(
                                                                shape:
                                                                    Shape.line,
                                                                linePosition:
                                                                    LinePosition
                                                                        .bottom,
                                                                color: Colors
                                                                    .black),
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
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    setResponsiveFontSize(
                                                                        30),
                                                                fontWeight:
                                                                    FontManager
                                                                        .bold),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: visitorProv
                                                                      .totalPrice
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        setResponsiveFontSize(
                                                                            32),
                                                                  )),
                                                              TextSpan(
                                                                  text: ' LE',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1.5,
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
                                                    )
                                                  : Container(),
                                              Container(
                                                decoration: DottedDecoration(
                                                  shape: Shape.box,
                                                  color: Colors.black,
                                                  strokeWidth: 2.w,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), //remove this to get plane rectange
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12,
                                                          bottom: 12,
                                                          left: 4,
                                                          right: 4),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'برجاء الإحتفاظ بالفاتورة لتقديمها عند المغادرة',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              height: 2.h,
                                                              fontSize:
                                                                  setResponsiveFontSize(
                                                                      28),
                                                              fontWeight:
                                                                  FontManager
                                                                      .bold),
                                                        ),
                                                        (widget.resendType !=
                                                                    ('VIP Invitation') &&
                                                                widget.resendType !=
                                                                    ('Normal'))
                                                            ? Text(
                                                                ' غرامة فقد التذكرة ${Provider.of<AuthProv>(context, listen: false).lostTicketPrice.toString() ?? 0} جنيه',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    height: 2.h,
                                                                    fontSize:
                                                                        setResponsiveFontSize(
                                                                            28),
                                                                    fontWeight:
                                                                        FontManager
                                                                            .bold),
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
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              28),
                                                      fontWeight:
                                                          FontManager.bold),
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
                                      children: snapshot.data
                                          .map(
                                              (d) =>
                                                  d.address ==
                                                          Provider.of<AuthProv>(
                                                                  context,
                                                                  listen: false)
                                                              .printerAddress
                                                      ? RoundedButton(
                                                          height: 60,
                                                          width: 220,
                                                          ontap: () async {
                                                            showLoaderDialog(
                                                                context,
                                                                'Loading...');

                                                            SharedPreferences
                                                                prefs =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            /**
                                   *
                                   *                                                              ?*********** CHECKOUT PER HOUR CASE ************
                                   */

                                                            if (widget
                                                                    .perHourObj !=
                                                                null) {
                                                              debugPrint('perHour');

                                                              debugPrint(
                                                                  'userId ${authProv.userId}  logId ${widget.perHourObj.id}');
                                                              setState(() {
                                                                _device = d;
                                                              });

                                                              visitorProv
                                                                  .confirmPerHour(
                                                                widget
                                                                    .perHourObj
                                                                    .id,
                                                                authProv.userId,
                                                              )
                                                                  .then(
                                                                      (value) async {
                                                                        debugPrint(
                                                                    'message is $value');
                                                                        debugPrint(
                                                                    'userId ${authProv.userId}  logId ${widget.perHourObj.id}');
                                                                if (value ==
                                                                    'Success') {
                                                                  prefs.setDouble(
                                                                      'balance',
                                                                      authProv.balance +
                                                                          widget
                                                                              .perHourObj
                                                                              .total);
                                                                  authProv.balance =
                                                                      prefs.getDouble(
                                                                          'balance');
                                                                  debugPrint(
                                                                      'new balance is ${prefs.getDouble('balance')}');
                                                                  // we will connect the printer
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
                                                                        Future.delayed(const Duration(seconds: 6))
                                                                            .whenComplete(() async {
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
                                                                    await printScreenShot();
                                                                  }
                                                                }
                                                              });
                                                            }

                                                            /**
                                   *
                                   *                                                              ?*********** RE-PRINT CASE ************
                                   */
                                                            else if (widget
                                                                    .from ==
                                                                'resend') {
                                                              if (widget.resendType ==
                                                                      'Normal' ||
                                                                  widget.resendType ==
                                                                      'VIP Invitation') {
                                                                Future.delayed(const Duration(
                                                                        milliseconds:
                                                                            1500))
                                                                    .whenComplete(
                                                                        () async {
                                                                  setState(() {
                                                                    _device = d;
                                                                  });

                                                                  visitorProv
                                                                      .confirmPrint(
                                                                          authProv
                                                                              .userId,
                                                                          visitorProv
                                                                              .logId,
                                                                          widget
                                                                              .reasonId)
                                                                      .then(
                                                                          (value) async {
                                                                    if (value ==
                                                                        'Success') {
                                                                      // we will connect the printer
                                                                      if (!_connected) {
                                                                        debugPrint(
                                                                            'printer is not connected');

                                                                        if (_device !=
                                                                                null &&
                                                                            _device.address !=
                                                                                null) {
                                                                          await bluetoothPrint
                                                                              .connect(_device)
                                                                              .then((value) {
                                                                            Future.delayed(const Duration(seconds: 6)).whenComplete(() async {
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
                                                                        await printScreenShot();
                                                                      }
                                                                    }
                                                                  });
                                                                });
                                                              } else if (widget
                                                                      .resendType ==
                                                                  'المحاسبه بالساعه') {

                                                                Future.delayed(const Duration(
                                                                        milliseconds:
                                                                            1500))
                                                                    .whenComplete(
                                                                        () async {
                                                                  setState(() {
                                                                    _device = d;
                                                                  });

                                                                  visitorProv
                                                                      .confirmPrint(
                                                                          authProv
                                                                              .userId,
                                                                          visitorProv
                                                                              .logId,
                                                                          widget
                                                                              .reasonId)
                                                                      .then(
                                                                          (value) async {
                                                                    if (value ==
                                                                        'Success') {
                                                                      prefs.setDouble(
                                                                          'balance',
                                                                          authProv.balance +
                                                                              widget.reasonPrice);
                                                                      authProv.balance =
                                                                          prefs.getDouble(
                                                                              'balance');
                                                                      debugPrint(
                                                                          'new balance in resend is ${authProv.balance}');

                                                                      // we will connect the printer
                                                                      if (!_connected) {
                                                                        debugPrint(
                                                                            'printer is not connected');

                                                                        if (_device !=
                                                                                null &&
                                                                            _device.address !=
                                                                                null) {
                                                                          await bluetoothPrint
                                                                              .connect(_device)
                                                                              .then((value) {
                                                                            Future.delayed(const Duration(seconds: 6)).whenComplete(() async {
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
                                                                        await printScreenShot();
                                                                      }
                                                                    }
                                                                  });
                                                                });
                                                              } else {
                                                                Future.delayed(const Duration(
                                                                        milliseconds:
                                                                            1500))
                                                                    .whenComplete(
                                                                        () async {
                                                                  setState(() {
                                                                    _device = d;
                                                                  });
                                                                  visitorProv
                                                                      .confirmPrint(
                                                                          authProv
                                                                              .userId,
                                                                          visitorProv
                                                                              .logId,
                                                                          widget
                                                                              .reasonId)
                                                                      .then(
                                                                          (value) async {
                                                                    if (value ==
                                                                        'Success') {
                                                                      // we will update balance

                                                                      prefs.setDouble(
                                                                          'balance',
                                                                          authProv.balance +
                                                                              widget.reasonPrice);
                                                                      authProv.balance =
                                                                          prefs.getDouble(
                                                                              'balance');
                                                                      debugPrint(
                                                                          'new balance in resend is ${authProv.balance}');

                                                                      // we will connect the printer
                                                                      if (!_connected) {
                                                                        debugPrint(
                                                                            'printer is not connected');

                                                                        if (_device !=
                                                                                null &&
                                                                            _device.address !=
                                                                                null) {
                                                                          await bluetoothPrint
                                                                              .connect(_device)
                                                                              .then((value) {
                                                                            Future.delayed(Duration(seconds: 6)).whenComplete(() async {
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
                                                                        await printScreenShot();
                                                                      }
                                                                    }
                                                                  });
                                                                });
                                                              }
                                                            }

                                                            /**
                                   *                                                              ?*********** NORMAL PRINT CASE ************
                                   */

                                                            else if (widget
                                                                    .from ==
                                                                'send') {
                                                              if (widget.resendType ==
                                                                      'Normal' ||
                                                                  widget.resendType ==
                                                                      'VIP Invitation') {
                                                                debugPrint(
                                                                    'invitation');
                                                                visitorProv
                                                                    .checkInInvitation(
                                                                  authProv
                                                                      .userId,
                                                                  visitorProv
                                                                      .invitationID,
                                                                  context,
                                                                  visitorProv
                                                                      .rokhsa,
                                                                  visitorProv
                                                                      .idCard,
                                                                )
                                                                    .then(
                                                                        (value) async {
                                                                  if (value
                                                                          .message ==
                                                                      'Success') {
                                                                    Future.delayed(const Duration(
                                                                            seconds:
                                                                                1))
                                                                        .whenComplete(
                                                                            () async {
                                                                      setState(
                                                                          () {
                                                                        _device =
                                                                            d;
                                                                      });

                                                                      // first we will connect the printer
                                                                      if (!_connected) {
                                                                        print(
                                                                            'printer is not connected in invitation');

                                                                        if (_device !=
                                                                                null &&
                                                                            _device.address !=
                                                                                null) {
                                                                          await bluetoothPrint
                                                                              .connect(_device)
                                                                              .then((value) {
                                                                            print('printer is connected with value $value');
                                                                            Future.delayed(const Duration(seconds: 6)).whenComplete(() async {
                                                                              await printScreenShot();
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
                                                              } else if (widget
                                                                      .resendType ==
                                                                  'perHour') {
                                                                debugPrint(
                                                                    'perHour');

                                                                setState(() {
                                                                  _device = d;
                                                                });
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
                                                                      Future.delayed(const Duration(
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
                                                                        'device is null 1');
                                                                  }
                                                                } else {
                                                                  debugPrint(
                                                                      'printer is connected asln');
                                                                  // we will take screenshot
                                                                  await printScreenShot();
                                                                }
                                                              } else {



                                                                if (visitorProv.memberShipModel != null) {
                                                                  // keda hwa gy mn scan membership , hanshof lw el swr empty hn5lihom null 34an nb3thom ll database null
                                                                  if (visitorProv.memberShipModel.carImagePath.contains('empty')) {
                                                                    visitorProv.memberShipModel.carImagePath = null;
                                                                  } else if (visitorProv
                                                                      .memberShipModel
                                                                      .identityImagePath
                                                                      .contains(
                                                                          'empty')) {
                                                                    visitorProv
                                                                        .memberShipModel
                                                                        .identityImagePath = null;
                                                                  }

                                                                  // hna b2a hn-call checkInMembership
                                                                  visitorProv
                                                                      .checkInMemberShip(
                                                                      visitorProv.memberShipModel.id
                                                             ,
                                                                      authProv.userId,

                                                                      context,
                                                                    Provider.of<VisitorProv>(context, listen: false)
                                                                          .memberShipModel
                                                                          .carImagePath
                                                                          ,
                                                                      Provider.of<VisitorProv>(context, listen: false)
                                                                          .memberShipModel
                                                                          .identityImagePath )
                                                                      .then(
                                                                          (value) async {
                                                                        if (value
                                                                            .message ==
                                                                            'Success') {
                                                                          prefs.setDouble(
                                                                              'balance',
                                                                              authProv.balance +
                                                                                  visitorProv.totalPrice);
                                                                          authProv.balance =
                                                                              prefs.getDouble(
                                                                                  'balance');
                                                                          debugPrint(
                                                                              'new balance is ${prefs.getDouble('balance')}');

                                                                          Future.delayed(const Duration(
                                                                              seconds:
                                                                              1))
                                                                              .whenComplete(
                                                                                  () async {
                                                                                setState(
                                                                                        () {
                                                                                      _device =
                                                                                          d;
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
                                                                                        .connect(_device)
                                                                                        .then((value) {
                                                                                      debugPrint('printer is connected with value $value');
                                                                                      Future.delayed(const Duration(seconds: 6)).whenComplete(() async {
                                                                                        await printScreenShot();
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
                                                                          Fluttertoast.showToast(
                                                                              msg:
                                                                              'برجاء تسجيل الدخول من جديد',
                                                                              backgroundColor:
                                                                              Colors
                                                                                  .green,
                                                                              toastLength:
                                                                              Toast.LENGTH_LONG);
                                                                          Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => LoginScreen(
                                                                                    camera: cameras[1],
                                                                                  )));
                                                                        }
                                                                      });
                                                                }
                                                                else{

                                                                  visitorProv
                                                                      .checkIn(
                                                                     visitorProv
                                                                          .rokhsa,
                                                                     visitorProv
                                                                          .idCard,
                                                                      authProv
                                                                          .userId,

                                                                       int.parse(widget
                                                                          .typeId),


                                                                      widget
                                                                          .civilCount,
                                                                      widget
                                                                          .militaryCount,
                                                                      context,
                                                                      null,
                                                                     null)
                                                                      .then(
                                                                          (value) async {
                                                                        if (value
                                                                            .message ==
                                                                            'Success') {
                                                                          prefs.setDouble(
                                                                              'balance',
                                                                              authProv.balance +
                                                                                  visitorProv.totalPrice);
                                                                          authProv.balance =
                                                                              prefs.getDouble(
                                                                                  'balance');
                                                                          debugPrint(
                                                                              'new balance is ${prefs.getDouble('balance')}');

                                                                          Future.delayed(const Duration(
                                                                              seconds:
                                                                              1))
                                                                              .whenComplete(
                                                                                  () async {
                                                                                setState(
                                                                                        () {
                                                                                      _device =
                                                                                          d;
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
                                                                                        .connect(_device)
                                                                                        .then((value) {
                                                                                      debugPrint('printer is connected with value $value');
                                                                                      Future.delayed(const Duration(seconds: 6)).whenComplete(() async {
                                                                                        await printScreenShot();
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
                                                                          Fluttertoast.showToast(
                                                                              msg:
                                                                              'برجاء تسجيل الدخول من جديد',
                                                                              backgroundColor:
                                                                              Colors
                                                                                  .green,
                                                                              toastLength:
                                                                              Toast.LENGTH_LONG);
                                                                          Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => LoginScreen(
                                                                                    camera: cameras[1],
                                                                                  )));
                                                                        }
                                                                      });
                                                                }



                                                              }
                                                            }
                                                          },
                                                          title: 'تأكيد',
                                                          buttonColor:
                                                              ColorManager
                                                                  .primary,
                                                          titleColor: ColorManager
                                                              .backGroundColor,
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
                                                    debugPrint('error = $error');
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
