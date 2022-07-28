import 'dart:async';
import 'dart:developer';
import 'package:Tiba_Gates/Presentation/casher/casherEntry_screen.dart';
import 'package:Tiba_Gates/Presentation/casher/casherHome_screen.dart';
import 'package:Tiba_Gates/Utilities/Constants/constants.dart';
import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import '../game/game_home.dart';
import '../admin/admin_bottomNav.dart';
import '../login_screen/Screens/login.dart';
import '../guard/entryScreen.dart';
import '../manager/m_home_screen.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

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
        navigateReplacementTo(context, const CasherEntryScreen());
        return;
      } else {
        debugPrint('role is $role');
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





/*
  void testReceipt(NetworkPrinter printer) {
    printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));

    printer.text('Bold text', styles: PosStyles(bold: true));
    printer.text('Reverse text', styles: PosStyles(reverse: true));
    printer.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    printer.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    printer.feed(2);
    printer.cut();
  }
*/



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
