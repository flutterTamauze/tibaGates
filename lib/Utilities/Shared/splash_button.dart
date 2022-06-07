import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const SplashButton(
      { this.title,
         this.onPressed,

        Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.green,
        child: Container(
          width:220.w ,
          height: 55.h,
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5.0)),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green),
          ),
        ),
      ),
    );
  }
}