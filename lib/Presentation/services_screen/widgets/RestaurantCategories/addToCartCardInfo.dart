import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddToCardInfo extends StatelessWidget {
  const AddToCardInfo({
    required this.categoryCount,
    required this.categoryName,
    Key? key,
  }) : super(key: key);
  final String categoryName;
  final String categoryCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: MediaQuery.of(context).size.height / 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            categoryName,
            style: extraBoldStyle,
          ),
          AutoSizeText(
            "$categoryCount جنية",
            style: extraBoldStyle.copyWith(
                color: ColorManager.grey, fontSize: setResponsiveFontSize(15)),
          ),
          Row(
            children: [
              AutoSizeText(
                "اضف المنتج الى العربة",
                style: extraBoldStyle.copyWith(
                    color: ColorManager.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: ColorManager.primary,
                    decorationThickness: 1,
                    fontSize: setResponsiveFontSize(15)),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                FontAwesomeIcons.cartPlus,
                color: ColorManager.primary,
                size: 15,
              )
            ],
          ),
        ],
      ),
      width: 300.0.w,
      height: 87.0.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(40.0),
          right: Radius.circular(10.0),
        ),
        color: ColorManager.lightBackGround,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.16),
              offset: Offset(0, 3.0),
              blurRadius: 12.0,
              spreadRadius: 5),
        ],
      ),
    );
  }
}
