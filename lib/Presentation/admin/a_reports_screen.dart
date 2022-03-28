import 'package:animate_do/animate_do.dart';
import 'reports/periodReports_screen.dart';
import '../../Utilities/connectivityStatus.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'reports/dailyReports_screen.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/dialogs/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AReportsScreen extends StatelessWidget {
  const AReportsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: connectionStatus == ConnectivityStatus.Offline
            ? Center(
                child: SizedBox(
                height: 400.h,
                width: 400.w,
                child: Lottie.asset('assets/lotties/noInternet.json'),
              ))
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/bg1.jpeg',
                        ),
                        fit: BoxFit.fill),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                      ),
                      Center(
                        child: ZoomIn(
                          child: SizedBox(
                            height: (height * 0.17),
                            width: (width * 0.28),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: ColorManager.primary, width: 2.w),
                                image: const DecorationImage(
                                    image:
                                        AssetImage('assets/images/report.png')),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'التقارير',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: setResponsiveFontSize(36),
                          fontWeight: FontManager.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      InkWell(
                        onTap: () {
                          navigateTo(context, DailyReportsScreen());
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Card(
                            elevation: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.arrow_back_ios,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'التقرير اليومى',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: setResponsiveFontSize(28),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 22.w,
                                      ),
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 30,
                                        color: Colors.green,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      InkWell(
                        onTap: () {
                          navigateTo(context, PeriodReportsScreen());
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Card(
                            elevation: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.arrow_back_ios,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'تقرير عن فترة',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: setResponsiveFontSize(28),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 22.w,
                                      ),
                                      const Icon(
                                        FontAwesomeIcons.calendarCheck,
                                        size: 30,
                                        color: Colors.green,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
