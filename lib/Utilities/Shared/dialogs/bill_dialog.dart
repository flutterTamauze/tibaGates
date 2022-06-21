import 'package:auto_size_text/auto_size_text.dart';
import '../../../Presentation/guard/entryScreen.dart';

import '../../Colors/colorManager.dart';
import '../../Constants/constants.dart';
import '../../../ViewModel/guard/visitorProv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

import '../../../Presentation/guard/guardPrint_Screen.dart';
import '../sharedWidgets.dart';

class BillDialog extends StatelessWidget {
  final citizenValue, militaryValue, typeValue;
  const BillDialog(
      {Key key, this.citizenValue, this.militaryValue, this.typeValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 16,
      child: SizedBox(
        height: 700.h,
        width: 800.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'رسوم الدخول',
              style: TextStyle(
                  fontSize: setResponsiveFontSize(30),
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 60.w),
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('بارك :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    Text(
                      '${Provider.of<VisitorProv>(context, listen: true).parkPrice}',
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
                color: Colors.green,
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
                    Text('رسم دخول مدنى :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    Text(
                      '${Provider.of<VisitorProv>(context, listen: true).citizenPrice}',
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
                color: Colors.green,
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
                    Text('رسم دخول عسكرى :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    Text(
                      '${Provider.of<VisitorProv>(context, listen: true).militaryPrice}',
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
                color: Colors.green,
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
                    Text('إجمالى :             ',
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(36),
                            fontWeight: FontWeight.bold)),
                    Text(
                      '${Provider.of<VisitorProv>(context, listen: true).totalPrice}',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(36),
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
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
                      ontap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrintScreen(
                                      civilCount: citizenValue,
                                      militaryCount: militaryValue,
                                      from: 'send',
                                      typeId: typeValue,
                                    )));
                      },
                      title: 'إستمرار',
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EntryScreen()));
                      },
                      title: 'إلغاء',
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
