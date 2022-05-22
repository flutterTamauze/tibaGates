
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Utilities/Colors/colorManager.dart';
import '../../../Utilities/Constants/constants.dart';

class MemberDisplay extends StatefulWidget {
  final TextEditingController memberShipController;
  final TextEditingController passwordController;
  final bool isLogin;

  MemberDisplay(
      {this.memberShipController, this.passwordController, this.isLogin});

  @override
  State<MemberDisplay> createState() => _MemberDisplayState();
}

class _MemberDisplayState extends State<MemberDisplay> {
  var _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        maxLengthEnforced: true,
        validator: (text) {
          if (text == '') {
            return 'مطلوب';
          }

          return null;
        },
        controller: widget.memberShipController,
        style: TextStyle(
            color: Colors.black,
            fontSize: setResponsiveFontSize(22),
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
        decoration: kTextFieldDecorationWhite.copyWith(
            hintText: widget.isLogin ? 'اسم المستخدم' : '',
            suffixIcon: Icon(
              Icons.person,
              color: ColorManager.primary,
            )),
      ),
      SizedBox(height: 20.0.h),
      widget.isLogin
          ? TextFormField(
              textInputAction: TextInputAction.next,
              validator: (text) {
                if (text == '') {
                  return 'مطلوب';
                }
                return null;
              },
              controller: widget.passwordController,
              obscureText: _passwordVisible,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: setResponsiveFontSize(22),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              decoration: kTextFieldDecorationWhite.copyWith(
                  hintText: 'كلمة المرور',  prefixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible =
                    !_passwordVisible;
                  });
                },
              ),
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
                RegExp regex = RegExp('^01[0-2|5]{1}[0-9]{8}\$');
                if (text.isEmpty || text == null) {
                  return 'برجاء إدخال رقم هاتفك';
                }
                if (!regex.hasMatch(text)) {
                  return 'برجاء إدخال رقم هاتف صحيح';
                }
                return null;
              },
              controller: widget.passwordController,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: setResponsiveFontSize(22),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              decoration: kTextFieldDecorationWhite.copyWith(
                  hintText: 'رقم الهاتف',
                  suffixIcon: Icon(
                    Icons.phone_android,
                    color: ColorManager.primary,
                  )),
            ),
    ]);
  }
}
