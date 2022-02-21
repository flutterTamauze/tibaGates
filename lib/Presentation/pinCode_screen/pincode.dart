import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/sharedWidgets.dart';
import 'package:clean_app/Presentation/ProfileSignUp/ProfileSignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PinCodeScreen extends StatefulWidget {
  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  static const String routeName = "/pinCode";
    String firstNum, secondNum, thirdNum, fourthNum;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              AutoSizeText(
                'تفعيل الحساب',
                style: TextStyle(
                  fontSize: setResponsiveFontSize(22),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: AutoSizeText(
                  "برجاء ادخال الرمز التفعيلى المرسل اليكم \n على الرقم التالى 1115******* ",
                  style: TextStyle(
                    fontSize: setResponsiveFontSize(14),
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 28.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _textFieldPinCodeScreen(0, first: true, last: false),
                          _textFieldPinCodeScreen(1, first: false, last: false),
                          _textFieldPinCodeScreen(2, first: false, last: false),
                          _textFieldPinCodeScreen(3, first: false, last: true),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    RoundedButton(
                      title: "تفعيل",
                      buttonColor: ColorManager.primary,
                      titleColor: Colors.white,
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileSignUp(),
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    "إعادة إرسال ",
                    style: TextStyle(
                      fontSize: setResponsiveFontSize(14),
                      fontWeight: FontWeight.bold,
                      color: ColorManager.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AutoSizeText(
                    "لم يصلك الرمز ؟",
                    style: TextStyle(
                      fontSize: setResponsiveFontSize(14),
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldPinCodeScreen(
    int index, {
     bool first,
    last,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 85,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            switch (index) {
              case 0:
                firstNum = value;
                break;
              case 1:
                secondNum = value;
                break;
              case 2:
                thirdNum = value;

                break;
              case 3:
                fourthNum = value;
                print(
                    "Finshed ! ${firstNum + secondNum + thirdNum + fourthNum}");

                break;
              default:
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: setResponsiveFontSize(24), fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: ColorManager.primary),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
