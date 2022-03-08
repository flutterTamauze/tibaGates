import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:clean_app/Data/Models/admin/parking.dart';
import 'package:clean_app/Presentation/guard/entry_screen/entryScreen.dart';
import 'package:clean_app/Utilities/Shared/exitDialog.dart';
import 'package:clean_app/ViewModel/admin/adminProv.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/services.dart';

import '../../Data/Models/guard/parked_model.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import '../../ViewModel/guard/authProv.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../main.dart';
import '../guard/print_page2.dart';

class AHomeScreen extends StatefulWidget {
  const AHomeScreen({Key key}) : super(key: key);

  @override
  _AHomeScreenState createState() => _AHomeScreenState();
}

class _AHomeScreenState extends State<AHomeScreen> {
  Future parkingCarsListener;
  String searchText;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ParkingModel> parkingList;
  var tmpList;

  @override
  void initState() {
    parkingCarsListener =
        Provider.of<AdminProv>(context, listen: false).getParkingListForAdmin();
    super.initState();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      setState(() {
        parkingCarsListener = Provider.of<AdminProv>(context, listen: false)
            .getParkingListForAdmin();
      });
    });
    _refreshController.refreshCompleted();
  }

  void filterServices(value) {
    print('inside filter');

    setState(() {
      tmpList = parkingList
          .where((item) => item.logId.toString().contains(value.toString()))
          .toList();

      print('filtered list now isss ${tmpList.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    var adminProv = Provider.of<AdminProv>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => ZoomIn(
                              child: const exitDialog(),
                            ));
                  },
                  child: const RotatedBox(
                    quarterTurns: 2,
                    child: Icon(
                      Icons.exit_to_app,
                      size: 30,
                    ),
                  )),
              const Text('Admin')
            ],
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            SystemNavigator.pop();
            throw '';
          },
          child: SafeArea(
            child: FutureBuilder(
                future: parkingCarsListener,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                    parkingList = Provider.of<AdminProv>(context, listen: true)
                        .parkingList;

                    return (parkingList.isNotEmpty)
                        ? SmartRefresher(
                            onRefresh: _onRefresh,
                            controller: _refreshController,
                            enablePullDown: true,
                            header: const WaterDropMaterialHeader(
                              color: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                            child:


                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        height: 60.h,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                410.w,
                                        child: TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              searchText = value;
                                            });
                                            print('filter');
                                            filterServices(value);
                                            print('value is $value');
                                          },
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.green,
                                          style: const TextStyle(
                                              color: Colors.green),
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              hintText: '      رقم الفاتورة',
                                              focusColor: Colors.green,
                                              hoverColor: Colors.green,
                                              fillColor: Colors.green,
                                              icon: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20.w),
                                                child: const Icon(
                                                  Icons.search,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              hintStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Almarai')),
                                        ),
                                      ),
                                    ),   SizedBox(width: 12.w,),
                                    OutlinedButton(
                                      onPressed: () {},
                                      child: SizedBox(
                                        height: 40.h,
                                        width: 120.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(
                                              Icons.directions_car_rounded,
                                              color: Colors.blue,
                                              size: 36,
                                            ),
                                            Text(parkingList.length.toString(),
                                                style: TextStyle(
                                                    fontSize:
                                                        setResponsiveFontSize(
                                                            28),
                                                    fontWeight:
                                                        FontManager.bold,
                                                    color: Colors.red,
                                                    fontFamily:
                                                        GoogleFonts.getFont(
                                                                'Redressed')
                                                            .fontFamily))
                                          ],
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                              BorderSide(
                                                  color: Colors.blue,
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
                                    SizedBox(width: 10.w,),
                                    OutlinedButton(
                                      onPressed: () {},
                                      child: SizedBox(
                                        height: 40.h,
                                        width: 120.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(
                                              Icons.monetization_on,
                                              color: Colors.green,
                                              size: 36,
                                            ),
                                            Text(
                                                adminProv.totalBalance
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize:
                                                        setResponsiveFontSize(
                                                            28),
                                                    fontWeight:
                                                        FontManager.bold,
                                                    color: Colors.red,
                                                    fontFamily:
                                                        GoogleFonts.getFont(
                                                                'Cairo')
                                                            .fontFamily))
                                          ],
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                              BorderSide(
                                                  color: Colors.green,
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
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: tmpList == null
                                        ? parkingList.length
                                        : tmpList.length,
                                    scrollDirection: Axis.vertical,
                                    //  shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: SizedBox(
                                        //  height: 380.h,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            elevation: 4,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 15),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'G-${tmpList == null ? parkingList[index].logId : tmpList[index].logId}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            setResponsiveFontSize(
                                                                26),
                                                        fontWeight:
                                                            FontManager.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 12.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      !(tmpList == null
                                                              ? parkingList[
                                                                      index]
                                                                  .carImage
                                                                  .contains(
                                                                      'null')
                                                              : tmpList[index]
                                                                  .carImage
                                                                  .contains(
                                                                      'null'))
                                                          ? InkWell(
                                                              child:
                                                                  Image.network(
                                                                tmpList == null
                                                                    ? parkingList[
                                                                            index]
                                                                        .carImage
                                                                    : tmpList[
                                                                            index]
                                                                        .carImage,
                                                                width: 300.w,
                                                                height: 170.h,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(40)),
                                                                        elevation:
                                                                            16,
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              400.h,
                                                                          width:
                                                                              600.w,
                                                                          child:
                                                                              Image.network(
                                                                            tmpList == null
                                                                                ? parkingList[index].carImage
                                                                                : tmpList[index].carImage,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                            )
                                                          : Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          50.w),
                                                              child: Container(
                                                                  height: 170.h,
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/images/vip.png')),
                                                            ),
                                                      !(tmpList == null
                                                              ? parkingList[
                                                                      index]
                                                                  .carImage
                                                                  .contains(
                                                                      'null')
                                                              : tmpList[index]
                                                                  .carImage
                                                                  .contains(
                                                                      'null'))
                                                          ? InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(40)),
                                                                        elevation:
                                                                            16,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              400.h,
                                                                          width:
                                                                              600.w,
                                                                          child:
                                                                              Image.network(
                                                                            tmpList == null
                                                                                ? parkingList[index].identityImage
                                                                                : tmpList[index].identityImage,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              child:
                                                                  Image.network(
                                                                tmpList == null
                                                                    ? parkingList[
                                                                            index]
                                                                        .identityImage
                                                                    : tmpList[
                                                                            index]
                                                                        .identityImage,
                                                                width: 300.w,
                                                                height: 170.h,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 25.h,
                                                  ),
                                                  ExpandablePanel(
                                                    expanded: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [

                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  adminProv.parkingList[index].parkType,
                                                                  style: TextStyle(
                                                                      fontSize: setResponsiveFontSize(22),
                                                                      color: Colors.green,
                                                                      fontWeight: FontManager.bold),
                                                                ),
                                                              ),
                                                              Text(
                                                                'نوع الزائر',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
                                                                  fontSize: setResponsiveFontSize(20),
                                                                ),
                                                                softWrap: true,
                                                                textAlign: TextAlign.end,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 12.h,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                adminProv.parkingList[index].inDateTime.length > 2
                                                                    ? adminProv.parkingList[index].inDateTime
                                                                    : 'لم يتم الدخول بعد',
                                                                style: TextStyle(
                                                                    fontSize: setResponsiveFontSize(22),
                                                                    color: Colors.green,
                                                                    fontWeight: FontManager.bold),
                                                              ),
                                                              Text('تاريخ الدخول',
                                                                  softWrap: true,
                                                                  textAlign: TextAlign.end,
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.black,
                                                                    fontSize: setResponsiveFontSize(20),
                                                                  ))
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 12.h,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                adminProv.parkingList[index].outDateTime.length>2
                                                                    ? adminProv.parkingList[index].outDateTime
                                                                    : 'لم يتم الخروج بعد',
                                                                style: TextStyle(
                                                                    fontSize: setResponsiveFontSize(22),
                                                                    color: Colors.green,
                                                                    fontWeight: FontManager.bold),
                                                              ),
                                                              Text(
                                                                'تاريخ الخروج',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
                                                                  fontSize: setResponsiveFontSize(20),
                                                                ),
                                                                softWrap: true,
                                                                textAlign: TextAlign.end,
                                                              ),
                                                            ],
                                                          )   ,SizedBox(
                                                            height: 12.h,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                adminProv.parkingList[index].totalPrice.toString() ,
                                                                style: TextStyle(
                                                                    fontSize: setResponsiveFontSize(22),
                                                                    color: Colors.green,
                                                                    fontWeight: FontManager.bold),
                                                              ),
                                                              Text(
                                                                'إجمالى الفاتورة',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
                                                                  fontSize: setResponsiveFontSize(20),
                                                                ),
                                                                softWrap: true,
                                                                textAlign: TextAlign.end,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    collapsed: null,
                                                    header: SizedBox(
                                                      height: 1.h,
                                                    ),
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ZoomIn(
                            child: Center(
                                child: Text(
                              'لا توجد فواتير معلقة',
                              style: TextStyle(
                                  fontSize: setResponsiveFontSize(46)),
                            )),
                          );
                  }
                  return Container();
                }),
          ),
        ),
      ),
    );
  }
}
