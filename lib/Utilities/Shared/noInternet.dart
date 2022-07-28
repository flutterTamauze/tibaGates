import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Widget NoInternet(){
  return Center(
      child: SizedBox(
        height: 380.h,
        width: 380.w,
        child: Lottie.asset('assets/lotties/noInternet.json'),
      ));
}