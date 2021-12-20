import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewsFooterBar extends StatelessWidget {
  final String numberOfContributes;
  final IconData icon;
  NewsFooterBar({
    required this.icon,
    required this.numberOfContributes,
  });
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: icon == FontAwesomeIcons.heart
              ? ColorManager.primary
              : ColorManager.grey,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          numberOfContributes,
          style: boldStyle.copyWith(fontSize: 15),
        )
      ],
    );
  }
}
