import 'package:animate_do/animate_do.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'drawerItem.dart';
import 'drawerProfileHeader.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FadeInLeft(
        child: Container(
          color: Color(0xff0B1F42),
          width: 270.w,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              DrawerProfileHeader(),
              Expanded(
                child: ListView(
                  children: [
                    DrawerItem(
                      headerTitle: "الرئيسية",
                      iconColor: ColorManager.primary,
                      headerIcon: Icons.home,
                      titleColor: ColorManager.primary,
                    ),
                    Divider(
                      thickness: 1,
                      height: 20.h,
                      color: ColorManager.backGroundColor,
                    ),
                    DrawerItem(
                      headerTitle: "عن التطبيق",
                      iconColor: ColorManager.backGroundColor,
                      headerIcon: Icons.info,
                      titleColor: ColorManager.backGroundColor,
                    ),
                    Divider(
                      height: 20.h,
                      color: ColorManager.backGroundColor,
                      thickness: 1,
                    ),
                    DrawerItem(
                      headerTitle: "من نحن",
                      iconColor: ColorManager.backGroundColor,
                      headerIcon: FontAwesomeIcons.globe,
                      titleColor: ColorManager.backGroundColor,
                    ),
                    Divider(
                      height: 20.h,
                      color: ColorManager.backGroundColor,
                      thickness: 1,
                    ),
                    DrawerItem(
                      headerTitle: "الأعدادات",
                      iconColor: ColorManager.backGroundColor,
                      headerIcon: Icons.settings,
                      titleColor: ColorManager.backGroundColor,
                    ),
                    Divider(
                      height: 20.h,
                      color: ColorManager.backGroundColor,
                      thickness: 1,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
