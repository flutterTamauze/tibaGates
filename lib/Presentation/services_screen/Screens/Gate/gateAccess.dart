import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Routes/routesStrings.dart';
import 'package:clean_app/Data/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GateAccess extends StatefulWidget {
  @override
  _GateAccessState createState() => _GateAccessState();
}

int levelClock = 60;

final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

class _GateAccessState extends State<GateAccess> with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(seconds: levelClock), vsync: this);

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.primary,
            elevation: 5,
            leading: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutesPath.profile,
                    arguments: user1);
              },
              child: Icon(
                Icons.person,
                color: ColorManager.backGroundColor,
                size: 30,
              ),
            ),
            actions: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.chevron_left,
                      size: 30,
                    ),
                  )),
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AutoSizeText(
                        "الأعضاء فقط يمكنهم الدخول عبر مسح الكود على البوابة",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: setResponsiveFontSize(15)),
                      ),
                      Countdown(
                        animation: StepTween(
                          begin: levelClock,
                          end: 0,
                        ).animate(_controller),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({required this.animation}) : super(listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // print('animation.value  ${animation.value} ');
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print(
    //     'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 250.h,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black)),
            child: QrImage(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              //plce where the QR Image will be shown
              data: "احمد",
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        animation.isCompleted
            ? AutoSizeText(
                "تم انتهاء صلاحية الكود",
                style: TextStyle(fontWeight: FontWeight.w700),
              )
            : Column(
                children: [
                  AutoSizeText(
                    ":سوف يتم انتهاء صلاحية الكود فى ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    "$timerText",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.red[800],
                    ),
                  ),
                ],
              )
      ],
    );
  }
}
