import 'dart:io';
import 'package:animate_do/animate_do.dart';
import '../../../Utilities/responsive.dart';
import '../../../Data/Models/admin/weeklyHolidays.dart';
import '../../../Utilities/connectivityStatus.dart';
import '../../../ViewModel/admin/more/holidaysProv.dart';
import 'package:lottie/lottie.dart';
import '../admin_bottomNav.dart';
import '../../../Utilities/Colors/colorManager.dart';
import '../../../Utilities/Constants/constants.dart';
import '../../../Utilities/Fonts/fontsManager.dart';
import '../../../Utilities/Shared/dialogs/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';

class WeeklyHolidaysScreen extends StatefulWidget {
  const WeeklyHolidaysScreen({Key key}) : super(key: key);

  @override
  _WeeklyHolidaysScreenState createState() => _WeeklyHolidaysScreenState();
}

class _WeeklyHolidaysScreenState extends State<WeeklyHolidaysScreen> {
  List<WeeklyHolidaysModel> holidaysList = [];
  Future holidaysListener;

  @override
  void initState() {
    super.initState();
    holidaysListener =
        Provider.of<HolidaysProv>(context, listen: false).getWeeklyHolidays();
  }

  @override
  Widget bodyData() => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, top: 16.h, bottom: 16.h),
            child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      'اليوم',
                      style: TextStyle(
                          fontSize: isTab(context)
                              ? setResponsiveFontSize(24)
                              : setResponsiveFontSize(28),
                          color: Colors.black,
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text(
                      'الحالة',
                      style: TextStyle(
                          fontSize: isTab(context)
                              ? setResponsiveFontSize(24)
                              : setResponsiveFontSize(28),
                          color: Colors.black,
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text(
                      'تغيير',
                      style: TextStyle(
                          fontSize: isTab(context)
                              ? setResponsiveFontSize(24)
                              : setResponsiveFontSize(28),
                          color: Colors.black,
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                  ),
                ],
                rows: holidaysList
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            Text(e.day,
                                style: TextStyle(
                                    fontSize: isTab(context)
                                        ? setResponsiveFontSize(18)
                                        : setResponsiveFontSize(22),
                                    color: Colors.black,
                                    fontWeight: FontManager.bold)),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(
                                e.isHoliday.toString() == 'true'
                                    ? 'أجازة'
                                    : 'عمل',
                                style: TextStyle(
                                    fontSize: isTab(context)
                                        ? setResponsiveFontSize(22)
                                        : setResponsiveFontSize(24),
                                    color: e.isHoliday.toString() == 'true'
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontManager.bold)),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showLoaderDialog(context, 'جارى التغيير');
                                    Provider.of<HolidaysProv>(context,
                                            listen: false)
                                        .updateWeeklyHolidays(
                                            e.id,
                                            e.day,
                                            e.isHoliday == 'false'
                                                ? 'true'
                                                : 'false')
                                        .then((value) {
                                      if (value == 'Success') {
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
                                  child: Icon(
                                    e.isHoliday.toString() == 'true'
                                        ? Icons.toggle_off
                                        : Icons.toggle_on,
                                    color: e.isHoliday.toString() == 'true'
                                        ? Colors.blueGrey
                                        : Colors.green,
                                    size: 36,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            ),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                        ],
                      ),
                    )
                    .toList()),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var holidayProv = Provider.of<HolidaysProv>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return SafeArea(
      child: Scaffold(
        body: connectionStatus == ConnectivityStatus.Offline
            ? Center(
                child: SizedBox(
                height: 400.h,
                width: 400.w,
                child: Lottie.asset('assets/lotties/noInternet.json'),
              ))
            : WillPopScope(
                onWillPop: () {
                  navigateTo(
                      context,
                      BottomNav(
                        comingIndex: 0,
                      ));
                },
                child: Column(
                  children: [
                    InkWell(onTap: ()=>    navigateTo(
                        context,
                        BottomNav(
                          comingIndex: 0,
                        )),
                      child: Padding(
                        padding:  EdgeInsets.only(top: 12.h,left: 30.w),
                        child: const Align(
                            alignment: Alignment.topLeft,

                            child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30,)),
                      ),
                    ),

                    SizedBox(
                      height:Platform.isIOS?10.h: 30.h,
                    ),
                    ZoomIn(
                      child: SizedBox(
                        height: (height * 0.17),
                        width: (width * 0.32),
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
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      'قائمة الأجازات الحالية',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: setResponsiveFontSize(38)),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    FutureBuilder(
                        future: holidaysListener,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Platform.isIOS
                                  ? const CupertinoActivityIndicator()
                                  : const Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            holidaysList =
                                Provider.of<HolidaysProv>(context, listen: true)
                                    .holidaysObjects;
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: bodyData(),
                            ));
                          }
                          return Container();
                        }),
                  ],
                )),
        backgroundColor: Colors.green,
      ),
    );
  }
}
