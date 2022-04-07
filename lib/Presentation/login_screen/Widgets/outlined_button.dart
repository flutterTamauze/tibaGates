import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Utilities/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OutlineButtonFb1 extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const OutlineButtonFb1({this.text, this.onPressed, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.red;

    const double borderRadius = 20;

    return OutlinedButton(
      onPressed: onPressed,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          'Sign Out',
          style: TextStyle(
              fontSize: setResponsiveFontSize(30),
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 2,
              ),
        ),
        const Icon(
          Icons.exit_to_app,
          color: primaryColor,
          size: 36,
        )
      ]),
      style: ButtonStyle(
          side: MaterialStateProperty.all(
              BorderSide(color: primaryColor, width: 1.4.w)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 20.h, horizontal: 50.w)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius:
                  const BorderRadius.all(Radius.circular(borderRadius))))),
    );
  }
}
