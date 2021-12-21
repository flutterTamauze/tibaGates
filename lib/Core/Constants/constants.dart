import 'package:clean_app/Core/Fonts/fontsManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kTextFieldDecorationWhite = InputDecoration(
  isDense: true,

  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
  hintText: 'Enter a value',
  hintStyle:
      TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
  fillColor: Colors.white,
  filled: true,
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffD7D7D7), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
//  contentPadding: EdgeInsets.symmetric(),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff4a4a4a), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff4a4a4a), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
TextStyle boldStyle = TextStyle(
    fontWeight: FontManager.bold, fontSize: setResponsiveFontSize(16));
TextStyle extraBoldStyle = TextStyle(
    fontWeight: FontManager.extraBold, fontSize: setResponsiveFontSize(20));
setResponsiveFontSize(size) {
  return ScreenUtil().setSp(size);
}

const Color facebookColor = const Color(0xff39579A);
const Color twitterColor = const Color(0xff00ABEA);
const Color instaColor = const Color(0xffBE2289);
const Color whatsappColor = const Color(0xff075E54);
const Color googleColor = const Color(0xffDF4A32);
