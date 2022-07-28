import 'package:Tiba_Gates/Presentation/login_screen/Screens/login.dart';
import 'package:Tiba_Gates/Utilities/Constants/constants.dart';
import 'package:Tiba_Gates/Utilities/responsive.dart';
import 'package:Tiba_Gates/ViewModel/guard/authProv.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import 'loading_dialog.dart';

List<CameraDescription> cameras;

class DialogFb1 extends StatelessWidget {
  const DialogFb1({Key key}) : super(key: key);
  final primaryColor = const Color(0xffff6666);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: isTab(context)
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius:isTab(context)?35 :25,
              child:  Icon(
                Icons.exit_to_app,
                color: Colors.white,size: isTab(context) ?36:26,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text('هل انت متأكد؟',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height:isTab(context)? 16:3.5,
            ),
            AutoSizeText('هل تريد بالفعل تسجيل الخروج من التطبيق ؟',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize:isTab(context)? setResponsiveFontSize(26):setResponsiveFontSize(16),
                    fontWeight: FontWeight.w300)),
            SizedBox(
              height:isTab(context)? 30.h:15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleBtn1(
                  text: 'لا',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  invertedColors: true,
                ),
                SimpleBtn1(
                    text: 'نعم',
                    onPressed: () {
                      showLoaderDialog(context, 'جارى تسجيل الخروج');
                      debugPrint(
                          'userId ${Provider.of<AuthProv>(context, listen: false).userId}');
                      Provider.of<AuthProv>(context, listen: false)
                          .logout(Provider.of<AuthProv>(context, listen: false)
                          .userId)
                          .then((value) async {
                        if (value == 'Success' || value == 'incorrect user') {
                          Provider.of<AuthProv>(context, listen: false)
                              .isLogged = false;

                          prefs.setString('guardName', '');
                          prefs.setString('guardId', '');
                          prefs.setBool('isLoggedIn', false);

                          cameras = await availableCameras();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                    camera: cameras[1],
                                  )));
                        }
                        else{
                          showToast('حدث خطأ ما , برجاء المحاولة مجدداً');
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      });
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SimpleBtn1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool invertedColors;

  const SimpleBtn1(
      {this.text, this.onPressed, this.invertedColors = false, Key key})
      : super(key: key);
  final primaryColor = const Color(0xffff6666);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: primaryColor)),
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
            backgroundColor: MaterialStateProperty.all(
                invertedColors ? accentColor : primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AutoSizeText(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: invertedColors ? primaryColor : accentColor, fontSize: 16),
          ),
        ));
  }
}