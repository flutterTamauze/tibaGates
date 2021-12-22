import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Routes/routesStrings.dart';
import 'package:clean_app/Core/Shared/drawer/drawer.dart';
import 'package:clean_app/Data/Models/user.dart';
import 'package:clean_app/Presentation/services_screen/Screens/Restaurants/qrCodeScreen.dart';
import 'package:clean_app/Presentation/services_screen/widgets/qrScan/tableQrScan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestaurantQR extends StatelessWidget {
  const RestaurantQR({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = user1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        elevation: 5,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutesPath.profile, arguments: user);
          },
          child: Icon(
            Icons.person,
            color: ColorManager.backGroundColor,
            size: 30,
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
                  Icons.chevron_left,
                  size: 30,
                ),
              )),
        ],
      ),
      body: Center(
        child: QrAlert(),
      ),
    );
  }
}
