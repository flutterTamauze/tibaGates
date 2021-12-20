import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class GridViewItemsWidg extends StatelessWidget {
  final String? iconData;
  final String? title;
  final Widget? function;

  GridViewItemsWidg({
    this.iconData,
    this.function,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function,
      child: Card(
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
              Text(
                title!,
                style: TextStyle(
                    color: ColorManager.accentColor,
                    fontWeight: FontWeight.w800,
                    fontSize: setResponsiveFontSize(17)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
