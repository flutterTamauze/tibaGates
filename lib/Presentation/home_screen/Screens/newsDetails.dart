import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Data/Models/newsModel.dart';
import 'package:clean_app/Presentation/home_screen/Widgets/newsFooterDisplay.dart';
import 'package:clean_app/Presentation/home_screen/Widgets/newsHeaderImage.dart';
import 'package:flutter/material.dart';

class NewsDetails extends StatelessWidget {
  NewsDetails({required this.newsModel});
  final NewsModel newsModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "تفاصيل الخبر",
                  style: boldStyle.copyWith(color: Colors.black, fontSize: 20),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    Container(
                      child: Hero(
                          tag: newsModel.newsImagePath,
                          child: NnewsHeaderImage(newsModel.newsImagePath)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: AutoSizeText(
                        newsModel.newsTitle,
                        textAlign: TextAlign.right,
                        style: extraBoldStyle.copyWith(
                            fontSize: setResponsiveFontSize(18)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: AutoSizeText(
                          "عدد المشاهدات  ${newsModel.numberOfViews}",
                          style: boldStyle.copyWith(
                              color: ColorManager.primary,
                              fontSize: setResponsiveFontSize(15)),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: AutoSizeText(
                        newsModel.newsDesc,
                        textAlign: TextAlign.right,
                        style: boldStyle.copyWith(height: 1.4),
                      ),
                    ),
                    NewsFooterDisplay(newsModel: newsModel)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
