import 'package:clean_app/Presentation/services_screen/Hotels/hotel_screen.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Gate/gateAccess.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Party/party_main_screen.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Proposals/proposal.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Restaurants/qrScanPopUp.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Sports/Sports.dart';
import 'package:clean_app/Presentation/services_screen/widgets/gridView/gridViewItem.dart';

List<GridViewItemsWidg> gridList = [
  GridViewItemsWidg(
      iconData: "assets/lotties/qr.json",
      title: "تصريح الدخول",
      function: () {
        return GateAccess();
      }),
  GridViewItemsWidg(
    iconData: "assets/lotties/party.json",
    title: "الحفلات",
    function: () {
      return PartMainPage();
    },
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
    function: () {
      return SportsScreen();
    },
  ),
  GridViewItemsWidg(
    iconData: "assets/lotties/hotelBell.json",
    title: "الفندق",
    function: () {
      return HotelScreen();
    },
  ),
  GridViewItemsWidg(
      iconData: "assets/lotties/envelope.json",
      title: "الشكاوى و المقترحات",
      function: () {
        return ProposalScreen();
      }),
];
