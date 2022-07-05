import 'package:Tiba_Gates/Presentation/admin/reports/searchForReport.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ConnectivityStatus connectionStatus = Provider.of<ConnectivityStatus>(context);

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
                      AutoSizeText(
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
                          navigateTo(context, const DailyReportsScreen());
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
                                      AutoSizeText(
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
                      ), /*Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      offset: Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                    child: SizedBox(
                                      height: 74,
                                      child: AspectRatio(
                                        aspectRatio: 1.714,
                                        child: Image.asset(
                                            "assets/images/back.png"),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 100,
                                              right: 16,
                                              top: 16,
                                            ),
                                            child: Text(
                                              "You're doing great!",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                             *//*   fontFamily:
                                                FitnessAppTheme.fontName,*//*
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: 0.0,
                                                color:
                                                Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 100,
                                          bottom: 12,
                                          top: 4,
                                          right: 16,
                                        ),
                                        child: Text(
                                          "Keep it up\nand stick to your plan!",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            // fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            letterSpacing: 0.0,
                                            color: Colors.grey
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: -16,
                            left: 0,
                            child: SizedBox(
                              width: 110,
                              height: 110,
                              child: Image.asset("assets/images/vip.png"),
                            ),
                          )
                        ],
                      )*/
                      InkWell(
                        onTap: () {
                          navigateTo(context, const PeriodReportsScreen());
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
                                      AutoSizeText(
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
                      )  , SizedBox(
                        height: 12.h,
                      ),

                      InkWell(
                        onTap: () {
                          navigateTo(context, const SearchForReport());
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
                                      AutoSizeText(
                                        'بحث',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: setResponsiveFontSize(28),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 22.w,
                                      ),
                                      const Icon(
                                        FontAwesomeIcons.search,
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
