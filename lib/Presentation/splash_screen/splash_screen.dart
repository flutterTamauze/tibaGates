import 'dart:async';
import 'dart:developer';

import 'package:Tiba_Gates/Presentation/game/game_home.dart';
import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import '../admin/a_invitations_screen.dart';
import '../admin/admin_bottomNav.dart';
import '../login_screen/Screens/login.dart';

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
      if (role == 'Manager') {
        debugPrint('role is manager');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MHomeScreen()));
        return;
      }if (role == 'GameGuard') {
        debugPrint('role is GameGuard');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => GameHome()));
        return;
      } else if (role == 'Admin') {
        debugPrint('role is admin');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNav(
                  comingIndex: 3,
                )));
        return;
      } else {
        log('geet 3nd splash else');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => EntryScreen()));
        return;
      }
    } else {
      cameras = await availableCameras();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen(
                camera: cameras[1],
              )));
      return;
    }
  }

  @override
  void initState() {
    log('geet 3nd splash');
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
