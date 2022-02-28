/*
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Presentation/entry_screen/entryScreen.dart';
import 'package:clean_app/ViewModel/visitorProv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../sharedWidgets.dart';
import 'loading_dialog.dart';

class ConfirmPrinted extends StatelessWidget {
  final logId;
  const ConfirmPrinted({Key key,@required this.logId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 16,
      child: Container(
        height: 300.h,
        width: 550.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              'تمت الطباعة ؟',
              style: TextStyle(
                  fontSize: setResponsiveFontSize(30),
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.h,
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
                        print(
                            'log id $logId');
                        if (logId !=
                            null) {
                          Provider.of<VisitorProv>(context, listen: false)
                              .confirmPrint(logId)
                              .then((value) {
                            if (value == 'Success') {
                              Navigator.pop(context);
                              */
/*   Fluttertoast.showToast(msg: 'تم',
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white);*//*

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EntryScreen()));
                            }
                          });
                        }
                      },
                      title: 'نعم',
                      height: 60,
                      width: 180,
                      buttonColor: ColorManager.primary,
                      titleColor: ColorManager.backGroundColor,
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    RoundedButton(
                      ontap: () {
                        //showLoaderDialog(context, 'Loading...');
                        Navigator.pop(context);
                        */
/*  Fluttertoast.showToast(msg: 'تم',
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.green,
                            textColor: Colors.white);*//*

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EntryScreen()));
                        */
/*if (Provider
                            .of<VisitorProv>(context, listen: false)
                            .logId != null) {
                          Provider.of<VisitorProv>(context, listen: false)
                              .cancelPrint(Provider
                              .of<VisitorProv>(context, listen: false)
                              .logId)
                              .then((value) {
                            if (value == 'Success') {
                              Navigator.pop(context);
                              Fluttertoast.showToast(msg: 'تم',
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white);

                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (context) => EntryScreen()));
                            }
                          });
                        }*//*

                      },
                      title: 'لا',
                      width: 180,
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
*/
