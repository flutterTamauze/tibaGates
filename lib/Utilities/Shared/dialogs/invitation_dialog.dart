import 'package:Tiba_Gates/Presentation/admin/admin_bottomNav.dart';
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

class InvitationDialog extends StatelessWidget {

  const InvitationDialog(
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 16,
      child: SizedBox(
        height: 600.h,
        width: 800.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'تفاصيل الدعوة',
              style: TextStyle(
                  fontSize: setResponsiveFontSize(30),
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 60.w),
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText('نوع الدعوة :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    AutoSizeText(
                      Provider.of<VisitorProv>(context, listen: true).invitationType,
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
                    Text('صاحب الدعوة :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    Text(
                      Provider.of<VisitorProv>(context, listen: true).invitationName,
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
       /*     Padding(
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
                    Text('تفاصيل الدعوة :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    Text(
                      Provider.of<VisitorProv>(context, listen: true).invitationDescription,
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
            ),*/
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
                    Text('صالحة من :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    Text(
                      Provider.of<VisitorProv>(context, listen: true).invitationCreationDate.toString().split('T').first,
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
            ),   Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 60.w),
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('سوف تنتهى فى :             ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontWeight.bold)),
                    Text(
                      Provider.of<VisitorProv>(context, listen: true).invitationExpireDate.toString().split('T').first,
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

            Center(
              child: RoundedButton(
                ontap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNav(comingIndex: 3,)));
                },
                title: 'عودة',
                width: 220,
                height: 60,
                buttonColor: Colors.red,
                titleColor: ColorManager.backGroundColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
