import '../../../Presentation/guard/entryScreen.dart';
import '../../Colors/colorManager.dart';
import '../../Constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../sharedWidgets.dart';

class HotelGuestDialog extends StatelessWidget {
  final String name;
  final String hotelName;
  final String fromDate;
  final String toDate;
  final Function onPressed;

  const HotelGuestDialog({
    Key key,
    this.name,
    this.fromDate,
    this.toDate,
    this.onPressed,
    this.hotelName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 16,
      child: SizedBox(
        height: 530.h,
        width: 800.w,
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
       /*     SizedBox(
              height: 30.h,
            ),*/
            /*  Padding(
              padding:  EdgeInsets.symmetric(horizontal: 80.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    hotelName,
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(34),
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),     AutoSizeText(
                    'نزيل فندق ',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(34),
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),   */
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 60.w),
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText('نزيل فندق :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    AutoSizeText(
                      hotelName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(30),
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.w),
              child: Divider(
                thickness: 1,
                height: 2.h,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 60.w),
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText('الإسم :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    AutoSizeText(
                      name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(30),
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.w),
              child: Divider(
                thickness: 1,
                height: 2.h,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 60.w),
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText('من :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    AutoSizeText(
                      fromDate,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(30),
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.w),
              child: Divider(
                thickness: 1,
                height: 2.h,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 60.w),
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText('إلى :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    AutoSizeText(
                      toDate,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(30),
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedButton(
                      ontap: onPressed,
                      title: 'تأكيد',
                      height: 60,
                      width: 220,
                      buttonColor: ColorManager.primary,
                      titleColor: ColorManager.backGroundColor,
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    RoundedButton(
                      ontap: () {
                        Navigator.pop(context);
                      },
                      title: 'عودة',
                      width: 220,
                      height: 60,
                      buttonColor: Colors.red,
                      titleColor: ColorManager.backGroundColor,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
