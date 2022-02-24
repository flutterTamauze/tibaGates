import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:clean_app/Core/Routes/routesStrings.dart';
import 'package:clean_app/Core/imageAssets/assetsManager.dart';
import 'package:clean_app/Presentation/entry_screen/entryScreen.dart';
import 'package:clean_app/Presentation/intro_screen/Screens/login.dart';
import 'package:clean_app/ViewModel/authProv.dart';
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

  _startDelay() {
    _timer = Timer(Duration(seconds: 2), _goNext);
  }

  _goNext() {
    Navigator.pushReplacementNamed(context, RoutesPath.intro);
  }
  bool isLoggedIn;


  Future<void> checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn == true) {
      print('isLoggedIn is true');


      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EntryScreen()));

    } else {
      cameras = await availableCameras();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IntroScreen(camera: cameras[1],)));
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
        child: Container(
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width/2,
          child: ZoomIn(
            child: Image(
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
