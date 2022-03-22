import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:clean_app/Presentation/admin/dailyReports_screen.dart';
import 'package:clean_app/Presentation/admin/admin_bottomNav.dart';
import 'package:clean_app/Presentation/login_screen/Screens/login.dart';

import '../guard/entry_screen/entryScreen.dart';
import '../manager/m_home_screen.dart';
import '../../Utilities/Routes/routesStrings.dart';
import '../../ViewModel/guard/authProv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> cameras;

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;
  bool isLoggedIn;
  String role;

  Future<void> checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    role = prefs.getString('role');

    if (isLoggedIn == true) {
      debugPrint('isLoggedIn is true');
      if (role == 'Manager') {
        debugPrint('role is manager');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MHomeScreen()));
      }  else if (role == 'Admin') {
        debugPrint('role is admin');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav(comingIndex: 3,)));
      } else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => EntryScreen()));
    } else {
      cameras = await availableCameras();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen(
                    camera: cameras[1],
                  )));
    }
  }

  @override
  void initState() {
    checkSignInStatus();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 2,
          child: ZoomIn(
            child: const Image(
              image: AssetImage(
                'assets/images/tipasplash.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
