import 'package:clean_app/Core/Fonts/fontsManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle boldStyle = TextStyle(
    fontWeight: FontManager.bold, fontSize: setResponsiveFontSize(16));
TextStyle extraBoldStyle = TextStyle(
    fontWeight: FontManager.extraBold, fontSize: setResponsiveFontSize(20));
setResponsiveFontSize(size) {
  return ScreenUtil().setSp(size);
}
