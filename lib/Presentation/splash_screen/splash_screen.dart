import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';

import 'package:clean_app/Presentation/entry_screen/entryScreen.dart';
import 'package:clean_app/Presentation/intro_screen/Screens/login.dart';
import 'package:clean_app/Presentation/manager/m_home_screen.dart';
import 'package:clean_app/Utilities/Routes/routesStrings.dart';
import 'package:clean_app/ViewModel/guard/authProv.dart';
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
    role = prefs.getString('role') ;

    if (isLoggedIn == true) {
      print('isLoggedIn is true');
if(role=='Manager'){
  print('role is manager');
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MHomeScreen()));
}
else

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EntryScreen()));

    } else {
      cameras = await availableCameras();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen(camera: cameras[1],)));
    }
  }
  @override
  void initState() {
    checkSignInStatus();
    // _startDelay();
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
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width/2,
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