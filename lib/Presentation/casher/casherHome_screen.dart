import 'dart:io';
import 'package:Tiba_Gates/Utilities/Shared/noInternet.dart';
import 'package:Tiba_Gates/ViewModel/casher/servicesProv.dart';

import '../../main.dart';
import 'casherEntry_screen.dart';
import 'casherPrint_screen.dart';
import '../../Utilities/Shared/tiba_logo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../Utilities/responsive.dart';
import '../../ViewModel/guard/authProv.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import '../../Utilities/connectivityStatus.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class CasherHomeScreen extends StatefulWidget {
  const CasherHomeScreen({Key key}) : super(key: key);

  @override
  _CasherHomeScreenState createState() => _CasherHomeScreenState();
}

class _CasherHomeScreenState extends State<CasherHomeScreen>
    with WidgetsBindingObserver {
  int _count = 1;
  int serviceTypeId;
  double servicePrice;
  String selectedServiceType;
  Future servicesListener;

  @override
  void initState() {
    super.initState();
    servicesListener =
        Provider.of<ServicesProv>(context, listen: false).getServices(prefs.getInt('gateId'));
    Provider.of<ServicesProv>(context, listen: false).serviceObjects=[];
    Provider.of<ServicesProv>(context, listen: false).serviceTypes=[];
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);
    var serviceProv = Provider.of<ServicesProv>(context, listen: true);
    var defserviceProv = Provider.of<ServicesProv>(context, listen: false);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Provider.of<ServicesProv>(context, listen: false).resetPrice();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const CasherEntryScreen()));
      },
      child: Scaffold(
        body: connectionStatus == ConnectivityStatus.Offline
            ? NoInternet()
            : SafeArea(
                child: SingleChildScrollView(
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
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          TibaLogo(
                            height: height,
                            width: width,
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          SizedBox(
                            width: width,
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 60.w, vertical: 20.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FutureBuilder(
                                              future: servicesListener,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child: Platform.isIOS
                                                        ? const CupertinoActivityIndicator()
                                                        : const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                  );
                                                } else if (snapshot
                                                        .connectionState ==
                                                    ConnectionState.done) {

                                                  serviceTypeId ??=
                                                      defserviceProv
                                                          .serviceObjects[0].id;

                                                  servicePrice ??=
                                                      defserviceProv
                                                          .serviceObjects[0].servicePrice;

                                                  debugPrint(
                                                      'type id $serviceTypeId');

                                                  debugPrint(
                                                      'price $servicePrice');

                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors.green,
                                                            width: 1.w)),
                                                    width: 250.w,
                                                    height: 70.h,
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                            child: ButtonTheme(
                                                      alignedDropdown: true,
                                                      child: DropdownButton(
                                                        elevation: 2,
                                                        isExpanded: true,
                                                        items: defserviceProv
                                                            .serviceTypes
                                                            .map((String x) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              value: x,
                                                              child: Center(
                                                                child: Text(
                                                                  x,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          setResponsiveFontSize(
                                                                              25),
                                                                      color: Colors
                                                                          .green,
                                                                      fontFamily:
                                                                          'Almarai'),
                                                                ),
                                                              ));
                                                        }).toList(),
                                                        onChanged: (value) {

                                                          setState(() {
                                                            serviceTypeId = defserviceProv
                                                                .serviceObjects[
                                                                    defserviceProv
                                                                        .serviceTypes
                                                                        .indexOf(
                                                                            value)].id;

                                                            servicePrice = defserviceProv
                                                                .serviceObjects[
                                                                    defserviceProv
                                                                        .serviceTypes
                                                                        .indexOf(
                                                                            value)].servicePrice;


                                                            serviceProv.calcPrice(_count,servicePrice);
                                                            debugPrint(
                                                                'selected service type is $selectedServiceType');
                                                            debugPrint(
                                                                'selected service type id is $serviceTypeId');
                                                          });
                                                        },
                                                        value: selectedServiceType ??
                                                            defserviceProv
                                                                .serviceTypes[0],
                                                      ),
                                                    )),
                                                  );
                                                }
                                                return Container();
                                              }),
                                          AutoSizeText(
                                            ' : نوع الخدمة',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(28),
                                                fontWeight: FontManager.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 60.w,
                                      ),
                                      child: Divider(
                                        thickness: 1,
                                        height: 2.h,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              isTab(context) ? 60.w : 40.w,
                                          vertical: 20.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Consumer<ServicesProv>(builder:
                                              (context, message, child) {
                                            return SizedBox(
                                              /*           height: (height * 0.15),
                                              width: (width * 0.32),*/
                                              child: AutoSizeText(
                                                message.servicePrice.toString() +
                                                    '  LE',
                                                style: TextStyle(
                                                    fontSize:
                                                        setResponsiveFontSize(
                                                            26),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                            );
                                          }),
                                          AutoSizeText(
                                            ' : السعر',
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(28),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          NumberPicker(
                                            value: _count,
                                            minValue: 1,
                                            selectedTextStyle: TextStyle(
                                                color: Colors.green,
                                                fontSize:
                                                    setResponsiveFontSize(30),
                                                fontWeight: FontWeight.bold),
                                            maxValue: 30,
                                            onChanged: (value) => setState(() {
                                              _count = value;
                                              serviceProv.calcPrice(_count,servicePrice);
                                            }),
                                          ),
                                          AutoSizeText(
                                            ' : العدد',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(26),
                                                fontWeight: FontManager.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 60.w),
                                      child: Divider(
                                        thickness: 1,
                                        height: 2.h,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    RoundedButton(
                                      width: 220,
                                      height: 60,
                                      ontap: () async {
                                        // showLoaderDialog(context, 'Loading...');

                                        navigateReplacementTo(
                                            context,  CasherPrintScreen(typeId: serviceTypeId,count: _count,totalPrice: serviceProv.servicePrice,serviceName: selectedServiceType ??
                                            defserviceProv
                                                .serviceTypes[0],));
                                      },
                                      title: 'إستمرار',
                                      buttonColor: ColorManager.primary,
                                      titleColor: ColorManager.backGroundColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
      ),
    );
  }
}
