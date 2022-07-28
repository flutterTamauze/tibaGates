import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utilities/Constants/constants.dart';

class OutlineButtonFb1 extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const OutlineButtonFb1({this.text, this.onPressed, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const MaterialColor primaryColor = Colors.red;

    const double borderRadius = 20;

    return OutlinedButton(
      onPressed: onPressed,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

        const RotatedBox(
          quarterTurns: 2,
          child: Icon(
            Icons.exit_to_app,
            color: primaryColor,
            size: 36,
          ),
        ), AutoSizeText(
          'خروج مستخدم',
          style: TextStyle(
            fontSize: setResponsiveFontSize(30),
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 2,
          ),
        ),
      ]),
      style: ButtonStyle(
          side: MaterialStateProperty.all(
              BorderSide(color: primaryColor, width: 1.4.w)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 20.h, horizontal: 50.w)),
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius))))),
    );
  }
}
