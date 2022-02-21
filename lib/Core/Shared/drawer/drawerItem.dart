import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerItem extends StatelessWidget {
  final String headerTitle;
  final IconData headerIcon;
  final Color titleColor, iconColor;
  DrawerItem(
      {this.headerIcon, this.headerTitle, this.iconColor, this.titleColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AutoSizeText(
            headerTitle,
            style: boldStyle.copyWith(color: titleColor),
          ),
          SizedBox(
            width: 15.w,
          ),
          Icon(headerIcon, color: iconColor),
        ],
      ),
    );
  }
}
