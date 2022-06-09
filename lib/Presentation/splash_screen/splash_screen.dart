import 'dart:async';
import 'dart:developer';
import 'package:Tiba_Gates/Presentation/casher/casherHome_screen.dart';
import 'package:Tiba_Gates/Utilities/Constants/constants.dart';
import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import '../game/game_home.dart';
import '../admin/admin_bottomNav.dart';
import '../login_screen/Screens/login.dart';
import '../guard/entryScreen.dart';
import '../manager/m_home_screen.dart';
import 'package:flutter/material.dart';
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
      if (role == 'Manager') {
        debugPrint('role is manager');
        navigateReplacementTo(context, const MHomeScreen());
        return;
      }

      if (role == 'GameGuard') {
        debugPrint('role is GameGuard');
        navigateReplacementTo(context, const GameHome());

        return;
      } else if (role == 'Admin') {
        debugPrint('role is admin');
        navigateReplacementTo(
            context,
            BottomNav(
              comingIndex: 3,
            ));

        return;
      } else if (role == 'Cashier') {
        debugPrint('role is Cashier');
        navigateReplacementTo(context, const CasherHomeScreen());
        return;
      } else {
        navigateReplacementTo(context, const EntryScreen());
        return;
      }
    } else {
      cameras = await availableCameras();
      navigateReplacementTo(
          context,
          LoginScreen(
            camera: cameras[1],
          ));

      return;
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
