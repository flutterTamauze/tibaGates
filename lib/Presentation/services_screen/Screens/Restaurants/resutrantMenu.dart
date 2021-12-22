import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Restaurants/RestaurantCategoryScreen.dart';
import 'package:clean_app/Presentation/services_screen/widgets/RestaurantCategories/categoryCardInfo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantMenu extends StatelessWidget {
  const RestaurantMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        elevation: 5,
        title: AutoSizeText(
          "Menu",
          style: boldStyle.copyWith(
            color: ColorManager.backGroundColor,
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    FontAwesomeIcons.shoppingCart,
                    size: 25,
                    color: ColorManager.backGroundColor,
                  ))),
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(left: 5, bottom: 100.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                Row(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Container(
                          width: 97.w,
                          height: 530.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(38.0),
                              ),
                              color: ColorManager.primary.withOpacity(0.8))),
                    ),
                  ],
                ),
                Positioned(
                  child: Container(
                    width: 300.0.w,
                    height: 87.0.h,
                    child: CategoryCardInfo(
                      categoryCount: "120",
                      categoryName: "Food",
                    ),
                  ),
                  top: 15.h,
                  left: 40.w,
                ),
                Positioned(
                    top: 25.h,
                    left: 10.w,
                    child: Container(
                      width: 75.w,
                      height: 75.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/cat1.jpg"),
                              fit: BoxFit.fill),
                          shape: BoxShape.circle),
                    )),
                Positioned(
                  top: 35.h,
                  right: 20.w,
                  child: CategorySelectionButton(
                    categoryName: "Food",
                  ),
                ),
                Positioned(
                  child: Container(
                    child: CategoryCardInfo(
                      categoryCount: "220",
                      categoryName: "Beverages",
                    ),
                    width: 300.0.w,
                    height: 87.0.h,
                    decoration: menuBoxDecoartionCard,
                  ),
                  top: 130.h,
                  left: 40.w,
                ),
                Positioned(
                    top: 140.h,
                    left: 10.w,
                    child: Container(
                      width: 75.w,
                      height: 75.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/cat2.jpg"),
                              fit: BoxFit.fill),
                          shape: BoxShape.circle),
                    )),
                Positioned(
                  top: 150.h,
                  right: 20.w,
                  child: CategorySelectionButton(
                    categoryName: "Beverages",
                  ),
                ),
                Positioned(
                  top: 380.h,
                  right: 20.w,
                  child: Container(
                    child: Center(
                      child: Icon(
                        Icons.chevron_right_outlined,
                        color: ColorManager.primary,
                        size: 30,
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
                Positioned(
                  child: Container(
                    width: 300.0.w,
                    height: 87.0.h,
                    child: CategoryCardInfo(
                      categoryCount: "13",
                      categoryName: "Desserts",
                    ),
                    decoration: menuBoxDecoartionCard,
                  ),
                  top: 245.h,
                  left: 40.w,
                ),
                Positioned(
                    top: 255.h,
                    left: 10.w,
                    child: Container(
                      width: 75.w,
                      height: 75.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/cat3.jpg"),
                              fit: BoxFit.fill),
                          shape: BoxShape.circle),
                    )),
                Positioned(
                  top: 265.h,
                  right: 20.w,
                  child: CategorySelectionButton(
                    categoryName: "Desserts",
                  ),
                ),
                Positioned(
                  child: Container(
                      width: 300.0.w,
                      height: 87.0.h,
                      child: CategoryCardInfo(
                        categoryCount: "40",
                        categoryName: "Promotions",
                      ),
                      decoration: menuBoxDecoartionCard),
                  top: 360.h,
                  left: 40.w,
                ),
                Positioned(
                    top: 370.h,
                    left: 10.w,
                    child: Container(
                      width: 75.w,
                      height: 75.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/cat4.png"),
                              fit: BoxFit.fill),
                          shape: BoxShape.circle),
                    )),
                Positioned(
                  top: 380.h,
                  right: 20.w,
                  child: CategorySelectionButton(
                    categoryName: "Promotions",
                  ),
                )
              ]),
            ],
          )),
    );
  }
}

class CategorySelectionButton extends StatelessWidget {
  final String categoryName;
  const CategorySelectionButton({
    required this.categoryName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantCatScreen(categoryName),
            ));
      },
      child: Container(
        child: Center(
          child: Icon(
            Icons.chevron_right_outlined,
            color: ColorManager.primary,
            size: 30,
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
    );
  }
}
