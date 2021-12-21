import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/header.dart';
import 'package:clean_app/Data/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = "/profile";
  final User user;
  ProfilePage(this.user);
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

XFile? image;
File? imageFile;

final ImagePicker _picker = ImagePicker();

class _ProfilePageState extends State<ProfilePage> {
  uploadImage() async {
    final String path = join(
      (await getTemporaryDirectory().catchError((e) {
        print("directory error $e");
      }))
          .path,
      '${DateTime.now()}.jpg',
    );
    image = await _picker.pickImage(source: ImageSource.gallery);
    await image!.saveTo(path);
    setState(() {
      print(image!.path);
      imageFile = File(path);
    });
  }

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
              height: 340.h,
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
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: ColorManager.primary),
                            borderRadius: BorderRadius.circular(60)),
                        child: imageFile == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image(
                                  image: AssetImage(
                                      "assets/images/defaultUserImage.jpg"),
                                  width: 100.0.w,
                                  height: 100.0.h,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image(
                                  image: FileImage(imageFile!),
                                  width: 100.0.w,
                                  height: 100.0.h,
                                  fit: BoxFit.cover,
                                )),
                      ),
                      Positioned(
                        child: InkWell(
                          onTap: () {
                            uploadImage();
                          },
                          child: Icon(
                            FontAwesomeIcons.camera,
                            color: ColorManager.grey,
                          ),
                        ),
                        bottom: 0,
                        right: 20.w,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                    widget.user.userName,
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
                                              title: AutoSizeText("العنوان"),
                                              subtitle:
                                                  AutoSizeText("شارع شبرا"),
                                            ),
                                            ListTile(
                                              leading: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Icon(Icons.email),
                                              ),
                                              title: AutoSizeText(
                                                  "البريد الألكتروني"),
                                              subtitle: AutoSizeText(
                                                  widget.user.email),
                                            ),
                                            ListTile(
                                              leading: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Icon(Icons.phone),
                                              ),
                                              title: AutoSizeText("رقم الهاتف"),
                                              subtitle: AutoSizeText(
                                                  widget.user.phoneNumber),
                                            ),
                                            ListTile(
                                              leading: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Icon(Icons.work),
                                              ),
                                              subtitle:
                                                  AutoSizeText(widget.user.job),
                                              title: AutoSizeText("الوظيفة"),
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
