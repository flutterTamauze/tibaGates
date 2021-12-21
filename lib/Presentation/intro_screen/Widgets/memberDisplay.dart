import 'package:animate_do/animate_do.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemberDisplay extends StatelessWidget {
  final TextEditingController memberShipController;
  final TextEditingController passwordController;
  final bool isLogin;
  MemberDisplay(
      {required this.memberShipController,
      required this.passwordController,
      required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Column(children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          maxLengthEnforced: true,
          validator: (text) {
            if (text == "") {
              return "مطلوب";
            }

            return null;
          },
          controller: memberShipController,
          style: TextStyle(
              color: Colors.black,
              fontSize: setResponsiveFontSize(17),
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
          decoration: kTextFieldDecorationWhite.copyWith(
              hintText: isLogin ? "اسم المستخدم" : "رقم العضوية",
              suffixIcon: Icon(
                Icons.person,
                color: ColorManager.primary,
              )),
        ),
        SizedBox(height: 10.0),
        isLogin
            ? TextFormField(
                textInputAction: TextInputAction.next,
                validator: (text) {
                  if (text == "") {
                    return "مطلوب";
                  }
                  return null;
                },
                controller: passwordController,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: setResponsiveFontSize(17),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
                decoration: kTextFieldDecorationWhite.copyWith(
                    hintText: "كلمة المرور",
                    suffixIcon: Icon(
                      Icons.lock,
                      color: ColorManager.primary,
                    )),
              )
            : TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                maxLengthEnforced: true,
                maxLength: 11,
                validator: (text) {
                  RegExp regex = new RegExp("^01[0-2|5]{1}[0-9]{8}\$");
                  if (text!.isEmpty || text == null) {
                    return 'برجاء إدخال رقم هاتفك';
                  }
                  if (!regex.hasMatch(text)) {
                    return 'برجاء إدخال رقم هاتف صحيح';
                  }
                  return null;
                },
                controller: passwordController,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: setResponsiveFontSize(17),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
                decoration: kTextFieldDecorationWhite.copyWith(
                    hintText: "رقم الهاتف",
                    suffixIcon: Icon(
                      Icons.phone_android,
                      color: ColorManager.primary,
                    )),
              ),
      ]),
    );
  }
}
