import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DottedDivider extends StatelessWidget {
  const DottedDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(
          right: 250.w),
      child: Container(
        decoration: DottedDecoration(
            shape:
            Shape.line,
            linePosition:
            LinePosition
                .bottom,
            color: Colors
                .black),
      ),
    );
  }
}