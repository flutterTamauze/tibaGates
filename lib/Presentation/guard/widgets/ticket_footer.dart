import 'package:Tiba_Gates/Utilities/Constants/constants.dart';
import 'package:Tiba_Gates/Utilities/Fonts/fontsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketFooter extends StatelessWidget {
  const TicketFooter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'It\'s our pleasure to serve you \n                  يسعدنا خدمتك',
        style: TextStyle(
            color: Colors.black,
            height: 2.h,
            fontSize:
            setResponsiveFontSize(
                28),
            fontWeight:
            FontManager.bold),
      ),
    );
  }
}
