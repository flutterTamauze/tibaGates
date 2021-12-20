import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/bottomNavBar.dart';
import 'package:clean_app/Core/Shared/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = "/profile";
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_right,
          ),
          backgroundColor: ColorManager.primary,
          elevation: 5,
        ),
        body: Stack(
          children: [
            Container(
              height: 340,
              child: HeaderWidget(100, false, Icons.house_rounded),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 2, color: Colors.grey),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Positioned(
                        child: Icon(
                          FontAwesomeIcons.camera,
                          color: ColorManager.darkGrey,
                        ),
                        bottom: 0,
                        right: 20.w,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "احمد محمود",
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(22),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Card(
                              elevation: 5,
                              child: Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        ...ListTile.divideTiles(
                                          color: Colors.grey,
                                          tiles: [
                                            ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                              leading: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Icon(Icons.my_location),
                                              ),
                                              title: Text("العنوان"),
                                              subtitle: Text("شارع شبرا"),
                                            ),
                                            ListTile(
                                              leading: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Icon(Icons.email),
                                              ),
                                              title: Text("البريد الألكتروني"),
                                              subtitle: Text("ahmed@gmail.com"),
                                            ),
                                            ListTile(
                                              leading: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Icon(Icons.phone),
                                              ),
                                              title: Text("رقم الهاتف"),
                                              subtitle: Text("01112601115"),
                                            ),
                                            ListTile(
                                              leading: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Icon(Icons.work),
                                              ),
                                              subtitle: Text("مهندس"),
                                              title: Text("الوظيفة"),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          child: Icon(
                        FontAwesomeIcons.edit,
                        color: ColorManager.darkGrey,
                      ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
