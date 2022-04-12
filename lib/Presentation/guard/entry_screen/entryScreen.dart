import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../Utilities/connectivityStatus.dart';
import 'package:lottie/lottie.dart';
import '../../login_screen/Widgets/outlined_button.dart';

import '../parking_carsList.dart';
import '../../../Utilities/Colors/colorManager.dart';
import '../../../Utilities/Constants/constants.dart';
import '../../../Utilities/Fonts/fontsManager.dart';
import '../../../Utilities/Shared/exitDialog.dart';
import '../../../Utilities/Shared/sharedWidgets.dart';
import '../../../ViewModel/guard/authProv.dart';
import '../../../ViewModel/guard/visitorProv.dart';
import '../scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../home_screen/g_home_screen.dart';

List<CameraDescription> cameras;

class EntryScreen extends StatefulWidget {
  static const String routeName = '/firstScreen';

  const EntryScreen({Key key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  String token;

  @override
  void initState() {
    super.initState();

    if (Provider.of<VisitorProv>(context, listen: false).memberShipModel !=
        null) {

      Provider.of<VisitorProv>(context, listen: false)
          .memberShipModel
           = null;


    }
    token = prefs.getString('token');
    print(token);
    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
      cachingData();
    });
  }

  void cachingData() async {
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

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: connectionStatus == ConnectivityStatus.Offline
            ? Center(
                child: SizedBox(
                height: 400.h,
                width: 400.w,
                child: Lottie.asset('assets/lotties/noInternet.json'),
              ))
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
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NotPrintedListScreen()));
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
                                    Text(
                                        '${Provider.of<AuthProv>(context, listen: true).balance ?? '0'} ',
                                        style: TextStyle(
                                          fontSize: setResponsiveFontSize(28),
                                          fontWeight: FontManager.bold,
                                          color: Colors.red,
                                        )),
                                    Text(
                                      Provider.of<AuthProv>(context,
                                                  listen: true)
                                              .guardName ??
                                          '',
                                      style: TextStyle(
                                          fontSize: setResponsiveFontSize(22),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
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
                          height: 8.h,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const QrCodeScreen(
                                            screen: 'invitation',
                                          )),
                                  (Route<dynamic> route) => false);
                            },
                            child: SizedBox(
                              height: 45.h,
                              width: 50.w,
                              child: const Center(
                                child: Icon(
                                  Icons.qr_code,
                                  color: Colors.orange,
                                  size: 36,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Colors.orange, width: 1.4.w)),
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
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const QrCodeScreen(
                                            screen: 'memberShip',
                                          )),
                                  (Route<dynamic> route) => false);
                            },
                            child: SizedBox(
                              height: 45.h,
                              width: 50.w,
                              child: const Center(
                                child: Icon(
                                  FontAwesomeIcons.futbol,
                                  color: Colors.pink,
                                  size: 36,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Colors.pink, width: 1.4.w)),
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
                                  width: 220,
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
                                  width: 220,
                                  height: 55,
                                  buttonColor: Colors.red,
                                  titleColor: ColorManager.backGroundColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150.h,
                        ),
                        FadeInUp(
                            child: OutlineButtonFb1(
                          text: 'Logout',
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) => ZoomIn(
                                      child: const exitDialog(),
                                    ));
                          },
                        ))
                      ],
                    ),
                  ),
                ),
              )),
      ),
    );
  }
}
