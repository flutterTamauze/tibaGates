import 'package:camera/camera.dart';
import 'package:clean_app/Presentation/entry_screen/entryScreen.dart';
import 'package:clean_app/Presentation/intro_screen/Screens/login.dart';
import 'package:clean_app/ViewModel/guard/authProv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
List<CameraDescription> cameras;
class exitDialog extends StatelessWidget {
  const exitDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      backgroundColor: Colors.white,
      title: const Center(
        child: Text(
          'هل انت متأكد؟',
          style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),
      ),
      content: const Text('هل تريد تسجيل الخروج من التطبيق ؟',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Almarai', color: Colors.green)),
      actions: <Widget>[
        Row(
          children: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: Colors.green, width: 1.w)),
                height: 50.h,
                width: 100.w,
                child: const Center(
                  child: Text('لا',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Almarai',
                          color: Colors.green,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            FlatButton(
              onPressed: () async {
                Provider.of<AuthProv>(context,listen: false).logout(Provider.of<AuthProv>(context,listen: false).userId).then((value) async {
                  if(value=='Success'){
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    Provider.of<AuthProv>(context, listen: false).isLogged = false;
                    prefs.setString('guardName', '');

                    prefs.setString('guardId', '');
                    prefs.setBool('isLoggedIn', false);

                    cameras = await availableCameras();
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => LoginScreen(camera: cameras[1],)));
                  }
                });



                // SystemNavigator.pop();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: Colors.red, width: 1.w)),
                height: 50.h,
                width: 100.w,
                child: const Center(
                  child: Text('نعم',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Almarai',
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )
      ],
    );
  }
}
