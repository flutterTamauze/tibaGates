import 'dart:io';

import 'package:Tiba_Gates/Utilities/Shared/dialogs/hotel_guest_dialog.dart';
import 'package:Tiba_Gates/Utilities/Shared/noInternet.dart';
import 'package:Tiba_Gates/ViewModel/common/commonProv.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Future<void> cachingData() async {
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
    CommonProv commonProv=Provider.of<CommonProv>(context,listen: false);
    return connectionStatus == ConnectivityStatus.Offline
        ? NoInternet()
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
                        Row(
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(top: 12.h, left: 8.w),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const QrCodeScreen(
                                              screen:
                                              'memberShip_admin',
                                            )),
                                            (Route<dynamic> route) =>
                                        false);
                                  },
                                  child: SizedBox(
                                    height: 50.h,
                                    width: 50.w,
                                    child: Center(
                                      child: Icon(
                                        Icons.sports_handball,
                                        color: Colors.pink,
                                        size: isTab(context) ? 36 : 28,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.pink,
                                              width: 1.4.w)),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              vertical: 20.h,
                                              horizontal: 20.w)),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(top: 12.h, left: 8.w),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const QrCodeScreen(
                                              screen:
                                              'invitation_admin',
                                            )),
                                            (Route<dynamic> route) =>
                                        false);
                                  },
                                  child: SizedBox(
                                    height: 50.h,
                                    width: 50.w,
                                    child:  Center(
                                      child: Icon(
                                        Icons.qr_code,
                                        color: Colors.orange,
                                        size: isTab(context) ? 36 : 28,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.orange,
                                              width: 1.4.w)),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              vertical: 20.h,
                                              horizontal: 20.w)),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))))),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(top: 12.h, left: 8.w),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    String barCode;
                                    try{
                                      barCode=await FlutterBarcodeScanner.scanBarcode('#FF039212', 'Cancel', true, ScanMode.BARCODE);
                                      commonProv.checkBarcodeValidation(barCode).then((value) {
                                        debugPrint('value is $value');

                                        if(value=='Success'){

                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return  HotelGuestDialog(name:commonProv.hotelGuestModel.guestName ,
                                                  fromDate: DateFormat('yyyy-MM-dd / hh:mm').format(DateTime.parse(commonProv.hotelGuestModel.startDate)).toString() ,
                                                  hotelName: commonProv.hotelGuestModel.hotelName,
                                                  toDate:DateFormat('yyyy-MM-dd / hh:mm').format(DateTime.parse(commonProv.hotelGuestModel.endDate)).toString() ,
                                                  onPressed: (){
                                                    debugPrint('log id is ${commonProv.hotelGuestModel.id}');
                                                    commonProv.confirmBarcodeLog(commonProv.hotelGuestModel.id)
                                                        .then((value) {
                                                      if (value == 'Success') {
                                                        showToast(
                                                            'تم التأكيد بنجاح');
                                                        Navigator.pop(context);
                                                      } else {
                                                        showToast('حدث خطأ ما');
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  },);
                                              });

                                        }
                                        else if(value=='invalid'){
                                          showToast('كود غير صحيح');
                                        }
                                        else{
                                          debugPrint('value = $value');
                                        }
                                      });


                                    }on PlatformException{
                                      barCode='Failed to get barcode';
                                    }
                                    if(!mounted) {
                                      return;
                                    }

                                  },
                                  child: SizedBox(
                                    height: 50.h,
                                    width: 50.w,
                                    child:  Center(
                                      child: Icon(
                                        FontAwesomeIcons.barcode,
                                        color: Colors.black,
                                        size: isTab(context) ? 36 : 28,                                          ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.black,
                                              width: 1.4.w)),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              vertical: 20.h,
                                              horizontal: 20.w)),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ZoomIn(
                          child: SizedBox(
                            height: (height * 0.17),
                            width: (width * 0.28),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: ColorManager.primary,
                                    width: 2.w),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/tipasplash.png')),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: isTab(context) ? 40.h : 10.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: SizedBox(
                            height: isTab(context) ? 520.h : 560.h,
                            child: GridView.builder(
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                  MediaQuery.of(context)
                                      .size
                                      .width /
                                      (MediaQuery.of(context)
                                          .size
                                          .height /
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
                                      borderRadius:
                                      BorderRadius.circular(20.0),
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
                                            MainAxisAlignment
                                                .spaceBetween,
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
                                                    textAlign:
                                                    TextAlign.end,
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
                                            parksTypes[index]
                                                .count
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize:
                                                setResponsiveFontSize(
                                                    30))),
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
                        Provider.of<AdminHomeProv>(context, listen: false).carsCount!=null?         Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
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
                                          Provider.of<AdminHomeProv>(context, listen: false).carsCount
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
                                              setResponsiveFontSize(
                                                  22))),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      Text(
                                          Provider.of<AdminHomeProv>(
                                              context,
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
                        ):Container(),
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
                                        height:
                                        Platform.isIOS ? 60.h : 80.h,
                                        //  width: 400.w,

                                        child: Lottie.asset(
                                            'assets/lotties/arrow.json'))),
                                AutoSizeText('الإنتقال إلى التقارير ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                        setResponsiveFontSize(26)))
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


}