import 'dart:io';

import 'package:animate_do/animate_do.dart';

import '../Data/Models/guard/parked_model.dart';
import '../Utilities/Constants/constants.dart';
import '../Utilities/Fonts/fontsManager.dart';
import '../Utilities/Shared/sharedWidgets.dart';
import '../ViewModel/guard/authProv.dart';
import '../ViewModel/guard/visitorProv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../print_page2.dart';
import 'entry_screen/entryScreen.dart';

class NotPrintedListScreen extends StatefulWidget {
  const NotPrintedListScreen({Key key}) : super(key: key);

  @override
  _NotPrintedListScreenState createState() => _NotPrintedListScreenState();
}

class _NotPrintedListScreenState extends State<NotPrintedListScreen> {
  Future unprintedListener;
  String searchText;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  List<ParkingCarsModel> unprintedList;
  int reasonTypeId;
  var selectedReason;
  var tmpList;
  var reportsProv;

  @override
  void initState() {
    unprintedListener =
        Provider.of<VisitorProv>(context, listen: false).getParkingList();
    super.initState();
  }
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      setState(() {
        unprintedListener =   Provider.of<VisitorProv>(context, listen: false).getParkingList();
      });
    });
    _refreshController.refreshCompleted();
  }
  void filterServices(value) {
    print('inside filter');

    setState(() {
      tmpList = unprintedList
          .where((item) => item.logId.toString().contains(value.toString()))
          .toList();

      print('filtered list now isss ${tmpList.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => EntryScreen()));
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
            )),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => EntryScreen()));
        },
        child: SafeArea(
          child: FutureBuilder(
              future: unprintedListener,
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
                  unprintedList =
                      Provider.of<VisitorProv>(context, listen: true)
                          .parkingList;

                  return (unprintedList.isNotEmpty)
                      ? SmartRefresher(
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
                                    padding: const EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      height: 60.h,
                                      width: MediaQuery.of(context).size.width -
                                          200.w,
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
                                        style:
                                            const TextStyle(color: Colors.green),
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
                                  ),
                                  OutlinedButton(
                                    onPressed: () {},
                                    child: Container(
                                      height: 40.h,
                                      width: 100.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.directions_car_rounded,
                                            color: Colors.blue,
                                            size: 36,
                                          ),
                                          Text(unprintedList.length.toString(),
                                              style: TextStyle(
                                                  fontSize:
                                                      setResponsiveFontSize(28),
                                                  fontWeight: FontManager.bold,
                                                  color: Colors.red,
                                                  fontFamily: GoogleFonts.getFont(
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
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: tmpList == null
                                      ? unprintedList.length
                                      : tmpList.length,
                                  scrollDirection: Axis.vertical,
                                //  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Container(
                                        height: 290.h,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'G-${tmpList == null ? unprintedList[index].logId : tmpList[index].logId}',
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
                                                    OutlinedButton(
                                                      onPressed: () {
                                                        if (Provider.of<VisitorProv>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .reasons ==
                                                                null ||
                                                            Provider.of<VisitorProv>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .reasons.isEmpty) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'عذراً , لا توجد حالياً أسباب للطباعة',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              toastLength: Toast
                                                                  .LENGTH_LONG);
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return StatefulBuilder(
                                                                    builder: (context,
                                                                        setState) {
                                                                  return Dialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                40)),
                                                                    elevation: 16,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          300.h,
                                                                      width:
                                                                          600.w,
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top: 40
                                                                                .h),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Padding(
                                                                              padding:
                                                                                  const EdgeInsets.symmetric(horizontal: 20),
                                                                              child:
                                                                                  Row(
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.green, width: 1.w)),
                                                                                    width: 300.w,
                                                                                    height: 70.h,
                                                                                    child: DropdownButtonHideUnderline(
                                                                                        child: ButtonTheme(
                                                                                      alignedDropdown: true,
                                                                                      child: DropdownButton(
                                                                                        elevation: 2,
                                                                                        isExpanded: true,
                                                                                        items: Provider.of<VisitorProv>(context, listen: false).reasons.map((String x) {
                                                                                      return DropdownMenuItem<String>(
                                                                                          value: x,
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              x,
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(fontSize: setResponsiveFontSize(22), color: Colors.green, fontFamily: 'Almarai'),
                                                                                            ),
                                                                                          ));
                                                                                        }).toList(),
                                                                                        onChanged: (value) {
                                                                                      setState(() {
                                                                                        reasonTypeId = Provider.of<VisitorProv>(context, listen: false).reasonsObjects[Provider.of<VisitorProv>(context, listen: false).reasons.indexOf(value)].id;
                                                                                        selectedReason = value;
                                                                                        print(value);
                                                                                      });
                                                                                        },
                                                                                        value: selectedReason ?? Provider.of<VisitorProv>(context, listen: false).reasons[0],
                                                                                      ),
                                                                                    )),
                                                                                  ),
                                                                                  Text(
                                                                                    ' سبب إعادة الطباعة',
                                                                                    style: TextStyle(fontSize: setResponsiveFontSize(26)),
                                                                                  ),
                                                                                ],
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height:
                                                                                  70.h,
                                                                            ),
                                                                            RoundedButton(
                                                                              height:
                                                                                  65.h,
                                                                              width:
                                                                                  270.w,
                                                                              title:
                                                                                  'تأكيد',
                                                                              titleColor:
                                                                                  Colors.white,
                                                                              buttonColor:
                                                                                  Colors.green,
                                                                              ontap:
                                                                                  () {

                                                                                Provider.of<VisitorProv>(context, listen: false).getLogById(unprintedList[index].logId).then((value) {
                                                                                  if (value == 'Success') {

                                                                                    reasonTypeId ??= Provider.of<VisitorProv>(context, listen: false).reasonsObjects[0].id;

                                                                                    print('reasonTypeId $reasonTypeId');

                                                                                    Provider.of<VisitorProv>(context, listen: false).logId = tmpList == null ? unprintedList[index].logId : tmpList[index].logId;

                                                                                   print('price = ${Provider.of<VisitorProv>(context, listen: false).reasonsObjects[Provider.of<VisitorProv>(context, listen: false)

                                                                                       .reasons.indexOf(selectedReason ?? Provider.of<VisitorProv>(context, listen: false).reasons[0])].price}');


                                                                                 var type=   tmpList == null ? unprintedList[index].type : tmpList[index].type;
                                                                                 print('type is $type');





                                                                                    Navigator.pushReplacement(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => PrintScreen2(
                                                                                                  from:'resend',
                                                                                                  resendType:type ,
                                                                                                  reasonPrice: Provider.of<VisitorProv>(context, listen: false).reasonsObjects[Provider.of<VisitorProv>(context, listen: false)
                                                                                                      .reasons.indexOf(selectedReason ?? Provider.of<VisitorProv>(context, listen: false).reasons[0])].price,
                                                                                                  reasonId: reasonTypeId,
                                                                                                  //    logId: tmpList == null ? unprintedList[index].logId : tmpList[index].logId,
                                                                                                )));
                                                                                  }
                                                                                });

                                                                              },
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                              });
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.print,
                                                        color: Colors.green,
                                                        size: 36,
                                                      ),
                                                      style: ButtonStyle(
                                                          side: MaterialStateProperty.all(BorderSide(
                                                              color: Colors.green,
                                                              width: 1.4.w)),
                                                          backgroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Colors.white),
                                                          padding: MaterialStateProperty.all(
                                                              EdgeInsets.symmetric(
                                                                  vertical: 20.h,
                                                                  horizontal:
                                                                      20.w)),
                                                          shape: MaterialStateProperty.all(
                                                              const RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(20))))),
                                                    ),
                                                    !(tmpList == null
                                                            ? unprintedList[index]
                                                                .carImage
                                                                .contains('null')
                                                            : tmpList[index]
                                                                .carImage
                                                                .contains('null'))
                                                        ? InkWell(
                                                            child: Image.network(
                                                              tmpList == null
                                                                  ? unprintedList[
                                                                          index]
                                                                      .carImage
                                                                  : tmpList[index]
                                                                      .carImage,
                                                              width: 300.w,
                                                              height: 170.h,
                                                              fit: BoxFit.fill,
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
                                                                        child: Image
                                                                            .network(
                                                                          tmpList ==
                                                                                  null
                                                                              ? unprintedList[index].carImage
                                                                              : tmpList[index].carImage,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            },
                                                          )
                                                        : Padding(
                                                          padding:  EdgeInsets.only(right: 50.w),
                                                          child: Container(
                                                          height: 170.h,
                                                          child: Image.asset('assets/images/vip.png')),
                                                        ),


                                                    !(tmpList == null
                                                            ? unprintedList[index]
                                                                .carImage
                                                                .contains('null')
                                                            : tmpList[index]
                                                                .carImage
                                                                .contains('null'))
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
                                                                        child: Image
                                                                            .network(
                                                                          tmpList ==
                                                                                  null
                                                                              ? unprintedList[index].identityImage
                                                                              : tmpList[index].identityImage,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            },
                                                            child: Image.network(
                                                              tmpList == null
                                                                  ? unprintedList[
                                                                          index]
                                                                      .identityImage
                                                                  : tmpList[index]
                                                                      .identityImage,
                                                              width: 300.w,
                                                              height: 170.h,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 25.h,
                                                ),
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
                            style:
                                TextStyle(fontSize: setResponsiveFontSize(46)),
                          )),
                        );
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
