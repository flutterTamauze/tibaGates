import 'dart:io';
import 'package:Tiba_Gates/Utilities/Shared/dialogs/hotel_guest_dialog.dart';
import 'package:Tiba_Gates/ViewModel/common/commonProv.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:Tiba_Gates/Utilities/Shared/dialogs/exit_dialog2.dart';
import 'package:Tiba_Gates/Utilities/Shared/noInternet.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../Utilities/connectivityStatus.dart';
import 'package:lottie/lottie.dart';
import '../login_screen/Widgets/outlined_button.dart';

import 'parking_carsList.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/exitDialog.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import '../../ViewModel/guard/authProv.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'g_home_screen.dart';

List<CameraDescription> cameras;

class EntryScreen extends StatefulWidget {
  static const String routeName = '/firstScreen';

  const EntryScreen({Key key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  String token;
  Future balanceListener;

  @override
  void initState() {
    super.initState();
    if (Provider.of<VisitorProv>(context, listen: false).memberShipModel !=
        null) {
      Provider.of<VisitorProv>(context, listen: false).memberShipModel = null;
    }

    token = prefs.getString('token');
    debugPrint(token);
    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
      cachingData().whenComplete(() {
        balanceListener =
            Provider.of<AuthProv>(context, listen: false).getBalanceById(
          prefs.getString('guardId'),
          'Guard',
        );
      });
    });
  }

  Future<void> cachingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Provider.of<VisitorProv>(context, listen: false).logId = null;
    Provider.of<AuthProv>(context, listen: false).guardName =
        prefs.getString('guardName');
    Provider.of<AuthProv>(context, listen: false).printerAddress =
        prefs.getString('printerAddress');
    Provider.of<AuthProv>(context, listen: false).balance =
        prefs.getDouble('balance');
    Provider.of<AuthProv>(context, listen: false).lostTicketPrice =
        prefs.getDouble('ticketLostPrice');
    Provider.of<AuthProv>(context, listen: false).gateName =
        prefs.getString('gateName');
    Provider.of<AuthProv>(context, listen: false).token =
        prefs.getString('token');
    Provider.of<AuthProv>(context, listen: false).userId =
        prefs.getString('guardId');
    Provider.of<AuthProv>(context, listen: false).parkTypes =
        prefs.getStringList('parkingTypes');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);
    CommonProv commonProv = Provider.of<CommonProv>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: connectionStatus == ConnectivityStatus.Offline
            ? NoInternet()
            : SafeArea(
                child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/bg1.jpeg',
                      ),
                      fit: BoxFit.fill),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                navigateReplacementTo(
                                    context, const NotPrintedListScreen());
                              },
                              child: SizedBox(
                                height: 45.h,
                                width: 50.w,
                                child: const Center(
                                  child: Icon(
                                    Icons.directions_car_rounded,
                                    color: Colors.blue,
                                    size: 36,
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                      color: Colors.blue, width: 1.4.w)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 20.h, horizontal: 20.w)),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))))),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              child: SizedBox(
                                height: 45.h,
                                child: Row(
                                  children: [
                                    FutureBuilder(
                                        future: balanceListener,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: Platform.isIOS
                                                  ? const CupertinoActivityIndicator()
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    ),
                                            );
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return AutoSizeText(
                                                '${Provider.of<AuthProv>(context, listen: true).balance ?? '--'} ',
                                                style: TextStyle(
                                                  fontSize:
                                                      setResponsiveFontSize(28),
                                                  fontWeight: FontManager.bold,
                                                  color: Colors.red,
                                                ));
                                          }
                                          return Container();
                                        }),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.w),
                                      child: AutoSizeText(
                                        Provider.of<AuthProv>(context,
                                                    listen: true)
                                                .guardName ??
                                            '',
                                        style: TextStyle(
                                            fontSize: setResponsiveFontSize(22),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    AutoSizeText(
                                      ' إجمالى فواتير',
                                      style: TextStyle(
                                        fontSize: setResponsiveFontSize(22),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                      color: Colors.blue, width: 1.4.w)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 20.h, horizontal: 20.w)),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Hero(
                          tag: 'logo',
                          child: ZoomIn(
                            child: SizedBox(
                              height: (height * 0.17),
                              width: (width * 0.32),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: ColorManager.primary, width: 2.w),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/tipasplash.png')),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80.h,
                        ),
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 70.h, horizontal: 70.w),
                            child: Column(
                              children: [
                                RoundedButton(
                                  ontap: () async {
                                    cameras = await availableCameras();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                                  camera: cameras[1],
                                                )),
                                        (Route<dynamic> route) => false);
                                  },
                                  title: 'تسجيل دخول',
                                  width: 250,
                                  height: 55,
                                  buttonColor: ColorManager.primary,
                                  titleColor: ColorManager.backGroundColor,
                                ),
                                SizedBox(
                                  height: 26.h,
                                ),
                                RoundedButton(
                                  ontap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const QrCodeScreen()),
                                        (Route<dynamic> route) => false);
                                  },
                                  title: 'تسجيل خروج',
                                  width: 250,
                                  height: 55,
                                  buttonColor: Colors.red,
                                  titleColor: ColorManager.backGroundColor,
                                ),
                                SizedBox(
                                  height: 26.h,
                                ),
                                RoundedButton(
                                  ontap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const QrCodeScreen(
                                                  screen: 'invitation',
                                                )),
                                        (Route<dynamic> route) => false);
                                  },
                                  title: 'دعوة/حجز إلكترونى',
                                  width: 250,
                                  height: 55,
                                  buttonColor: Colors.blue,
                                  titleColor: ColorManager.backGroundColor,
                                ),
                                SizedBox(
                                  height: 26.h,
                                ),
                                RoundedButton(
                                  ontap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const QrCodeScreen(
                                                  screen: 'memberShip',
                                                )),
                                        (Route<dynamic> route) => false);
                                  },
                                  title: 'أنشطة',
                                  width: 250,
                                  height: 55,
                                  buttonColor: Colors.orange,
                                  titleColor: ColorManager.backGroundColor,
                                ),
                                SizedBox(
                                  height: 26.h,
                                ),
                                RoundedButton(
                                  ontap: () async {
                                    String barCode;
                                    try {
                                      barCode = await FlutterBarcodeScanner
                                          .scanBarcode('#FF039212', 'Cancel',
                                              true, ScanMode.BARCODE);
                                      commonProv
                                          .checkBarcodeValidation(barCode)
                                          .then((value) {
                                        if (value == 'Success') {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return HotelGuestDialog(
                                                  name: commonProv
                                                      .hotelGuestModel
                                                      .guestName,
                                                  fromDate: DateFormat(
                                                          'yyyy-MM-dd / hh:mm')
                                                      .format(DateTime.parse(
                                                          commonProv
                                                              .hotelGuestModel
                                                              .startDate))
                                                      .toString(),
                                                  hotelName: commonProv
                                                      .hotelGuestModel
                                                      .hotelName,
                                                  toDate: DateFormat(
                                                          'yyyy-MM-dd / hh:mm')
                                                      .format(DateTime.parse(
                                                          commonProv
                                                              .hotelGuestModel
                                                              .endDate))
                                                      .toString(),
                                                  onPressed: () {
                                                    debugPrint('log id is ${commonProv.hotelGuestModel.id}');
                                                    commonProv.confirmBarcodeLog(commonProv.hotelGuestModel.id)
                                                        .then((value) {
                                                      if (value == 'Success') {
                                                        showToast(
                                                            'تم التأكيد بنجاح');
                                                        Navigator.pop(context);
                                                      } else {
                                                        showToast('حدث خطأ ما');
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  },
                                                );
                                              });
                                        } else {
                                          showToast('كود غير صحيح');
                                          debugPrint('value is $value');
                                        }
                                      });
                                    } on PlatformException {
                                      barCode = 'Failed to get barcode';
                                    }
                                    if (!mounted) {
                                      return;
                                    }
                                  },
                                  title: 'باركود',
                                  width: 250,
                                  height: 55,
                                  buttonColor: Colors.black,
                                  titleColor: ColorManager.backGroundColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80.h,
                        ),
                        FadeInUp(
                            child: OutlineButtonFb1(
                          text: 'Logout',
                          onPressed: () => showDialog<Dialog>(
                              context: context,
                              builder: (BuildContext context) =>
                                  ZoomIn(child: const DialogFb1())),
                        ))
                      ],
                    ),
                  ),
                ),
              )),
      ),
    );
  }

  Future<void> scanBarcode() async {
    String barCode;
    try {
      barCode = await FlutterBarcodeScanner.scanBarcode(
          '', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barCode = 'Failed to get barcode';
    }
    if (!mounted) {
      return;
    }
  }
}
