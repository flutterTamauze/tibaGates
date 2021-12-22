import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Restaurants/qrCodeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class QrAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)), //this right here
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: 220.h,
              width: 540.w,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                          child: AutoSizeText(
                        "برجاء مسح الكود المفرق علي الطاولة",
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(15),
                            color: ColorManager.primary,
                            fontWeight: FontWeight.w900),
                        textAlign: TextAlign.right,
                      )),
                      Center(
                        child: Lottie.asset("assets/lotties/qr.json",
                            width: 80.w, height: 80.h),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QrCodeScreen(),
                              ));
                        },
                        child: Container(
                          width: 150.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorManager.primary,
                          ),
                          padding: EdgeInsets.all(10),
                          child: AutoSizeText(
                            "مسح الكود",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: setResponsiveFontSize(15),
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ))
          ],
        ));
  }
}
