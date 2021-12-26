import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/sharedWidgets.dart';
import 'package:clean_app/Data/Models/categoryItems.dart';
import 'package:clean_app/Data/Models/hotel.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Party/party_main_screen.dart';
import 'package:clean_app/Presentation/services_screen/widgets/RestaurantCategories/addToCartCardInfo.dart';
import 'package:clean_app/Presentation/services_screen/widgets/RestaurantCategories/categoryCardInfo.dart';
import 'package:clean_app/Presentation/services_screen/widgets/RestaurantCategories/itemSizeDropdown.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import 'filterPage.dart';

class HotelDetails extends StatefulWidget {
  final HotelRoom hotelRoom;
  HotelDetails(this.hotelRoom);
  @override
  _HotelDetailsState createState() => _HotelDetailsState();
}

String currentSize = "صغير";
int currentQuantity = 1;

class _HotelDetailsState extends State<HotelDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 300.h,
            child: Hero(
              tag: widget.hotelRoom.title,
              child: Image(
                image: AssetImage(widget.hotelRoom.titleImage),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
      Positioned(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 620.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: ColorManager.lightBackGround,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45))),
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SmoothStarRating(
                                          allowHalfRating: false,
                                          rating: widget.hotelRoom.rating,
                                          size: 20.0,
                                          filledIconData: Icons.star,
                                          halfFilledIconData:
                                              Icons.star_half_outlined,
                                          color: ColorManager.starRatingColor,
                                          borderColor:
                                              ColorManager.starRatingColor,
                                          spacing: 0.0),
                                    ],
                                  ),
                                ),
                                AutoSizeText(
                                  widget.hotelRoom.title,
                                  style: boldStyle,
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 5,
                            ),
                            Divider(),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    "${widget.hotelRoom.price.toString()} جنية",
                                    style: extraBoldStyle.copyWith(
                                      fontSize: setResponsiveFontSize(14),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  AutoSizeText(
                                    "السعر",
                                    style: extraBoldStyle.copyWith(
                                      fontSize: setResponsiveFontSize(14),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              child: AutoSizeText(
                                "التفاصيل",
                                style: extraBoldStyle.copyWith(
                                  fontSize: setResponsiveFontSize(14),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    child: Wrap(
                                  alignment: WrapAlignment.end,
                                  spacing: 1.0,
                                  runSpacing: 1.0,
                                  children: <Widget>[
                                    FilterShipView(chipName: 'شرفة'),
                                    FilterShipView(chipName: "تكييف"),
                                    FilterShipView(chipName: 'واي فاي مجاناً'),
                                    FilterShipView(chipName: 'عازل للصوت'),
                                    FilterShipView(chipName: 'آلة صنع القهوة'),
                                    FilterShipView(chipName: 'ميني بار'),
                                    FilterShipView(chipName: 'سرير واحد'),
                                  ],
                                )),
                              ),
                            ),
                            Divider(),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              child: AutoSizeText(
                                "اضف ملاحظة (اختيارى)",
                                style: boldStyle.copyWith(
                                    color: ColorManager.grey,
                                    fontSize: setResponsiveFontSize(14)),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              child: TextField(
                                decoration: ktextFieldDecoration,
                                style: TextStyle(),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                                width: 400.w,
                                height: 200.h,
                                child: new Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return WeddingSwipeCards(
                                        iamgePath:
                                            widget.hotelRoom.images[index]);
                                  },
                                  itemCount: widget.hotelRoom.images.length,
                                  viewportFraction: 0.8,
                                  scale: 0.9,
                                  autoplay: true,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Center(
                                child: RoundedButton(
                                  ontap: () {
                                    Fluttertoast.showToast(
                                        msg:
                                            "سوف يتم الأتصال بك قريبا لتأكيد الحجز",
                                        backgroundColor: Colors.green,
                                        gravity: ToastGravity.CENTER);
                                    Navigator.pop(context);
                                  },
                                  buttonColor: ColorManager.primary,
                                  title: "حجز الغرفة",
                                  titleColor: Colors.white,
                                ),
                              ),
                            )
// Group: Number of Portions
                          ])))))),
    ]));
  }
}
// body: Container(

//       child: Stack(
//         children: [
//           Column(
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 280.h,
//                     child: Hero(
//                       tag: widget.categoryItem.id,
//                       child: Image(
//                         image: AssetImage(widget.categoryItem.imagePath),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 50.h,
//                   )
//                 ],
//               )
//             ],
//           ),
//           Positioned(
//             bottom: 130,
//             child: Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(40),
//                         topRight: Radius.circular(40))),
//                 width: MediaQuery.of(context).size.width),
//           )
//         ],
//       ),
//     ),
