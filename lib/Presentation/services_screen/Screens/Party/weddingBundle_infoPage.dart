import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/sharedWidgets.dart';
import 'package:clean_app/Data/Models/WeddingModel.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Party/party_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class WeddingInfoPage extends StatelessWidget {
  const WeddingInfoPage({required this.weddingInfo, Key? key})
      : super(key: key);
  final WeddingHallInfo weddingInfo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200.h,
                    child: Hero(
                      tag: weddingInfo.id,
                      child: Image.asset(
                        weddingInfo.titleImagePath,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: AutoSizeText(
                            weddingInfo.title,
                            style: boldStyle,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SmoothStarRating(
                                allowHalfRating: false,
                                rating: weddingInfo.rate,
                                size: 20.0,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half_outlined,
                                color: ColorManager.starRatingColor,
                                borderColor: ColorManager.starRatingColor,
                                spacing: 0.0),
                            AutoSizeText(
                              "مقيم من ${weddingInfo.numberOfReviews} شخص",
                              style: boldStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: double.infinity,
                            child: AutoSizeText(
                              "التفاصيل",
                              style: boldStyle,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AutoSizeText(
                                "المساحة",
                                style: boldStyle.copyWith(
                                    color: ColorManager.primary),
                              ),
                              AutoSizeText("عدد الأفراد",
                                  style: boldStyle.copyWith(
                                      color: ColorManager.primary)),
                              AutoSizeText(
                                "السعر",
                                style: boldStyle.copyWith(
                                    color: ColorManager.primary),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AutoSizeText(
                                "${weddingInfo.capacity.toString()} متر مربع",
                                style: boldStyle.copyWith(
                                    fontSize: setResponsiveFontSize(14)),
                              ),
                              AutoSizeText(
                                "${weddingInfo.maxLimit.toString()} شخص",
                                style: boldStyle.copyWith(
                                    fontSize: setResponsiveFontSize(14)),
                              ),
                              AutoSizeText(
                                "${weddingInfo.price.toString()} جنية",
                                style: boldStyle.copyWith(),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: double.infinity,
                            child: AutoSizeText(
                              "عن العرض",
                              style: boldStyle,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: double.infinity,
                            child: AutoSizeText(
                              weddingInfo.description,
                              style: extraBoldStyle.copyWith(
                                  color: Colors.grey,
                                  fontSize: setResponsiveFontSize(16),
                                  height: 1.3),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Container(
                                    height: 250.h,
                                    width: double.infinity,
                                    child: new Swiper(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return WeddingSwipeCards(
                                            iamgePath:
                                                weddingInfo.hallImages[index]);
                                      },
                                      itemCount: 3,
                                      itemWidth: 320,
                                      autoplay: true,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: AutoSizeText(
                                "صور للقاعة",
                                style: boldStyle,
                              )),
                              Icon(
                                Icons.image,
                                color: ColorManager.primary,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                right: 90.w,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: RoundedButton(
                      ontap: () {
                        Fluttertoast.showToast(
                            msg: "سوف يتم الأتصال بك قريبا لتأكيد الحجز",
                            backgroundColor: Colors.green,
                            gravity: ToastGravity.CENTER);
                        Navigator.pop(context);
                      },
                      buttonColor: ColorManager.primary,
                      title: "حجز القاعة",
                      titleColor: Colors.white,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
