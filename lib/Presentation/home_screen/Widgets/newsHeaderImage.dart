import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NnewsHeaderImage extends StatelessWidget {
  final String headerImage;
  NnewsHeaderImage(this.headerImage);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          image: DecorationImage(
              image: NetworkImage(headerImage), fit: BoxFit.fill)),
    );
  }
}
