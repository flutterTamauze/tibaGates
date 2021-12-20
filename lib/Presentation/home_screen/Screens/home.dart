import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Routes/routesStrings.dart';
import 'package:clean_app/Core/Shared/bottomNavBar.dart';
import 'package:clean_app/Core/Shared/drawer/drawer.dart';
import 'package:clean_app/Presentation/home_screen/Widgets/news.dart';
import 'package:clean_app/Presentation/services_screen/Screens/services_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(currentIndex);
      },
      child: Scaffold(
        endDrawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: ColorManager.backGroundColor,
          elevation: 5,
          leading: InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutesPath.profile);
            },
            child: Icon(
              Icons.person,
              color: ColorManager.accentColor,
              size: 30,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Builder(builder: (context) {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Icon(
                    Icons.menu,
                    color: ColorManager.accentColor,
                    size: 30,
                  ),
                );
              }),
            )
          ],
        ),
        bottomNavigationBar: AnimatedBottomNavBar(
          getCurrentIndex: (newIndex) {
            setState(() {
              currentIndex = newIndex;
            });
          },
        ),
        body: Column(
          children: [currentIndex == 2 ? ServiceScreen() : NewsDisplay()],
        ),
      ),
    );
  }
}
