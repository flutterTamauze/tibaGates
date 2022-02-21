import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Routes/routesStrings.dart';
import 'package:clean_app/Core/Shared/header.dart';
import 'package:clean_app/Core/Shared/sharedWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ProfileSignUp extends StatefulWidget {
  const ProfileSignUp({Key key}) : super(key: key);

  @override
  _ProfileSignUpState createState() => _ProfileSignUpState();
}

//XFile image;
File imageFile;
//final ImagePicker _picker = ImagePicker();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _confirmPasswordController =
    TextEditingController();

class _ProfileSignUpState extends State<ProfileSignUp> {
  final _signUpKey = GlobalKey<FormState>();
  uploadImage() async {
    try {
      final String path = join(
        (await getTemporaryDirectory().catchError((e) {
          print("directory error $e");
        }))
            .path,
        '${DateTime.now()}.jpg',
      );
     // image = await _picker.pickImage(source: ImageSource.gallery);
    //  await image.saveTo(path);
      setState(() {
    //    print(image.path);
        imageFile = File(path);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _nameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
/*    final popup = BeautifulPopup(
      context: context,
      template: TemplateSuccess,
    );*/
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Form(
            key: _signUpKey,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    AutoSizeText(
                      "إنشاء حساب جديد",
                      style: boldStyle.copyWith(
                          fontSize: setResponsiveFontSize(20)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      'ادخل بياناتك للتسجيل',
                      style: TextStyle(
                        fontSize: setResponsiveFontSize(14),
                        color: ColorManager.lightGrey,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: ColorManager.primary),
                              borderRadius: BorderRadius.circular(60)),
                          child: imageFile == null
                              ? CircularImage(
                                  assetImage:
                                      'assets/images/defaultUserImage.jpg',
                                )
                              : CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.height / 14,
                                  backgroundColor: const Color(0xFF778899),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: new Image.file(
                                      imageFile,
                                      fit: BoxFit.fill,
                                      width: 120.w,
                                      height: 120.h,
                                    ),
                                  ), //For Image Asset
                                ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    SignTextField(
                      validation: (String v) {
                        if (v.isEmpty) {
                          return "مطلوب";
                        }
                      },
                      hint: "اسم المستخدم",
                      iconData: Icons.person,
                      textEditingController: _nameController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SignTextField(
                      iconData: Icons.lock,
                      validation: (String v) {
                        if (v.isEmpty) {
                          return "مطلوب";
                        }
                      },
                      hint: "كلمة المرور",
                      textEditingController: _passwordController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SignTextField(
                      iconData: Icons.lock,
                      validation: (String v) {
                        if (v.isEmpty) {
                          return "مطلوب";
                        } else if (v != _passwordController.text) {
                          return "كلمة المرور غير متطابقة";
                        }
                      },
                      hint: "تأكيد كلمة المرور",
                      textEditingController: _confirmPasswordController,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RoundedButton(
                      ontap: () {
                        if (!_signUpKey.currentState.validate()) {
                          return;
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Container(
                                  height: 450.h,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.topCenter,
                                            height: 250.h,
                                            width: double.infinity,
                                            child: Image.asset(
                                              "assets/images/curved.png",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Positioned(
                                              top: 0,
                                              child: Container(
                                                width: 300,
                                                height: 220.h,
                                                child: Lottie.asset(
                                                    "assets/lotties/success.json",
                                                    repeat: false),
                                              )),
                                        ],
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: AutoSizeText(
                                            "تم إنشاء الحساب بنجاح برجاء تسجيل الدخول للمتابعة",
                                            textAlign: TextAlign.center,
                                            style:
                                                boldStyle.copyWith(height: 1.5),
                                          )),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: RoundedButton(
                                          buttonColor: ColorManager.primary
                                              .withOpacity(0.8),
                                          ontap: () {
                                            Navigator.pushReplacementNamed(
                                                context, RoutesPath.intro);
                                          },
                                          title: "تسجيل الدخول",
                                          titleColor:
                                              ColorManager.backGroundColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          // popup.show(
                          //   title: 'تم انشاء الحساب بنجاح',
                          //   content: '',
                          //   actions: [
                          //     popup.button(
                          //       label: 'تسجيل الدخول',
                          //       onPressed: Navigator.of(context).pop,
                          //     ),
                          //   ],
                          //   // bool barrierDismissible = false,
                          //   // Widget close,
                          // );
                        }
                      },
                      title: "إنشاء الحساب",
                      buttonColor: ColorManager.primary,
                      titleColor: ColorManager.backGroundColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircularImage extends StatelessWidget {
  final String assetImage;
  const CircularImage({
     this.assetImage,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.height / 12,
      backgroundColor: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: new Image.asset(
          assetImage,
          fit: BoxFit.fill,
          width: 155.w,
          height: 155.h,
        ),
      ), //For Image Asset
    );
  }
}

class SignTextField extends StatelessWidget {
  const SignTextField({
     this.hint,
     this.textEditingController,
     this.validation,
     this.iconData,
    Key key,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final String hint;
  final Function validation;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.all(5),
      child: TextFormField(
        validator: (value) {
          return validation(value);
        },
        controller: textEditingController,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
            icon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                iconData,
                color: ColorManager.primary,
              ),
            ),
            border: InputBorder.none,
            hintText: hint,
            errorStyle: TextStyle(
              height: 0.1,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w)),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        color: const Color(0xfff2f2f2),
      ),
    );
  }
}
