import 'package:clean_app/Utilities/Fonts/fontsManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'a_BioHome_screen.dart';
import 'a_reports_screen.dart';
import 'dailyReports_screen.dart';
import 'moreScreen/more_screen.dart';

class BottomNav extends StatefulWidget {
  int comingIndex = -1;

  BottomNav({this.comingIndex});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 3;

  final tabs = [
    MoreScreen(),
    ADailyReportsScreen(),
    AReportsScreen(),
    ABioHome(),
  ];

  @override
  void initState() {
    (widget.comingIndex != -1 && widget.comingIndex != null)
        ? currentIndex = widget.comingIndex
        : currentIndex = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: tabs[currentIndex],
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 16),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                  // sets the background color of the `BottomNavigationBar`
                  canvasColor: Colors.green,
                  // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                  primaryColor: Colors.grey[400],
                  textTheme: Theme.of(context)
                      .textTheme
                      .copyWith(caption: const TextStyle(color: Colors.yellow))),
              child: BottomNavigationBar(
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                unselectedItemColor: Colors.grey[400],
                selectedItemColor: Colors.white,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                currentIndex: currentIndex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: 'الإعدادات'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.card_giftcard), label: 'الدعوات'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.description), label: 'التقارير'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'الرئيسية'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
