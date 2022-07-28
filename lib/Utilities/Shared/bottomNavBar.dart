
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/*
class AnimatedBottomNavBar extends StatelessWidget {
  const AnimatedBottomNavBar({
     this.getCurrentIndex,
    Key key,
  }) : super(key: key);
  final Function getCurrentIndex;
  @override
  Widget build(BuildContext context) {
    return GNav(
        backgroundColor: ColorManager.primary,
        onTabChange: (value) {
          print(value);
          getCurrentIndex(value);
        },
        haptic: false,
        selectedIndex: 2,
        tabMargin: EdgeInsets.all(5),
        tabBorderRadius: 5,
        tabActiveBorder:
            Border.all(color: ColorManager.grey, width: 1), // tab button border
        rippleColor: ColorManager.backGroundColor,
        curve: Curves.easeOutExpo, // tab animation curves
        duration: Duration(milliseconds: 500), // tab animation duration
        gap: 13, // the tab button gap between icon and text
        color: ColorManager.backGroundColor, // unselected icon color
        activeColor: ColorManager.primary, // selected icon and text color
        iconSize: setResponsiveFontSize(24), // tab button icon size
        tabBackgroundColor:
            ColorManager.backGroundColor, // selected tab background color
        padding: EdgeInsets.symmetric(
            horizontal: 15, vertical: 5), // navigation bar padding
        tabs: [
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
*/
