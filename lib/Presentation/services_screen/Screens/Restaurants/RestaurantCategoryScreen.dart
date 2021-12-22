import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Data/Models/categoryItems.dart';
import 'package:clean_app/Presentation/ProfileSignUp/ProfileSignUp.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Restaurants/restaurantItemInfo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RestaurantCatScreen extends StatelessWidget {
  RestaurantCatScreen(this.categoryName);
  final String categoryName;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<CategoryItem> catList = catItems
        .where((element) => element.categoryType == categoryName)
        .toList();
    return GestureDetector(
      onTap: () {
        print(catList.length);
      },
      child: Scaffold(
        backgroundColor: ColorManager.lightBackGround,
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          elevation: 5,
          title: AutoSizeText(
            categoryName,
            style: extraBoldStyle.copyWith(
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
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            child: Column(
              children: [
                SignTextField(
                  validation: () {},
                  iconData: Icons.search,
                  hint: "البحث",
                  textEditingController: _searchController,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: catList.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RestaurantInfoItem(catList[index]),
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            width: double.infinity,
                            child: Hero(
                              tag: catList[index].id,
                              child: Image(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  catList[index].imagePath,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AutoSizeText(catList[index].itemName,
                                      textAlign: TextAlign.left,
                                      style: extraBoldStyle.copyWith(
                                          color: ColorManager.backGroundColor)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AutoSizeText(
                                        catList[index].rate.toString(),
                                        style: boldStyle.copyWith(
                                            color:
                                                ColorManager.backGroundColor),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: ColorManager.starRatingColor,
                                        size: 20,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              color: Colors.black45,
                            ))
                      ],
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
