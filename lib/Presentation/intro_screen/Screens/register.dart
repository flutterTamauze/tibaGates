import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/sharedWidgets.dart';
import 'package:clean_app/Core/imageAssets/assetsManager.dart';
import 'package:clean_app/Presentation/intro_screen/Screens/intro_screen.dart';
import 'package:clean_app/Presentation/intro_screen/Widgets/memberDisplay.dart';
import 'package:clean_app/Presentation/intro_screen/Widgets/residentDisplay.dart';
import 'package:clean_app/Presentation/intro_screen/Widgets/social.dart';
import 'package:clean_app/Presentation/intro_screen/Widgets/userType_dropdown.dart';
import 'package:clean_app/Presentation/pinCode_screen/pincode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class Register extends StatefulWidget {
  final screen;

  const Register({this.screen});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _forgetFormKey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _unitNumberController = TextEditingController();
  TextEditingController _roomNumberController = TextEditingController();
  TextEditingController _memberShipController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var isLoading = false;
  String userType = "عضو دار";
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AssetsManager.plazaBackground),
                    fit: BoxFit.fitHeight)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.screen != 'forgetPass'
                    ? Hero(
                        tag: "logo",
                        child: Container(
                          height: (height * 0.18),
                          width: (width * 0.36),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(AssetsManager.logo),
                                  fit: BoxFit.fill),
                              border: Border.all(
                                  color: ColorManager.primary, width: 2.w),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                widget.screen != 'forgetPass'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BorderedText(
                          strokeWidth: 4.0.w,
                          strokeColor: Colors.black,
                          child: Text(
                            "Tipa Rose \n فى  دار الدفاع ",
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
                        ))
                    : Container(),
                SizedBox(
                  height: 24.h,
                ),
                Center(
                  child: Container(
                    height: 450.h,
                    width: 330.w,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              height:
                                  (MediaQuery.of(context).size.height) / 1.2,
                              child: Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Form(
                                  key: _forgetFormKey,
                                  child: Column(
                                    children: <Widget>[
                                      AutoSizeText(
                                        widget.screen == 'forgetPass'
                                            ? 'ادخل بياناتك ليصلك كود تأكيد'
                                            : 'إنشاء حساب جديد',
                                        style: TextStyle(
                                            color: ColorManager.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                setResponsiveFontSize(16)),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      UserTypeDropdown(
                                        function: (String newValue) {
                                          setState(() {
                                            userType = newValue;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 10.0.h),
                                      userType == "عضو دار"
                                          ? MemberDisplay(
                                              isLogin: false,
                                              memberShipController:
                                                  _memberShipController,
                                              passwordController:
                                                  _phoneNumberController,
                                            )
                                          : userType == "نزيل فندق"
                                              ? ResidentDisplay(
                                                  phoneController:
                                                      _phoneNumberController,
                                                  roomController:
                                                      _roomNumberController,
                                                )
                                              : Container(),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    IntroScreen(),
                                              ));
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            text: ' لديك حساب بالفعل ؟',
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(14),
                                                fontFamily: "Almarai",
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: ' تسجيل الدخول ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                    fontSize:
                                                        setResponsiveFontSize(
                                                            14),
                                                    fontFamily: "Almarai",
                                                    decoration: TextDecoration
                                                        .underline,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30.0.h,
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
                                                if (!_forgetFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  return;
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PinCodeScreen(),
                                                      ));
                                                }
                                              },
                                              buttonColor: ColorManager.primary,
                                              titleColor:
                                                  ColorManager.backGroundColor,
                                              title:
                                                  widget.screen != 'forgetPass'
                                                      ? 'تسجيل'
                                                      : 'إرسال',
                                            )
                                    ],
                                  ),
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
    );
  }
}
