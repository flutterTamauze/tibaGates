
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TibaLogo extends StatelessWidget {
  const TibaLogo({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 15.w, right: 8.w),
      child: SizedBox(
        height: (height * 0.18),
        width: (width * 0.34),
        child: Container(
          decoration:
          const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage(
                    'assets/images/tipasplash.png')),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
