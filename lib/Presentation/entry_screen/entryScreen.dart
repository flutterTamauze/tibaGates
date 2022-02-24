import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:clean_app/Core/Fonts/fontsManager.dart';
import 'package:clean_app/Core/Shared/exitDialog.dart';
import 'package:clean_app/Presentation/intro_screen/Widgets/outlined_button.dart';
import 'package:clean_app/Presentation/parking_carsList.dart';
import 'package:clean_app/ViewModel/authProv.dart';
import 'package:clean_app/scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Core/Colors/colorManager.dart';
import '../../Core/Constants/constants.dart';
import '../../Core/Shared/sharedWidgets.dart';
import '../home_screen/home.dart';
import '../intro_screen/Screens/login.dart';
List<CameraDescription> cameras;
class EntryScreen extends StatefulWidget {
  static const String routeName = "/firstScreen";

  const EntryScreen({Key key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {






  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
      cachingData();
    });

  }

  void cachingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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
    Provider.of<AuthProv>(context, listen: false).gateId =
        prefs.getInt('gateId');
    Provider.of<AuthProv>(context, listen: false).guardId =
        prefs.getInt('guardId');
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: (){

      },
      child: Scaffold(
        body: SafeArea(
            child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg1.jpeg",
                ),
                fit: BoxFit.fill),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
            child: SingleChildScrollView(
              child: Container(
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
                                        NotPrintedListScreen()));
                          },
                          child: Container(
                            height: 45.h,
                            width: 50.w,
                            child: Center(
                              child: Icon(
                                Icons.directions_car_rounded,
                                color: Colors.blue,
                                size: 36,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                  BorderSide(color: Colors.blue, width: 1.4.w)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 20.h, horizontal: 20.w)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))))),
                        ),
                        OutlinedButton(
                          onPressed: () {
                          },
                          child: Container(
                            height: 45.h,
                            child: Row(
                              children: [
                                Text(
                                    '${Provider.of<AuthProv>(context, listen: true).balance ?? '0'} ',
                                    style: TextStyle(
                                        fontSize: setResponsiveFontSize(28),
                                        fontWeight: FontManager.bold,
                                        color: Colors.red,
                                        fontFamily:
                                            GoogleFonts.getFont('Redressed')
                                                .fontFamily)),
                                Text(
                                  'LE   إجمالى فواتير',
                                  style: TextStyle(
                                      fontSize: setResponsiveFontSize(22),
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                  BorderSide(color: Colors.blue, width: 1.4.w)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 20.h, horizontal: 20.w)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))))),
                        ),

                      ],
                    ),

                    SizedBox(height: 8.h,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => QrCodeScreen(screen: 'invitation',)),
                                  (Route<dynamic> route) => false);
                        },
                        child: Container(
                          height: 45.h,
                          width: 50.w,
                          child: Center(
                            child: Icon(
                              Icons.card_giftcard,
                              color: Colors.orange,
                              size: 36,
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                BorderSide(color: Colors.orange, width: 1.4.w)),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 20.h, horizontal: 20.w)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))))),
                      ),
                    ),
                    SizedBox(height: 15.h,),
                    Hero(
                      tag: "logo",
                      child: ZoomIn(
                        child: Container(
                          height: (height * 0.17),
                          width: (width * 0.32),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: ColorManager.primary, width: 2.w),
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/tipasplash.png")),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100.h,
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
                              ontap: ()async {
                                cameras = await availableCameras();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(camera: cameras[1],)),
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
                                        builder: (context) => QrCodeScreen()),
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
                      height: 220.h,
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
          ),
        )),
      ),
    );
  }
}
