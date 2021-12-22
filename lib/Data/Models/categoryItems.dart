import 'package:clean_app/Core/imageAssets/assetsManager.dart';
import 'package:flutter/cupertino.dart';

class CategoryItem {
  String itemName, imagePath, desc;
  double rate, price;
  String categoryType;
  int id;
  CategoryItem(
      {required this.categoryType,
      required this.itemName,
      required this.id,
      required this.rate,
      required this.desc,
      required this.price,
      required this.imagePath});
}

List<CategoryItem> catItems = [
  CategoryItem(
      id: 1,
      desc:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ornare leo non mollis id cursus. Eu euismod faucibus in leo malesuada",
      imagePath: AssetsManager.applePieDessert,
      price: 242,
      categoryType: "Desserts",
      itemName: "Frensh Apple Pie",
      rate: 4.9),
  CategoryItem(
      id: 2,
      desc:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ornare leo non mollis id cursus. Eu euismod faucibus in leo malesuada",
      imagePath: AssetsManager.darkChocolateDessert,
      categoryType: "Desserts",
      price: 322,
      itemName: "Dark Chocolate Cake",
      rate: 4.7),
  CategoryItem(
      id: 3,
      desc:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ornare leo non mollis id cursus. Eu euismod faucibus in leo malesuada",
      imagePath: AssetsManager.browniesDessert,
      price: 123,
      categoryType: "Desserts",
      itemName: "Chewy Brownies",
      rate: 3),
  CategoryItem(
      id: 4,
      desc:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ornare leo non mollis id cursus. Eu euismod faucibus in leo malesuada",
      imagePath: AssetsManager.streetShakeDessert,
      price: 211,
      categoryType: "Desserts",
      itemName: "Street Shake",
      rate: 3.3)
  //Food//
  ,
  CategoryItem(
      id: 5,
      desc:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ornare leo non mollis id cursus. Eu euismod faucibus in leo malesuada",
      imagePath: AssetsManager.fajitaFood,
      price: 121,
      categoryType: "Food",
      itemName: "Chicken Fajita",
      rate: 4.9),
  CategoryItem(
      desc:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ornare leo non mollis id cursus. Eu euismod faucibus in leo malesuada",
      id: 6,
      imagePath: AssetsManager.grilledChickFood,
      price: 33,
      categoryType: "Food",
      itemName: "1/2 Grilled Chicken",
      rate: 4.7),
];
