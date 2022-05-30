import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../Utilities/responsive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../Data/Models/admin/a_homeBio_model.dart';
import '../guard/scanner.dart';
import 'a_reports_screen.dart';
import 'admin_bottomNav.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/connectivityStatus.dart';
import '../../ViewModel/admin/a_homeBioProv.dart';
import '../../ViewModel/admin/adminProv.dart';
import '../../ViewModel/guard/authProv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ABioHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ABioHomeState();
}

class ABioHomeState extends State {
  int touchedIndex = -1;
  Future listener;
  List<HomeBioModel> parksTypes;
  String token;
  String role;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      setState(() {
        listener =
            Provider.of<AdminHomeProv>(context, listen: false).getBioData();
      });
    });
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();

    listener = Provider.of<AdminHomeProv>(context, listen: false).getBioData();
    token = prefs.getString('token');
    role = prefs.getString('role');
    print(token);
    cachingData();
    print('userId = ${Provider.of<AuthProv>(context, listen: false).userId}');

  }

  void cachingData() async {
    Provider.of<AuthProv>(context, listen: false).token =
        prefs.getString('token');
    Provider.of<AuthProv>(context, listen: false).userRole =
        prefs.getString('role');
    Provider.of<AuthProv>(context, listen: false).userId =
        prefs.getString('guardId');
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return connectionStatus == ConnectivityStatus.Offline
        ? Center(
            child: SizedBox(
            height: 400.h,
            width: 400.w,
            child: Lottie.asset('assets/lotties/noInternet.json'),
          ))
        : FutureBuilder(
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
                parksTypes = Provider.of<AdminHomeProv>(context, listen: false)
                    .parkingList;

                return SafeArea(
                  child: Scaffold(
                    body: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/bg1.jpeg',
                            ),
                            fit: BoxFit.fill),
                      ),
                      height: height,
                      child: SmartRefresher(
                        onRefresh: _onRefresh,
                        controller: _refreshController,
                        enablePullDown: true,
                        header: const WaterDropMaterialHeader(
                          color: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        child: Column(
                          children: [
                                Padding(
                                  padding:  EdgeInsets.only(top: 12.h,left: 8.w),
                                  child: Align(
                              alignment: Alignment.topLeft,
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>  const QrCodeScreen(
                                              screen: 'memberShip_admin',
                                            )),
                                            (Route<dynamic> route) => false);
                                  },
                                  child: SizedBox(
                                    height: 50.h,
                                    width: 50.w,
                                    child:  Center(
                                      child: Icon(
                                        Icons.sports_handball,
                                        color: Colors.pink,
                                        size: isTab(context)? 36:28,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(BorderSide(
                                          color: Colors.pink, width: 1.4.w)),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              vertical: 20.h, horizontal: 20.w)),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))))),
                              ),
                            ),
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
                                        image: AssetImage(
                                            'assets/images/tipasplash.png')),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: isTab(context)? 40.h:10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: SizedBox(
                                height: isTab(context) ? 520.h : 560.h,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              (MediaQuery.of(context).size.height /
                                                  2.5),
                                          crossAxisSpacing: Platform.isIOS
                                              ? 5.w
                                              : isTab(context)
                                                  ? 8.w
                                                  : 1.w,
                                          mainAxisSpacing:
                                              Platform.isIOS ? 7.w : 10.w,
                                          crossAxisCount: 3),
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Card(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.w,
                                                  right: 10.w,
                                                  top: 12.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Icon(
                                                    Icons.directions_car_sharp,
                                                    size: 28,
                                                  ),
                                                  SizedBox(
                                                    width: 6.w,
                                                  ),
                                                  SizedBox(
                                                    width: isTab(context)
                                                        ? 160.w
                                                        : 145.w,
                                                    child: AutoSizeText(
                                                        parksTypes[index].type,
                                                        maxLines: 2,
                                                        textAlign: TextAlign.end,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.green,
                                                            fontSize:
                                                                setResponsiveFontSize(
                                                                    22))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            AutoSizeText(
                                                parksTypes[index].count.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                    fontSize:
                                                        setResponsiveFontSize(30))),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: parksTypes.length,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: isTab(context) ? 30.h : 5.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          AutoSizeText(
                                            'إجمالى عدد السيارات',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    setResponsiveFontSize(22)),
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          AutoSizeText(
                                              Provider.of<AdminHomeProv>(context,
                                                      listen: false)
                                                  .carsCount
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      setResponsiveFontSize(26),
                                                  color: Colors.red)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text('إجمالى الفواتير',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      setResponsiveFontSize(22))),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Text(
                                              Provider.of<AdminHomeProv>(context,
                                                      listen: false)
                                                  .totalBalance
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      setResponsiveFontSize(26),
                                                  color: Colors.red)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
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
                                            height:Platform.isIOS?60.h: 80.h,
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
                      ),
                    ),
                  ),
                );
              }
              return Container();
            });
  }

/*  List<PieChartSectionData> showingSections(BuildContext context) {
    // final ratio = Provider.of<UserData>(context, listen: false).superCompaniesChartModel;

    return List.generate(4, (i) {
      var isTouched = i == touchedIndex;
      var fontSize = isTouched ? 25.0 : 16.0;
      var radius = isTouched ? 60.0 : 50.0;
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
                12 *//*double.parse(ratio.totalExternalMissionRatio.toString())*//*,
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
  }*/
}
