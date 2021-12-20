import 'package:clean_app/Core/AppStrings/stringsManager.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AnimatedBottomNavBar extends StatelessWidget {
  const AnimatedBottomNavBar({
    required this.getCurrentIndex,
    Key? key,
  }) : super(key: key);
  final Function getCurrentIndex;
  @override
  Widget build(BuildContext context) {
    return GNav(
        onTabChange: (value) {
          getCurrentIndex(value);
        },
        selectedIndex: 3,
        tabMargin: EdgeInsets.all(5),
        tabBorderRadius: 5,
        tabActiveBorder:
            Border.all(color: ColorManager.grey, width: 1), // tab button border
        rippleColor: ColorManager.primary,
        curve: Curves.easeOutExpo, // tab animation curves
        duration: Duration(milliseconds: 500), // tab animation duration
        gap: 15, // the tab button gap between icon and text
        color: Colors.grey[800], // unselected icon color
        activeColor: ColorManager.primary, // selected icon and text color
        iconSize: setResponsiveFontSize(24), // tab button icon size
        tabBackgroundColor:
            Colors.green.withOpacity(0.1), // selected tab background color
        padding: EdgeInsets.symmetric(
            horizontal: 15, vertical: 5), // navigation bar padding
        tabs: [
          GButton(
            icon: FontAwesomeIcons.video,
            text: AppStrings.multiMedia,
          ),
          GButton(
            icon: FontAwesomeIcons.moneyCheckAlt,
            text: AppStrings.offers,
          ),
          GButton(
            icon: FontAwesomeIcons.star,
            text: AppStrings.services,
          ),
          GButton(icon: FontAwesomeIcons.home, text: AppStrings.home)
        ]);
  }
}
