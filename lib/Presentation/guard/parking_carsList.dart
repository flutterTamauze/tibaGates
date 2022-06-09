import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../Utilities/connectivityStatus.dart';
import 'package:lottie/lottie.dart';

import '../../Data/Models/guard/parked_model.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import '../../Utilities/responsive.dart';
import '../../ViewModel/guard/authProv.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'guardPrint_Screen.dart';
import 'entryScreen.dart';

class NotPrintedListScreen extends StatefulWidget {
  const NotPrintedListScreen({Key key}) : super(key: key);

  @override
  _NotPrintedListScreenState createState() => _NotPrintedListScreenState();
}

class _NotPrintedListScreenState extends State<NotPrintedListScreen> {
  Future parkedListener;
  String searchText;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ParkingCarsModel> parkedList;
  int reasonTypeId;
  var selectedReason;

  // var tmpList;
  var reportsProv;
  TextEditingController searchController = TextEditingController();
  String selectedVisitorType = 'الكل';
  int pageNumber = 1;

  @override
  void initState() {
    parkedListener = Provider.of<VisitorProv>(context, listen: false)
        .getParkingList(selectedVisitorType, pageNumber);
    super.initState();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      setState(() {
        parkedListener = Provider.of<VisitorProv>(context, listen: false)
            .getParkingList(selectedVisitorType, pageNumber);
      });
    });
    _refreshController.refreshCompleted();
  }

/*  void filterServices(value) {
    print('inside filter');

    setState(() {
      tmpList = parkedList
          .where((item) => item.logId.toString().contains(value.toString()))
          .toList();

      print('filtered list now isss ${tmpList.length}');
    });
  }*/

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const EntryScreen()));
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
            )),
      ),
      body: connectionStatus == ConnectivityStatus.Offline
          ? Center(
              child: SizedBox(
              height: 400.h,
              width: 400.w,
              child: Lottie.asset('assets/lotties/noInternet.json'),
            ))
          : WillPopScope(
              onWillPop: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EntryScreen()));
              },
              child: SafeArea(
                child: FutureBuilder(
                    future: parkedListener,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
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
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        parkedList =
                            Provider.of<VisitorProv>(context, listen: true)
                                .parkingList;

                        return SmartRefresher(
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
                                          (isTab(context) ? 400.w : 410.w),
                                      child: TextField(
                                        controller: searchController,
                                        onChanged: (value) {
                                          setState(() {
                                            searchText = value;
                                          });
                                          debugPrint('filter');
                                          Provider.of<VisitorProv>(context,
                                                  listen: false)
                                              .searchParking(
                                                  value,
                                                  selectedVisitorType,
                                                  pageNumber);
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
                                  ),
                                  OutlinedButton(
                                    onPressed: () {},
                                    child: SizedBox(
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
                                          AutoSizeText(
                                              Provider.of<VisitorProv>(context,
                                                      listen: true)
                                                  .totalParkedCars
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(28),
                                                fontWeight: FontManager.bold,
                                                color: Colors.red,
                                              ))
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
                                                    Radius.circular(10))))),
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.green, width: 1.w)),
                                    width: 200.w,
                                    height: 78.h,
                                    child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        elevation: 2,
                                        isExpanded: true,
                                        items: Provider.of<AuthProv>(context,
                                                listen: false)
                                            .parkTypes
                                            .map((String x) {
                                          return DropdownMenuItem<String>(
                                              value: x,
                                              child: Center(
                                                child: Text(
                                                  x,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              25),
                                                      color: Colors.green,
                                                      fontFamily: 'Almarai'),
                                                ),
                                              ));
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedVisitorType = value;

                                            print(
                                                'visitor type is $selectedVisitorType');
                                            pageNumber = 1;
                                            searchController.text = '';
                                          });
                                          Provider.of<VisitorProv>(context,
                                                  listen: false)
                                              .getParkingList(
                                                  selectedVisitorType,
                                                  pageNumber);
                                        },
                                        value: selectedVisitorType ??
                                            Provider.of<AuthProv>(context,
                                                    listen: false)
                                                .parkTypes[0],
                                      ),
                                    )),
                                  )
                                ],
                              ),
                              (parkedList.isNotEmpty)
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.32,
                                      child: ListView.builder(
                                        itemCount: parkedList.length,
                                        keyboardDismissBehavior:
                                            ScrollViewKeyboardDismissBehavior
                                                .onDrag,
                                        scrollDirection: Axis.vertical,
                                        //  shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: SizedBox(
                                              height: 290.h,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                ),
                                                elevation: 4,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 15),
                                                  child: Column(
                                                    children: [
                                                      AutoSizeText(
                                                        'G-${parkedList[index].logId}',
                                                        style: TextStyle(
                                                            fontSize:
                                                                setResponsiveFontSize(
                                                                    26),
                                                            fontWeight:
                                                                FontManager
                                                                    .bold),
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
                                                                      .reasons
                                                                      .isEmpty) {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        'عذراً , لا توجد حالياً أسباب للطباعة',
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG);
                                                              } else {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return StatefulBuilder(builder:
                                                                          (context,
                                                                              setState) {
                                                                        return Dialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                          elevation:
                                                                              16,
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                300.h,
                                                                            width:
                                                                                600.w,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(top: 40.h),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.green, width: 1.w)),
                                                                                          width: 270.w,
                                                                                          height: 80.h,
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
                                                                                        AutoSizeText(
                                                                                          ' سبب إعادة الطباعة',
                                                                                          style: TextStyle(fontSize: setResponsiveFontSize(26)),
                                                                                        ),
                                                                                      ],
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 70.h,
                                                                                  ),
                                                                                  RoundedButton(
                                                                                    height: 65.h,
                                                                                    width: 300.w,
                                                                                    title: 'تأكيد',
                                                                                    titleColor: Colors.white,
                                                                                    buttonColor: Colors.green,
                                                                                    ontap: () {
                                                                                      Provider.of<VisitorProv>(context, listen: false).getLogById(parkedList[index].logId).then((value) {
                                                                                        if (value == 'Success') {
                                                                                          reasonTypeId ??= Provider.of<VisitorProv>(context, listen: false).reasonsObjects[0].id;

                                                                                          print('reasonTypeId $reasonTypeId');

                                                                                          Provider.of<VisitorProv>(context, listen: false).logId = parkedList[index].logId;

                                                                                          print('price = ${Provider.of<VisitorProv>(context, listen: false).reasonsObjects[Provider.of<VisitorProv>(context, listen: false).reasons.indexOf(selectedReason ?? Provider.of<VisitorProv>(context, listen: false).reasons[0])].price}');

                                                                                          var type = parkedList[index].type;
                                                                                          print('type is $type');

                                                                                          Navigator.pushReplacement(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                  builder: (context) => PrintScreen2(
                                                                                                        from: 'resend',
                                                                                                        resendType: type,
                                                                                                        reasonPrice: Provider.of<VisitorProv>(context, listen: false).reasonsObjects[Provider.of<VisitorProv>(context, listen: false).reasons.indexOf(selectedReason ?? Provider.of<VisitorProv>(context, listen: false).reasons[0])].price,
                                                                                                        reasonId: reasonTypeId,
                                                                                                        //    logId: tmpList == null ? parkedList[index].logId : tmpList[index].logId,
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
                                                              color:
                                                                  Colors.green,
                                                              size: 36,
                                                            ),
                                                            style: ButtonStyle(
                                                                side: MaterialStateProperty.all(BorderSide(
                                                                    color: Colors
                                                                        .green,
                                                                    width:
                                                                        1.4.w)),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<Color>(Colors
                                                                        .white),
                                                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                                    vertical:
                                                                        20.h,
                                                                    horizontal:
                                                                        20.w)),
                                                                shape: MaterialStateProperty.all(
                                                                    const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))))),
                                                          ),

                                                          !(parkedList[index]
                                                                  .carImage
                                                                  .contains(
                                                                      'null'))
                                                              ? InkWell(
                                                                  child: Image
                                                                      .network(
                                                                    parkedList[
                                                                            index]
                                                                        .carImage,
                                                                    width:
                                                                        isTab(context) ?300.w:270.w,
                                                                    height:
                                                                        170.h,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                  onTap: () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Dialog(
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                            elevation:
                                                                                16,
                                                                            child:
                                                                                SizedBox(
                                                                              height: 400.h,
                                                                              width: 600.w,
                                                                              child: Image.network(
                                                                                parkedList[index].carImage,
                                                                                fit: BoxFit.fill,
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
                                                                  child: SizedBox(
                                                                      height:
                                                                          170.h,
                                                                      child: Image
                                                                          .asset(
                                                                              'assets/images/vip.png')),
                                                                ),
                                                          !(parkedList[index]
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
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                            elevation:
                                                                                16,
                                                                            child:
                                                                                SizedBox(
                                                                              height: 400.h,
                                                                              width: 600.w,
                                                                              child: Image.network(
                                                                                parkedList[index].identityImage,
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        });
                                                                  },
                                                                  child: Image
                                                                      .network(
                                                                    parkedList[
                                                                            index]
                                                                        .identityImage,
                                                                    width:
                                                                    isTab(context) ?300.w:270.w,
                                                                    height:
                                                                        170.h,
                                                                    fit: BoxFit
                                                                        .fill,
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
                                    )
                                  : ZoomIn(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 400.h,
                                          ),
                                          AutoSizeText(
                                            'لا توجد فواتير معلقة',
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(46)),
                                          ),
                                        ],
                                      ),
                                    ),
                              SizedBox(
                                height: 20.h,
                              ),
                              (searchController.text == '' &&
                                      Provider.of<VisitorProv>(context,
                                                  listen: true)
                                              .totalParkedCars !=
                                          0)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        pageNumber > 1
                                            ? InkWell(
                                                child: const Icon(
                                                    Icons.arrow_back_ios),
                                                onTap: () {
                                                  showLoaderDialog(
                                                      context, 'جارى التحميل');
                                                  Provider.of<VisitorProv>(
                                                          context,
                                                          listen: false)
                                                      .getParkingList(
                                                          selectedVisitorType,
                                                          pageNumber - 1)
                                                      .then((value) {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      pageNumber--;
                                                    });
                                                  });
                                                },
                                              )
                                            : Container(),
                                        AutoSizeText(
                                          '$pageNumber   ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize:
                                                  setResponsiveFontSize(36),
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if ((Provider.of<VisitorProv>(context,
                                                            listen: false)
                                                        .totalParkedCars /
                                                    5)
                                                .ceil() >
                                            pageNumber)
                                          InkWell(
                                              onTap: () {
                                                showLoaderDialog(
                                                    context, 'جارى التحميل');
                                                Provider.of<VisitorProv>(
                                                        context,
                                                        listen: false)
                                                    .getParkingList(
                                                        selectedVisitorType,
                                                        pageNumber + 1)
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    pageNumber++;
                                                    //      searchController.text='';
                                                  });
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.arrow_forward_ios)),
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        );
                      }
                      return Container();
                    }),
              ),
            ),
    );
  }
}
