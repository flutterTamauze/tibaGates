import 'package:Tiba_Gates/Utilities/Shared/dialogs/exit_dialog2.dart';
import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Shared/exitDialog.dart';
import '../guard/scanner.dart';

class GameHome extends StatefulWidget {
  const GameHome({Key key}) : super(key: key);

  @override
  _GameHomeState createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () => showDialog<Dialog>(context: context, builder: (BuildContext context) => ZoomIn(child: DialogFb1())),
                child: const RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.exit_to_app,
                    size: 30,
                  ),
                )),
            const Text(
              'Game',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
              child: Lottie.asset('assets/lotties/sports.json')),
          SizedBox(
            height: 120.h,
          ),
          RaisedButton(
            color: Colors.white,
            textColor: Colors.green,
            shape: RoundedRectangleBorder(
                side:   BorderSide(color: Colors.green, width: 2.w),
                borderRadius: BorderRadius.circular(15)),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>  const QrCodeScreen(
                        screen: 'sports',
                      )),
                      (Route<dynamic> route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                'تحقق من الكود',
                style: TextStyle(
                    fontSize:
                    setResponsiveFontSize(26)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
