import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketDivider extends StatelessWidget {
  const TicketDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets
          .symmetric(
          horizontal:
          20.w),
      child: Divider(
        thickness: 1,
        height: 2.h,
        color: Colors.black,
      ),
    );
  }
}
