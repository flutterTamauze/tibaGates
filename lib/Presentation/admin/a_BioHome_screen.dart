import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:clean_app/Data/Models/admin/a_homeBio_model.dart';
import 'package:clean_app/Presentation/admin/a_reports_screen.dart';
import 'package:clean_app/Presentation/admin/admin_bottomNav.dart';
import 'package:clean_app/Utilities/Colors/colorManager.dart';
import 'package:clean_app/Utilities/Constants/constants.dart';
import 'package:clean_app/Utilities/Fonts/fontsManager.dart';
import 'package:clean_app/ViewModel/admin/a_homeBioProv.dart';
import 'package:clean_app/ViewModel/admin/adminProv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ABioHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ABioHomeState();
}

class ABioHomeState extends State {
  int touchedIndex = -1;
  Future listener;
  List<HomeBioModel> parksTypes;

  @override
  void initState() {
    super.initState();
    /*  final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    print('date $formatted');*/
    listener = Provider.of<AdminHomeProv>(context, listen: false).getBioData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: listener,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            parksTypes =
                Provider.of<AdminHomeProv>(context, listen: false).parkingList;

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/bg1.jpeg',
                    ),
                    fit: BoxFit.fill),
              ),
              height: height,
              child: Column(
                children: [
                  SizedBox(
                    height: 60.h,
                  ),
                  ZoomIn(
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
                                  AssetImage('assets/images/tipasplash.png')),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
/*                      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 100.w, top: 100.h),
                        child: SizedBox(
                          height: 100.h,
                          width: 200.w,
                          child: PieChart(
                            PieChartData(
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: 60,
                                sections: showingSections(context)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 100.w, top: 100.h),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 30.h,
                                  width: 30.w,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 25.w,
                                ),
                                SizedBox(
                                  width: 100.w,
                                  child: Text(
                                    'ق.م',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: setResponsiveFontSize(20),
                                        fontWeight: FontManager.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 30.h,
                                  width: 30.w,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 25.w,
                                ),
                                SizedBox(
                                  width: 100.w,
                                  child: Text(
                                    'عضو دار',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: setResponsiveFontSize(20),
                                        fontWeight: FontManager.bold),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 30.h,
                                  width: 30.w,
                                  color: Colors.red[600],
                                ),
                                SizedBox(
                                  width: 25.w,
                                ),
                                SizedBox(
                                  width: 100.w,
                                  child: Text(
                                    'مدنى',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: setResponsiveFontSize(20),
                                        fontWeight: FontManager.bold),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 30.h,
                                  width: 30.w,
                                  color: Colors.purple[600],
                                ),
                                SizedBox(
                                  width: 25.w,
                                ),
                                SizedBox(
                                  width: 100.w,
                                  child: Text(
                                    'أنشطة',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: setResponsiveFontSize(20),
                                        fontWeight: FontManager.bold),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )*/
                  SizedBox(
                    height: 60.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SizedBox(
                      height: 500.h,
                      child: GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio:
                                    MediaQuery.of(context).size.width /
                                        (MediaQuery.of(context)
                                                .size
                                                .height /
                                            2.5),
                                crossAxisSpacing:
                                    Platform.isIOS ? 5.w : 8.w,
                                mainAxisSpacing:
                                    Platform.isIOS ? 7.w : 10.w,
                                crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16,right: 16,top: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                          Icons.directions_car_sharp,size: 28,),
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                      Text(parksTypes[index].type,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize:
                                                  setResponsiveFontSize(
                                                      22))),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(parksTypes[index].count.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize:
                                            setResponsiveFontSize(30))),
                              ],
                            ),
                          );
                        },
                        itemCount: parksTypes.length,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20  ),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'إجمالى عدد السيارات',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: setResponsiveFontSize(22)),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Text(
                                    Provider.of<AdminHomeProv>(context, listen: false)
                                        .carsCount
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: setResponsiveFontSize(26),
                                        color: Colors.red)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('إجمالى الفواتير',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: setResponsiveFontSize(22))),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Text(
                                    Provider.of<AdminHomeProv>(context, listen: false)
                                        .totalBalance
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: setResponsiveFontSize(26),
                                        color: Colors.red)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          BottomNav(
                            comingIndex: 2,
                          ));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 210.w),
                      child: Row(
                        children: [
                          RotatedBox(
                              quarterTurns: 2,
                              child: SizedBox(
                                  height: 80.h,
                                  //  width: 400.w,

                                  child: Lottie.asset(
                                      'assets/lotties/arrow.json'))),
                          Text('الإنتقال إلى التقارير ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: setResponsiveFontSize(26)))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        });
  }

  List<PieChartSectionData> showingSections(BuildContext context) {
    // final ratio = Provider.of<UserData>(context, listen: false).superCompaniesChartModel;

    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.orange,
            value: 30,
            title: 30.toStringAsFixed(0) + ' %',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red[600],
            value: 40,
            title: 40.toStringAsFixed(0) + ' %',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: 26,
            title: 26.toStringAsFixed(0) + ' %',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.purple[600],
            value:
                12 /*double.parse(ratio.totalExternalMissionRatio.toString())*/,
            title: 12.toStringAsFixed(0) + ' %',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
