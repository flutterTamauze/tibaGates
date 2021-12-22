import 'package:clean_app/Presentation/home_screen/Screens/home.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Restaurants/qrScanPopUp.dart';
import 'package:clean_app/Presentation/services_screen/widgets/gridView/gridViewItem.dart';
import 'package:flutter/material.dart';

List<GridViewItemsWidg> gridList = [
  GridViewItemsWidg(
    iconData: "assets/lotties/qr.json",
    title: "تصريح الدخول",
    function: null,
  ),
  GridViewItemsWidg(
    iconData: "assets/lotties/party.json",
    title: "الحفلات",
    function: null,
  ),
  GridViewItemsWidg(
    iconData: "assets/lotties/burger.json",
    title: "المطاعم",
    function: () {
      return RestaurantQR();
    },
  ),
  GridViewItemsWidg(
    iconData: "assets/lotties/sport.json",
    title: "الأنشطة الرياضية",
    function: null,
  ),
  GridViewItemsWidg(
    iconData: "assets/lotties/hotelBell.json",
    title: "الفندق",
    function: null,
  ),
  GridViewItemsWidg(
    iconData: "assets/lotties/envelope.json",
    title: "الشكاوى و المقترحات",
    function: null,
  ),
];
