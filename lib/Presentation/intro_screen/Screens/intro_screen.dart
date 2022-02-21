import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/sharedWidgets.dart';
import 'package:clean_app/Core/imageAssets/assetsManager.dart';
import 'package:clean_app/Presentation/intro_screen/Screens/register.dart';
import 'package:clean_app/Presentation/intro_screen/Widgets/memberDisplay.dart';
import 'package:clean_app/Presentation/entry_screen/entryScreen.dart';
import 'package:clean_app/ViewModel/authProv.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  static const String routeName = "/intro";

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _forgetFormKey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _roomNumberController = TextEditingController();
  TextEditingController _memberShipController = TextEditingController();

  var _passwordVisible = true;
  SharedPreferences prefs;
  bool isLoggedIn;


  @override
  void initState() {
    super.initState();
  }

  bool isArabic = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var authProv = Provider.of<AuthProv>(context, listen: true);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/tiba.jpg'),
                      fit: BoxFit.fitHeight)),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "logo",
                    child: Container(
                      height: (height * 0.15),
                      width: (width * 0.32),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/tipasplash.png")),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: ColorManager.primary, width: 2.w),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BorderedText(
                        strokeWidth: 4.0.w,
                        strokeColor: Colors.black,
                        child: Text(
                          "Tiba Rose دار الدفاع الجوى ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 2,
                              fontSize: setResponsiveFontSize(26),
                              decoration: TextDecoration.none,
                              decorationColor: Colors.black,
                              height: 1.5.h,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  SizedBox(
                    height: 36.h,
                  ),
                  Center(
                    child: Container(
                      width: 500.w,
                      height: 400.h,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 4,
                        child: Column(
                          children: [
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Form(
                                  key: _forgetFormKey,
                                  child: Column(
                                    children: <Widget>[
                                      AutoSizeText(
                                        'قم بتسجيل الدخول',
                                        style: TextStyle(
                                            color: ColorManager.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                setResponsiveFontSize(24)),
                                      ),
                                      SizedBox(
                                        height: 25.h,
                                      ),
                                      MemberDisplay(
                                        isLogin: true,
                                        memberShipController:
                                            _memberShipController,
                                        passwordController: _passwordController,
                                      ),
                                      /*        SizedBox(
                                        height: 10.0.h,
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: AutoSizeText(
                                          'نسيت كلمة المرور ؟',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize:
                                                  setResponsiveFontSize(15)),
                                        ),
                                      ),*/
                                      SizedBox(
                                        height: 25.0.h,
                                      ),
                                      Provider.of<AuthProv>(context,
                                                  listen: true)
                                              .loadingState
                                          ? Center(
                                              child: Platform.isIOS
                                                  ? CupertinoActivityIndicator()
                                                  : CircularProgressIndicator(
                                                      backgroundColor:
                                                          ColorManager.primary,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              ColorManager
                                                                  .primary),
                                                    ),
                                            )
                                          : RoundedButton(
                                              height: 55,
                                              width: 220,
                                              ontap: () {
                                                if (!_forgetFormKey.currentState
                                                    .validate()) {
                                                  return;
                                                } else {
                                                  authProv
                                                      .changeLoadingState(true);
                                                  print('aaaaaa');
                                                  Provider.of<AuthProv>(context,
                                                          listen: false)
                                                      .login(
                                                          _memberShipController
                                                              .text,
                                                          _passwordController
                                                              .text)
                                                      .then((value) async {
                                                    authProv.changeLoadingState(
                                                        false);
                                                    print('value => $value');
                                                    if (value == 'Success') {
                                                      prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      print('caching data');
                                                      prefs.setInt(
                                                          'guardId',
                                                          Provider.of<AuthProv>(
                                                                  context,
                                                                  listen: false)
                                                              .guardId);
                                                      prefs.setInt(
                                                          'gateId',
                                                          Provider.of<AuthProv>(
                                                                  context,
                                                                  listen: false)
                                                              .gateId);
                                                      prefs.setString(
                                                          'guardName',
                                                          Provider.of<AuthProv>(
                                                                  context,
                                                                  listen: false)
                                                              .guardName);
                                                      prefs.setDouble(
                                                          'balance',
                                                          Provider.of<AuthProv>(
                                                                  context,
                                                                  listen: false)
                                                              .balance);
                                                      prefs.setString(
                                                          'printerAddress',
                                                          Provider.of<AuthProv>(
                                                                  context,
                                                                  listen: false)
                                                              .printerAddress??'');
                                                      prefs.setString(
                                                          'gateName',
                                                          Provider.of<AuthProv>(
                                                                  context,
                                                                  listen: false)
                                                              .gateName);
                                                      prefs.setBool(
                                                          'isLoggedIn',
                                                          Provider.of<AuthProv>(
                                                                  context,
                                                                  listen: false)
                                                              .isLogged);
                                                      prefs.setString(
                                                          'guardRank',
                                                          Provider.of<AuthProv>(
                                                                  context,
                                                                  listen: false)
                                                              .rank);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EntryScreen()));
                                                    } else if (value ==
                                                        'Incorrect User') {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'بيانات غير صحيحة',
                                                          backgroundColor:
                                                              Colors.green,
                                                          toastLength: Toast
                                                              .LENGTH_LONG);
                                                    }
                                                  });
                                                }
                                              },
                                              title: 'تسجيل',
                                              buttonColor: ColorManager.primary,
                                              titleColor:
                                                  ColorManager.backGroundColor,
                                            ),
                                      /*          SizedBox(
                                        height: 10.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Register(),
                                              ));
                                        },
                                        child: Container(
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'ليس لديك حساب ؟',
                                              style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(13),
                                                fontFamily: "Almarai",
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: ' إنشاء حساب',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          ColorManager.primary,
                                                      fontFamily: "Almarai",
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              13),
                                                      decoration: TextDecoration
                                                          .underline,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),*/
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
