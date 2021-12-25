import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Data/Models/WeddingModel.dart';
import 'package:clean_app/Presentation/home_screen/Screens/home.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Party/weddingBundle_infoPage.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Party/weddingDefault_InfoPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class PartMainPage extends StatefulWidget {
  const PartMainPage({Key? key}) : super(key: key);

  @override
  _PartMainPageState createState() => _PartMainPageState();
}

class _PartMainPageState extends State<PartMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorManager.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 26,
                  color: Colors.white,
                )),
            AutoSizeText(
              "الحفلات",
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 200.h,
                width: 300.w,
                child: new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return WeddingSwipeCards(
                        iamgePath: "assets/images/wedding${index + 1}.jpg");
                  },
                  itemCount: 3,
                  itemWidth: 320,
                  autoplay: true,
                  layout: SwiperLayout.STACK,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: AutoSizeText(
                "عروض القاعات",
                style: boldStyle.copyWith(
                    color: ColorManager.primary,
                    fontSize: setResponsiveFontSize(20)),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeddingInfoPage(
                                  weddingInfo: weddingInfoList
                                      .where((element) =>
                                          element.id == weddingList1[index].id)
                                      .first),
                            ));
                      },
                      child: Container(
                        width: 200.w,
                        height: 300.h,
                        child: Column(
                          children: [
                            Container(
                              width: 200.w,
                              height: 110.h,
                              child: Hero(
                                tag: weddingInfoList[index].id,
                                child: Image(
                                  image: AssetImage(
                                    weddingList1[index].titleImage,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              child: AutoSizeText(
                                weddingList1[index].weddingHallName,
                                style: boldStyle,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              child: AutoSizeText(
                                "تستوعب ${weddingList1[index].maximumLimit} شخص",
                                style: boldStyle.copyWith(
                                    color: Colors.grey,
                                    fontSize: setResponsiveFontSize(15)),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              child: AutoSizeText(
                                "  ${weddingList1[index].totalPrice} : السعر ",
                                style: boldStyle.copyWith(
                                    fontSize: setResponsiveFontSize(14),
                                    color:
                                        ColorManager.primary.withOpacity(0.8)),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: weddingList1.length,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: AutoSizeText(
                "القاعات المشهورة",
                style: boldStyle.copyWith(
                    color: ColorManager.primary,
                    fontSize: setResponsiveFontSize(20)),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeddingDefaultInfoPage(
                                  weddingInfo: weddingInfoList2
                                      .where((element) =>
                                          element.id == weddingList2[index].id)
                                      .first),
                            ));
                      },
                      child: Container(
                        width: 200.w,
                        height: 300.h,
                        child: Column(
                          children: [
                            Container(
                              width: 200.w,
                              height: 110.h,
                              child: Hero(
                                tag: weddingInfoList2[index].id,
                                child: Image(
                                  image: AssetImage(
                                    weddingList2[index].titleImage,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              child: AutoSizeText(
                                weddingList2[index].weddingHallName,
                                style: boldStyle,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SmoothStarRating(
                                    allowHalfRating: false,
                                    rating: weddingInfoList2
                                        .where((element) =>
                                            element.id ==
                                            weddingList2[index].id)
                                        .first
                                        .rate,
                                    size: 20.0,
                                    filledIconData: Icons.star,
                                    halfFilledIconData:
                                        Icons.star_half_outlined,
                                    color: ColorManager.primary,
                                    borderColor: ColorManager.primary,
                                    spacing: 0.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: weddingList2.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeddingSwipeCards extends StatelessWidget {
  const WeddingSwipeCards({required this.iamgePath});
  final String iamgePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
          image:
              DecorationImage(image: AssetImage(iamgePath), fit: BoxFit.fill)),
    );
  }
}
