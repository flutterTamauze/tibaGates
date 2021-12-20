import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButton extends StatelessWidget {
  final Color? buttonColor, titleColor;
  final String? title;
  RoundedButton({this.buttonColor, this.title, this.titleColor});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, "/home");
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: 220.w,
        height: 45.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18), color: buttonColor),
        child: Center(
          child: AutoSizeText(
            title!,
            style: boldStyle.copyWith(color: titleColor),
          ),
        ),
      ),
    );
  }
}
