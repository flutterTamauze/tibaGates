import 'package:clean_app/Core/AppStrings/stringsManager.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/sharedWidgets.dart';
import 'package:clean_app/Core/imageAssets/assetsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = '/intro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              Image(
                height: 250.h,
                image: AssetImage(AssetsManager.logo),
              ),
              SizedBox(
                height: 55.h,
              ),
              Text(
                AppStrings.welcomeText,
                style: extraBoldStyle.copyWith(color: ColorManager.primary),
              ),
              SizedBox(
                height: 25.h,
              ),
              Text(
                AppStrings.logintypeText,
                style: boldStyle.copyWith(
                  fontSize: setResponsiveFontSize(
                    14,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50.h,
              ),
              RoundedButton(
                title: "عضو",
                buttonColor: ColorManager.primary,
                titleColor: ColorManager.backGroundColor,
              ),
              SizedBox(
                height: 15.h,
              ),
              RoundedButton(
                buttonColor: ColorManager.primary,
                title: "نزيل",
                titleColor: ColorManager.backGroundColor,
              ),
              SizedBox(
                height: 15.h,
              ),
              RoundedButton(
                buttonColor: Colors.grey,
                title: AppStrings.visitor,
                titleColor: ColorManager.accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
