import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class invitationSendDialog extends StatelessWidget {
  final String text;
  const invitationSendDialog({
    Key key,  this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 500.h,
        width: 400.w,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
            /*    Container(
                  alignment:
                  Alignment.topCenter,
                  height: 400.h,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/headerDialog.jpeg',
                    fit: BoxFit.fill,
                  ),
                ),*/
                Positioned(
                    child: Container(
                      width: 400.w,
                      height: 300.h,
                      child: Lottie.asset(
                          'assets/lotties/success.json',
                          repeat: false),
                    )),
              ],
            ),
            SizedBox(
              height: 40.h,
            ),
            Padding(
                padding: const EdgeInsets
                    .symmetric(
                    horizontal: 20),
                child: AutoSizeText(text
                  ,
                  style: TextStyle(
                      fontSize: setResponsiveFontSize(30),
                      color: Colors.green,
                      fontWeight:
                      FontWeight.bold),
                  textAlign:
                  TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}