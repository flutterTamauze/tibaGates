import 'package:clean_app/Data/Models/newsModel.dart';
import 'package:clean_app/Presentation/home_screen/Widgets/newsFooter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewsFooterDisplay extends StatelessWidget {
  const NewsFooterDisplay({
    Key? key,
    required this.newsModel,
  }) : super(key: key);

  final NewsModel newsModel;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 2),
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NewsFooterBar(
              numberOfContributes: newsModel.totalShares,
              icon: FontAwesomeIcons.shareAlt,
            ),
            NewsFooterBar(
              numberOfContributes: newsModel.totalComments,
              icon: FontAwesomeIcons.comment,
            ),
            NewsFooterBar(
              numberOfContributes: newsModel.totalLikes,
              icon: FontAwesomeIcons.heart,
            ),
          ],
        ));
  }
}
