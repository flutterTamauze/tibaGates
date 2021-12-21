import 'package:clean_app/Data/Models/newsModel.dart';
import 'package:clean_app/Presentation/home_screen/Screens/newsDetails.dart';
import 'package:clean_app/Presentation/home_screen/Widgets/newsCardDisplay.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsDisplay extends StatelessWidget {
  const NewsDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, index) {
        return Center(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetails(
                          newsModel: tempNewsList[index],
                        ),
                      ));
                },
                child: NewsCardDisplay(
                  newsModel: tempNewsList[index],
                ),
              ),
            ],
          ),
        );
      },
      itemCount: tempNewsList.length,
    ));
  }
}
