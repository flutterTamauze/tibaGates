import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Data/Models/WeddingModel.dart';
import 'package:clean_app/Data/Models/hotel.dart';
import 'package:clean_app/Presentation/services_screen/Hotels/details_screen.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Party/party_main_screen.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Party/weddingDefault_InfoPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import 'filterPage.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({Key? key}) : super(key: key);

  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
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
              "الفندق",
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
                        iamgePath: "assets/images/hotel${index + 1}.jpg");
                  },
                  itemCount: 3,
                  itemWidth: 320,
                  autoplay: true,
                  layout: SwiperLayout.STACK,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilterPage(),
                        ));
                  },
                  child: Icon(
                    FontAwesomeIcons.filter,
                    color: ColorManager.primary,
                  ),
                ),
                Container(
                  child: AutoSizeText(
                    "الغرف",
                    style: boldStyle.copyWith(
                        color: ColorManager.primary,
                        fontSize: setResponsiveFontSize(20)),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HotelDetails(hotelRoomList[index]),
                            ));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          width: MediaQuery.of(context).size.width,
                          height: 220.h,
                          child: Column(
                            children: [
                              Container(
                                height: 150.h,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: Hero(
                                    tag: hotelRoomList[index].title,
                                    child: Image.asset(
                                      hotelRoomList[index].titleImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AutoSizeText(
                                          "${hotelRoomList[index].price} ج / الساعة",
                                          style: boldStyle.copyWith(
                                              color: ColorManager.primary),
                                        ),
                                        AutoSizeText(
                                          hotelRoomList[index].title,
                                          style: boldStyle,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SmoothStarRating(
                                            allowHalfRating: false,
                                            rating: hotelRoomList[index].rating,
                                            size: 20.0,
                                            filledIconData: Icons.star,
                                            halfFilledIconData:
                                                Icons.star_half_outlined,
                                            color: Color(0xffED881C),
                                            borderColor:
                                                ColorManager.starRatingColor,
                                            spacing: 0.0),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: hotelRoomList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
