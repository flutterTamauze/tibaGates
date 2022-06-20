// ignore_for_file: missing_return
import 'dart:io';
import 'package:Tiba_Gates/Presentation/casher/casherHome_screen.dart';
import 'package:Tiba_Gates/ViewModel/common/commonProv.dart';

import '../guard/scanner.dart';
import '../login_screen/Widgets/outlined_button.dart';
import '../../Utilities/Shared/noInternet.dart';
import '../../ViewModel/casher/servicesProv.dart';
import '../../Utilities/Shared/dialogs/exit_dialog2.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../Utilities/connectivityStatus.dart';
import '../../../Utilities/Colors/colorManager.dart';
import '../../../Utilities/Constants/constants.dart';
import '../../../Utilities/Fonts/fontsManager.dart';
import '../../../Utilities/Shared/sharedWidgets.dart';
import '../../../ViewModel/guard/authProv.dart';
import '../../../ViewModel/guard/visitorProv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';

class AreaManagerEntryScreen extends StatefulWidget {
  const AreaManagerEntryScreen({Key key}) : super(key: key);

  @override
  State<AreaManagerEntryScreen> createState() => _AreaManagerEntryScreenState();
}

class _AreaManagerEntryScreenState extends State<AreaManagerEntryScreen> {
  String token;

  @override
  void initState() {
    super.initState();
    token = prefs.getString('token');
    print(token);
    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
      cachingData();
    });
  }

  Future<void> cachingData() async {
    Provider.of<VisitorProv>(context, listen: false).logId = null;
    Provider.of<AuthProv>(context, listen: false).guardName =
        prefs.getString('guardName');
    Provider.of<AuthProv>(context, listen: false).printerAddress =
        prefs.getString('printerAddress');
 /*   Provider.of<CommonProv>(context, listen: false).balance =
        prefs.getDouble('balance');*/
    Provider.of<AuthProv>(context, listen: false).lostTicketPrice =
        prefs.getDouble('ticketLostPrice');
    Provider.of<AuthProv>(context, listen: false).gateName =
        prefs.getString('gateName');
    Provider.of<AuthProv>(context, listen: false).token =
        prefs.getString('token');
    Provider.of<AuthProv>(context, listen: false).userId =
        prefs.getString('guardId');
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ConnectivityStatus connectionStatus =
    Provider.of<ConnectivityStatus>(context);

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: connectionStatus == ConnectivityStatus.Offline
            ? NoInternet()
            : SafeArea(
            child: Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/bg1.jpeg',
                    ),
                    fit: BoxFit.fill),
              ),
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                      ),
                      Hero(
                        tag: 'logo',
                        child: ZoomIn(
                          child: SizedBox(
                            height: (height * 0.17),
                            width: (width * 0.32),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: ColorManager.primary, width: 2.w),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/tipasplash.png')),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80.h,
                      ),
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 70.h, horizontal: 70.w),
                          child: Column(
                            children: [

                         RoundedButton(
                                ontap: () async {

                                },
                                title: 'تسجيل مستخدم',
                                width: 250,
                                height: 55,
                                buttonColor: Colors.black,
                                titleColor: ColorManager.backGroundColor,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 420.h,
                      ),
                      FadeInUp(
                          child: OutlineButtonFb1(
                            text: 'Logout',
                            onPressed: () => showDialog<Dialog>(
                                context: context,
                                builder: (BuildContext context) =>
                                    ZoomIn(child: const DialogFb1())),
                          ))
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
