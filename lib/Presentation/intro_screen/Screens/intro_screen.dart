import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/sharedWidgets.dart';
import 'package:clean_app/Core/imageAssets/assetsManager.dart';
import 'package:clean_app/Data/Models/user.dart';
import 'package:clean_app/Presentation/home_screen/Screens/home.dart';
import 'package:clean_app/Presentation/intro_screen/Screens/register.dart';
import 'package:clean_app/Presentation/intro_screen/Widgets/memberDisplay.dart';

import 'package:clean_app/Presentation/intro_screen/Widgets/userType_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';

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
  var isLoading = false;
  var _passwordVisible = true;

  @override
  void initState() {
    super.initState();
  }

  bool isArabic = true;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
                      image: AssetImage(AssetsManager.plazaBackground),
                      fit: BoxFit.fill)),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "logo",
                    child: Container(
                      height: (height * 0.18),
                      width: (width * 0.36),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/logo1.jpg")),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: ColorManager.primary, width: 2.w),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BorderedText(
                        strokeWidth: 4.0.w,
                        strokeColor: Colors.black,
                        child: Text(
                          "Tipa Rose\n دار الدفاع الجوى ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 2,
                              fontSize: setResponsiveFontSize(20),
                              decoration: TextDecoration.none,
                              decorationColor: Colors.black,
                              height: 1.5.h,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  SizedBox(
                    height: 24.h,
                  ),
                  Center(
                    child: Container(
                      width: 330.w,
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
                                                setResponsiveFontSize(16)),
                                      ),
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      SizedBox(height: 10.0.h),
                                      MemberDisplay(
                                        isLogin: true,
                                        memberShipController:
                                            _memberShipController,
                                        passwordController: _passwordController,
                                      ),
                                      SizedBox(
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
                                      ),
                                      SizedBox(
                                        height: 20.0.h,
                                      ),
                                      isLoading
                                          ? Center(
                                              child: Platform.isIOS
                                                  ? CupertinoActivityIndicator()
                                                  : CircularProgressIndicator(
                                                      backgroundColor:
                                                          ColorManager.primary,
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<
                                                                  Color>(
                                                              ColorManager
                                                                  .primary),
                                                    ),
                                            )
                                          : RoundedButton(
                                              ontap: () {
                                                User user = User(
                                                    memberId: "",
                                                    email: "",
                                                    job: "",
                                                    password: "",
                                                    phoneNumber: "",
                                                    roomNumber: "",
                                                    userName: "",
                                                    userType: 0);
                                                if (!_forgetFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  return;
                                                } else {
                                                  user = user1;
                                                  if (user.memberId ==
                                                          _memberShipController
                                                              .text &&
                                                      user.password ==
                                                          _passwordController
                                                              .text) {
                                                    Navigator.pushNamed(context,
                                                        HomePage.routeName,
                                                        arguments: user);
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Invalid Account ! ",
                                                        backgroundColor:
                                                            Colors.red,
                                                        gravity: ToastGravity
                                                            .CENTER);
                                                  }
                                                }
                                              },
                                              title: 'تسجيل',
                                              buttonColor: ColorManager.primary,
                                              titleColor:
                                                  ColorManager.backGroundColor,
                                            ),
                                      SizedBox(
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
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                        "او الدخول كزائر",
                                        style: boldStyle,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      FadeInDown(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child: Center(
                                                child: Icon(
                                                  FontAwesomeIcons.facebookF,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 6,
                                                      offset: Offset(0, 4),
                                                    )
                                                  ],
                                                  shape: BoxShape.circle,
                                                  color: facebookColor),
                                            ),
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child: Center(
                                                child: Icon(
                                                  FontAwesomeIcons.googlePlusG,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 6,
                                                      offset: Offset(0, 4),
                                                    )
                                                  ],
                                                  shape: BoxShape.circle,
                                                  color: googleColor),
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isArabic = !isArabic;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 50.w,
                                                    height: 50.h,
                                                    child: Center(
                                                      child: Icon(
                                                        FontAwesomeIcons.globe,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 1,
                                                            blurRadius: 6,
                                                            offset:
                                                                Offset(0, 4),
                                                          )
                                                        ],
                                                        shape: BoxShape.circle,
                                                        color: ColorManager
                                                            .lightGrey),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                AutoSizeText(
                                                  isArabic ? "AR" : "EN",
                                                  style: boldStyle,
                                                )
                                              ],
                                            )
                                            // CustomWidgets.socialButtonRect(
                                            //     'Login with Facebook',
                                            //     facebookColor,
                                            //     FontAwesomeIcons.facebookF,
                                            //     onTap: () {}),
                                            // CustomWidgets.socialButtonRect(
                                            //     'Login with Google',
                                            //     googleColor,
                                            //     FontAwesomeIcons.googlePlusG,
                                            //     onTap: () {}),
                                          ],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
