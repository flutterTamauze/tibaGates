import 'package:flutter/material.dart';

class VipLogo extends StatelessWidget {
  final double width;
  final double height;
  const VipLogo({
    Key key, this.width, this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
        const EdgeInsets
            .all(12.0),
        child: Padding(
          padding:
          const EdgeInsets
              .only(
              left: 15,
              right: 15),
          child: SizedBox(
            height:
            (height * 0.13),
            width:
            (width * 0.3),
            child: Container(
              decoration:
              const BoxDecoration(
                color: Colors
                    .white,
                image: DecorationImage(
                    image: AssetImage(
                        'assets/images/vip.png')),
                shape: BoxShape
                    .circle,
              ),
            ),
          ),
        ));
  }
}
