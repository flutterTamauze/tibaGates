import 'package:flutter/cupertino.dart';

class WeddingModel {
  String titleImage, weddingHallName;
  int maximumLimit, id;
  double totalPrice;
  WeddingModel(
      {required this.maximumLimit,
      required this.titleImage,
      required this.totalPrice,
      required this.weddingHallName,
      required this.id});
}

List<WeddingModel> weddingList1 = [
  WeddingModel(
      id: 1,
      maximumLimit: 500,
      titleImage: "assets/images/wedding3.jpg",
      totalPrice: 15000,
      weddingHallName: "قاعة فيكتوريا"),
  WeddingModel(
      id: 2,
      maximumLimit: 200,
      titleImage: "assets/images/wedding1.jpg",
      totalPrice: 10000,
      weddingHallName: "قاعة سندباد"),
  WeddingModel(
      id: 3,
      maximumLimit: 100,
      titleImage: "assets/images/wedding2.jpg",
      totalPrice: 5000,
      weddingHallName: "قاعة الفردوس")
];
List<WeddingModel> weddingList2 = [
  WeddingModel(
      id: 10,
      maximumLimit: 500,
      titleImage: "assets/images/wedding3.jpg",
      totalPrice: 15000,
      weddingHallName: "قاعة اللقلقة"),
  WeddingModel(
      id: 11,
      maximumLimit: 200,
      titleImage: "assets/images/wedding1.jpg",
      totalPrice: 10000,
      weddingHallName: "قاعة الفرسان"),
  WeddingModel(
      id: 12,
      maximumLimit: 100,
      titleImage: "assets/images/wedding2.jpg",
      totalPrice: 5000,
      weddingHallName: "قاعة البابلش")
];

class WeddingHallInfo {
  String titleImagePath, description, title;
  List<String> hallImages;
  double rate, price, capacity;
  int numberOfReviews, maxLimit, id;
  WeddingHallInfo(
      {required this.description,
      required this.maxLimit,
      required this.numberOfReviews,
      required this.rate,
      required this.title,
      required this.price,
      required this.capacity,
      required this.id,
      required this.titleImagePath,
      required this.hallImages});
}

List<WeddingHallInfo> weddingInfoList = [
  WeddingHallInfo(
      capacity: 365.6,
      price: 15000,
      description:
          "💝العرض يشمل💝 : 1-إيجار قاعة وقت مفتوح 😮 2-تصوير يتكون من صورة كبيرة هدية للعروسين و 100 صورة شبح + تصوير HD مع المونتاج+ صورة دفترية للعروسين 💃 3-استلام موبايلات📱 4-ليزر لايت💡 5-تغليف كراسي و طاولات 💎 6-كوشة عروس👰 7-غرفة تبديل للعروس👰🙎 8-جهاز فقاعات 9-جهاز دخان 🎆🎇 10-ماء + علب كلينكس مجانا 👍 11-تجهيز وجبات طعام حسب المينيو",
      hallImages: [
        "assets/images/wedding1-1.jpeg",
        "assets/images/wedding1-2.jpg",
        "assets/images/wedding1-3.jpg"
      ],
      id: 1,
      maxLimit: 500,
      numberOfReviews: 55,
      rate: 4,
      title: 'قاعة فيكتوريا',
      titleImagePath: 'assets/images/wedding3.jpg'),
  WeddingHallInfo(
      capacity: 134.6,
      price: 10000,
      description:
          "💝العرض يشمل💝 : 1-إيجار قاعة وقت مفتوح 😮 2-تصوير يتكون من صورة كبيرة هدية للعروسين و 100 صورة شبح + تصوير HD مع المونتاج+ صورة دفترية للعروسين 💃 3-استلام موبايلات📱 4-ليزر لايت💡 5-تغليف كراسي و طاولات 💎 6-كوشة عروس👰 7-غرفة تبديل للعروس👰🙎 8-جهاز فقاعات 9-جهاز دخان 🎆🎇 10-ماء + علب كلينكس مجانا 👍 11-تجهيز وجبات طعام حسب المينيو",
      hallImages: [
        "assets/images/wedding1-1.jpeg",
        "assets/images/wedding1-2.jpg",
        "assets/images/wedding1-3.jpg"
      ],
      id: 2,
      maxLimit: 200,
      numberOfReviews: 22,
      rate: 3,
      title: 'قاعة سندباد',
      titleImagePath: 'assets/images/wedding1.jpg'),
  WeddingHallInfo(
      capacity: 100,
      price: 5000,
      description:
          "💝العرض يشمل💝 : 1-إيجار قاعة وقت مفتوح 😮 2-تصوير يتكون من صورة كبيرة هدية للعروسين و 100 صورة شبح + تصوير HD مع المونتاج+ صورة دفترية للعروسين 💃 3-استلام موبايلات📱 4-ليزر لايت💡 5-تغليف كراسي و طاولات 💎 6-كوشة عروس👰 7-غرفة تبديل للعروس👰🙎 8-جهاز فقاعات 9-جهاز دخان 🎆🎇 10-ماء + علب كلينكس مجانا 👍 11-تجهيز وجبات طعام حسب المينيو",
      hallImages: [
        "assets/images/wedding1-1.jpeg",
        "assets/images/wedding1-2.jpg",
        "assets/images/wedding1-3.jpg"
      ],
      id: 3,
      maxLimit: 100,
      numberOfReviews: 32,
      rate: 4.6,
      title: 'قاعة الفردوس',
      titleImagePath: 'assets/images/wedding2.jpg')
];
List<WeddingHallInfo> weddingInfoList2 = [
  WeddingHallInfo(
      capacity: 365.6,
      price: 15000,
      description:
          "💝العرض يشمل💝 : 1-إيجار قاعة وقت مفتوح 😮 2-تصوير يتكون من صورة كبيرة هدية للعروسين و 100 صورة شبح + تصوير HD مع المونتاج+ صورة دفترية للعروسين 💃 3-استلام موبايلات📱 4-ليزر لايت💡 5-تغليف كراسي و طاولات 💎 6-كوشة عروس👰 7-غرفة تبديل للعروس👰🙎 8-جهاز فقاعات 9-جهاز دخان 🎆🎇 10-ماء + علب كلينكس مجانا 👍 11-تجهيز وجبات طعام حسب المينيو",
      hallImages: [
        "assets/images/wedding1-1.jpeg",
        "assets/images/wedding1-2.jpg",
        "assets/images/wedding1-3.jpg"
      ],
      id: 10,
      maxLimit: 500,
      numberOfReviews: 55,
      rate: 4,
      title: 'قاعة اللقلقة',
      titleImagePath: 'assets/images/wedding3.jpg'),
  WeddingHallInfo(
      capacity: 134.6,
      price: 10000,
      description:
          "💝العرض يشمل💝 : 1-إيجار قاعة وقت مفتوح 😮 2-تصوير يتكون من صورة كبيرة هدية للعروسين و 100 صورة شبح + تصوير HD مع المونتاج+ صورة دفترية للعروسين 💃 3-استلام موبايلات📱 4-ليزر لايت💡 5-تغليف كراسي و طاولات 💎 6-كوشة عروس👰 7-غرفة تبديل للعروس👰🙎 8-جهاز فقاعات 9-جهاز دخان 🎆🎇 10-ماء + علب كلينكس مجانا 👍 11-تجهيز وجبات طعام حسب المينيو",
      hallImages: [
        "assets/images/wedding1-1.jpeg",
        "assets/images/wedding1-2.jpg",
        "assets/images/wedding1-3.jpg"
      ],
      id: 11,
      maxLimit: 200,
      numberOfReviews: 22,
      rate: 3,
      title: 'قاعة الفرسان',
      titleImagePath: 'assets/images/wedding1.jpg'),
  WeddingHallInfo(
      capacity: 100,
      price: 5000,
      description:
          "💝العرض يشمل💝 : 1-إيجار قاعة وقت مفتوح 😮 2-تصوير يتكون من صورة كبيرة هدية للعروسين و 100 صورة شبح + تصوير HD مع المونتاج+ صورة دفترية للعروسين 💃 3-استلام موبايلات📱 4-ليزر لايت💡 5-تغليف كراسي و طاولات 💎 6-كوشة عروس👰 7-غرفة تبديل للعروس👰🙎 8-جهاز فقاعات 9-جهاز دخان 🎆🎇 10-ماء + علب كلينكس مجانا 👍 11-تجهيز وجبات طعام حسب المينيو",
      hallImages: [
        "assets/images/wedding1-1.jpeg",
        "assets/images/wedding1-2.jpg",
        "assets/images/wedding1-3.jpg"
      ],
      id: 12,
      maxLimit: 100,
      numberOfReviews: 32,
      rate: 4.6,
      title: 'قاعة البابلش',
      titleImagePath: 'assets/images/wedding2.jpg')
];
