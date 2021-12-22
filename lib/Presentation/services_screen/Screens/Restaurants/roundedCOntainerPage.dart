import 'package:flutter/material.dart';

class RoundedContainerPage extends StatelessWidget {
  final Widget body;
  final Widget header;
  final EdgeInsets padding;
  final double borderRadius;
  final double opacity;
  final Color? backgroundColor;
  RoundedContainerPage(
      {required this.body,
      this.padding = const EdgeInsets.all(0),
      this.borderRadius = 24,
      this.opacity = 1,
      this.header = const SizedBox(),
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          header,
          Expanded(
            child: Container(
              width: double.infinity,
              padding: padding,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(opacity),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                  child: body),
            ),
          ),
        ],
      ),
    );
  }
}
