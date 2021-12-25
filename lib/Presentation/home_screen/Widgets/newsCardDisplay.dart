import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Data/Models/newsModel.dart';
import 'package:clean_app/Presentation/home_screen/Widgets/newsHeaderImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'newsFooterDisplay.dart';

class NewsCardDisplay extends StatelessWidget {
  final NewsModel newsModel;
  const NewsCardDisplay({
    required this.newsModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      elevation: 3,
      child: Container(
        height: 390.h,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Hero(
                tag: newsModel.newsImagePath,
                child: NnewsHeaderImage(newsModel.newsImagePath)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    "عدد المشاهدات ${newsModel.numberOfViews}",
                    style: boldStyle.copyWith(
                        color: ColorManager.primary, letterSpacing: 2),
                  ),
                  AutoSizeText(
                    DateTime.now().toString().substring(0, 11),
                    style: boldStyle.copyWith(
                        color: ColorManager.primary, letterSpacing: 2),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: AutoSizeText(
                newsModel.newsTitle,
                style: extraBoldStyle.copyWith(
                  height: 1.2,
                  fontSize: 14,
                ),
                maxLines: 4,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            NewsFooterDisplay(newsModel: newsModel)
          ],
        ),
      ),
    );
  }
}
