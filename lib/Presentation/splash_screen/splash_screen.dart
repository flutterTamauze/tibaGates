import 'dart:async';
import 'dart:developer';
import 'package:flutter/scheduler.dart';

import '../../main.dart';
import '../casher/casherEntry_screen.dart';
import '../casher/casherHome_screen.dart';
import '../../Utilities/Constants/constants.dart';
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
  static const String routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;
  bool isLoggedIn;
  String role;

  Future<void> checkSignInStatus() async {
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if(prefs.getString('baseUrl')==null){
      prefs.setString('baseUrl', 'https://tibarose.tibarosehotel.com');
    }

    role = prefs.getString('role');

    if (isLoggedIn == true) {
      if (role == 'Manager') {
        debugPrint('role is manager');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          navigateTo(context, const MHomeScreen());
        });

        return;
      } else if (role == 'Guard') {
        debugPrint('role is Guard');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          navigateTo(context, const EntryScreen());
        });

        return;
      } else if (role == 'GameGuard') {
        debugPrint('role is GameGuard');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          navigateTo(context, const GameHome());
        });

        return;
      } else if (role == 'Admin') {
        debugPrint('role is admin');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          navigateTo(
              context,
              BottomNav(
                comingIndex: 3,
              ));
        });

        return;
      } else if (role == 'Cashier') {
        debugPrint('role is Cashier');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          navigateTo(context, const CasherEntryScreen());
        });
        return;
      } else {
        debugPrint('role => $role');
        showToast('This user has no role !!');

        //  navigateReplacementTo(context, const EntryScreen());
        return;
      }
    } else {
      cameras = await availableCameras();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        navigateTo(
            context,
            LoginScreen(
              camera: cameras[1],
            ));
      });

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
