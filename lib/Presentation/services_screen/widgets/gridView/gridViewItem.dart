import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class GridViewItemsWidg extends StatelessWidget {
  final String? iconData;
  final String? title;
  final Function? function;

  GridViewItemsWidg({
    this.iconData,
    this.function,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Center(
                  child: Lottie.asset(
                iconData!,
                repeat: true,
              )),
              height: 120.h,
            ),
            AutoSizeText(
              title!,
              style: TextStyle(
                  color: ColorManager.accentColor,
                  fontWeight: FontWeight.w800,
                  fontSize: setResponsiveFontSize(17)),
            ),
          ],
        ),
      ),
    );
  }
}
