
import 'package:Tiba_Gates/Utilities/Constants/constants.dart';
import 'package:Tiba_Gates/Utilities/Fonts/fontsManager.dart';
import 'package:Tiba_Gates/ViewModel/guard/authProv.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../guardPrint_Screen.dart';

class TicketLostFine extends StatelessWidget {
  const TicketLostFine({
    Key key,
    @required this.widget,

  }) : super(key: key);

  final PrintScreen widget;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DottedDecoration(
        shape: Shape.box,
        color: Colors.black,
        strokeWidth: 2.w,
        borderRadius:
        BorderRadius.circular(
            10), //remove this to get plane rectange
      ),
      child: Padding(
        padding:
        const EdgeInsets.only(
            top: 12,
            bottom: 12,
            left: 4,
            right: 4),
        child: Center(
          child: Column(
            children: [
              AutoSizeText(
                'برجاء الإحتفاظ بالفاتورة لتقديمها عند المغادرة',
                textAlign:
                TextAlign.center,
                style: TextStyle(
                    color:
                    Colors.black,
                    height: 2.h,
                    fontSize:
                    setResponsiveFontSize(
                        28),
                    fontWeight:
                    FontManager
                        .bold),
              ),
              (widget.resendType !=
                  ('VIP Invitation') &&
                  widget.resendType !=
                      ('Normal'))
                  ? AutoSizeText(
                ' غرامة فقد التذكرة ${Provider.of<AuthProv>(context, listen: false).lostTicketPrice.toString() ?? 0} جنيه',
                textAlign:
                TextAlign
                    .center,
                style: TextStyle(
                    color: Colors
                        .black,
                    height: 2.h,
                    fontSize:
                    setResponsiveFontSize(
                        28),
                    fontWeight:
                    FontManager
                        .bold),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}