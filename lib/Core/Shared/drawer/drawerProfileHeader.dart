import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerProfileHeader extends StatelessWidget {
  const DrawerProfileHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      width: 270.w,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AutoSizeText(
                  "اسمك",
                  style: boldStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                AutoSizeText(
                  "البريد الألكترونى",
                  style: boldStyle,
                )
              ],
            ),
            SizedBox(
              width: 15.w,
            ),
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                  border: Border.all(color: ColorManager.grey, width: 2),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdpRvftRBgfCbvzOHB0bANVih3QvZD-xZ4flbABUFGDctmaY87ajkJD5RhdvVcyZvkS7U&usqp=CAU"))),
            ),
          ],
        ),
      ),
    );
  }
}
