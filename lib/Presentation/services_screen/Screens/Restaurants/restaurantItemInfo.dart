import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Data/Models/categoryItems.dart';
import 'package:clean_app/Presentation/services_screen/widgets/RestaurantCategories/addToCartCardInfo.dart';
import 'package:clean_app/Presentation/services_screen/widgets/RestaurantCategories/categoryCardInfo.dart';
import 'package:clean_app/Presentation/services_screen/widgets/RestaurantCategories/itemSizeDropdown.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class RestaurantInfoItem extends StatefulWidget {
  final CategoryItem categoryItem;
  RestaurantInfoItem(this.categoryItem);
  @override
  _RestaurantInfoItemState createState() => _RestaurantInfoItemState();
}

String currentSize = "صغير";
int currentQuantity = 1;

class _RestaurantInfoItemState extends State<RestaurantInfoItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300.h,
              child: Image(
                image: AssetImage(widget.categoryItem.imagePath),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Positioned(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 610.h,
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
                      AutoSizeText(
                        widget.categoryItem.itemName,
                        style: boldStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SmoothStarRating(
                                allowHalfRating: false,
                                rating: widget.categoryItem.rate,
                                size: 20.0,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half_outlined,
                                color: ColorManager.starRatingColor,
                                borderColor: ColorManager.starRatingColor,
                                spacing: 0.0),
                            AutoSizeText(
                              "التقييم ${widget.categoryItem.rate.toString()} من 5",
                              style: extraBoldStyle.copyWith(
                                fontSize: setResponsiveFontSize(14),
                              ),
                            )
                          ],
                        ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              "${widget.categoryItem.price.toString()} جنية",
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
                      Container(
                        width: double.infinity,
                        child: AutoSizeText(
                          widget.categoryItem.desc,
                          style: extraBoldStyle.copyWith(
                            color: ColorManager.grey,
                            fontSize: setResponsiveFontSize(14),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ItemSizeDropDown(
                                function: (String v) {
                                  setState(() {
                                    currentSize = v;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                "اختر الحجم المناسب لك",
                                style: boldStyle.copyWith(
                                    color: ColorManager.grey,
                                    fontSize: setResponsiveFontSize(14)),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
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
// Group: Number of Portions

                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: SizedBox(
                          width: 331.0.w,
                          height: 30.0,
                          child: Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment(0.0, -0.27),
                                child: Text(
                                  "الكمية",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Spacer(flex: 39),
// Group: Group 6870
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (currentQuantity != 1) {
                                      currentQuantity--;
                                    }
                                  });
                                },
                                child: Container(
                                  alignment: Alignment(0.04, -0.27),
                                  width: 52.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    color: ColorManager.primary,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.16),
                                        offset: Offset(0, 3.0),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      '-',
                                      style: boldStyle.copyWith(
                                          fontSize: setResponsiveFontSize(18),
                                          color: ColorManager.backGroundColor),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(flex: 5),
// Group: Group 6872
                              Container(
                                alignment: Alignment(0.03, -0.27),
                                width: 47.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  currentQuantity.toString(),
                                  style: boldStyle,
                                ),
                              ),
                              Spacer(flex: 5),
// Group: Group 6873
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    currentQuantity++;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment(0.14, -0.27),
                                  width: 52.0.w,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    color: ColorManager.primary,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.16),
                                        offset: Offset(0, 3.0),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      '+',
                                      style: boldStyle.copyWith(
                                          fontSize: setResponsiveFontSize(18),
                                          color: ColorManager.backGroundColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                color: Colors.white,
                                child: Container(
                                    width: 97.w,
                                    height: 130.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(38.0),
                                        ),
                                        color: ColorManager.primary
                                            .withOpacity(0.9))),
                              ),
                            ],
                          ),
                          Positioned(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                width: 300.0.w,
                                height: 87.0.h,
                                child: AddToCardInfo(
                                  categoryCount:
                                      "${widget.categoryItem.price * currentQuantity}",
                                  categoryName: "المبلغ الكلى",
                                ),
                              ),
                            ),
                            top: 15.h,
                            left: 40.w,
                          ),
                          Positioned(
                              top: 25.h,
                              left: 10.w,
                              child: Hero(
                                tag: widget.categoryItem.id,
                                child: Container(
                                  width: 75.w,
                                  height: 75.h,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              widget.categoryItem.imagePath),
                                          fit: BoxFit.fill),
                                      shape: BoxShape.circle),
                                ),
                              )),
                          Positioned(
                            right: 0,
                            top: 30.h,
                            child: Container(
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.cartArrowDown,
                                  color: ColorManager.primary,
                                  size: 20,
                                ),
                              ),
                              alignment: Alignment.center,
                              width: 50.0.w,
                              height: 50.0.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorManager.lightBackGround,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.16),
                                      offset: Offset(0, 3.0),
                                      blurRadius: 6.0,
                                      spreadRadius: 2),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
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
