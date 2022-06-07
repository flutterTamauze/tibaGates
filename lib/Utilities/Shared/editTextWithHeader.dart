import 'package:Tiba_Gates/Utilities/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputFieldFb1 extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;
  final Color primaryColor;
  final String labelText;

  const CustomInputFieldFb1(
      {Key key,
         this.inputController,
         this.hintText,
         this.labelText,
        this.primaryColor = Colors.green})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      width: MediaQuery.of(context).size.width/2,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: TextField(
          controller: inputController,
          onChanged: (value) {

          },
          keyboardType: TextInputType.number,
          style:  TextStyle(fontSize: setResponsiveFontSize(30), color: Colors.black),
          decoration: InputDecoration(
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black),
            fillColor: Colors.transparent,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            border: UnderlineInputBorder(
              borderSide:
              BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide:
              BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
            ),
          ),
        ),
      ),
    );
  }
}