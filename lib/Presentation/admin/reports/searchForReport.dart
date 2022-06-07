import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';

import '../../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../../ViewModel/admin/reports/admin_reportsProv.dart';
import '../../../ViewModel/guard/visitorProv.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../Utilities/Constants/constants.dart';
import '../../../Utilities/Fonts/fontsManager.dart';
import '../../../Utilities/Shared/editTextWithHeader.dart';
import '../../../Utilities/responsive.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../admin_bottomNav.dart';

class SearchForReport extends StatefulWidget {
  const SearchForReport({Key key}) : super(key: key);

  @override
  _SearchForReportState createState() => _SearchForReportState();
}

class _SearchForReportState extends State<SearchForReport> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<AReportsProv>(context, listen: false);
    var trueProv = Provider.of<AReportsProv>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () async {
                  prov.resetBill();
                  navigateTo(
                      context,
                      BottomNav(
                        comingIndex: 2,
                      ));
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 26,
                )),
            const AutoSizeText(
              'بحث عن فاتورة',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: (){
          prov.resetBill();
          navigateTo(
              context,
              BottomNav(
                comingIndex: 2,
              ));

        },
        child: SingleChildScrollView(
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          if (searchController.text.isEmpty) {
                            showToast('ادخل رقم الفاتورة أولاً');
                          } else {
                            FocusManager.instance.primaryFocus?.unfocus();
                            showLoaderDialog(context, 'جارى التحميل...');
                            prov
                                .getBillById(int.parse(searchController.text))
                                .then((value) {
                              Navigator.pop(context);
                              if (value == 'Success') {
                                prov.changeBillStatus(true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.red[400],
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.error_outline_outlined,
                                        color: Colors.white,
                                      ),
                                      AutoSizeText(
                                        'رقم الفاتورة غير صحيح !',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: setResponsiveFontSize(30)),
                                      )
                                    ],
                                  ),
                                ));
                                prov.changeBillStatus(false);
                              }
                            });
                          }
                        },
                        child: SizedBox(
                          height: 30.h,
                          width: isTab(context) ? 200.w : 180.w,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 30,
                              ),
                              const VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                                endIndent: 2,
                                indent: 4,
                              ),
                              AutoSizeText(
                                'بحث',
                                style: TextStyle(
                                    fontSize: setResponsiveFontSize(24),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                BorderSide(color: Colors.green, width: 3.w)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 20.w)),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))))),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomInputFieldFb1(
                          hintText: 'ادخل رقم الفاتورة',
                          inputController: searchController,
                          labelText: '',
                        ),
                      ),
                    ],
                  ),
                ),
                trueProv.isBillFound
                    ? ZoomIn(
                      child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: SizedBox(
                            height: 500.h,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 15),
                                child: Column(
                                  children: [
                                    Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'اسم المستخدم : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: setResponsiveFontSize(30),
                                                  fontWeight: FontManager.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: trueProv.billModel.userName??'   -   ',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize:
                                                          setResponsiveFontSize(32),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'النوع : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: setResponsiveFontSize(30),
                                                  fontWeight: FontManager.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: trueProv.billModel.type,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize:
                                                          setResponsiveFontSize(32),
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'تاريخ الدخول : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: setResponsiveFontSize(30),
                                                  fontWeight: FontManager.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: trueProv.billModel.inDate,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize:
                                                          setResponsiveFontSize(28),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'تاريخ الخروج : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: setResponsiveFontSize(30),
                                                  fontWeight: FontManager.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: trueProv.billModel.outDate,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize:
                                                          setResponsiveFontSize(28),
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'ساعة الدخول : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: setResponsiveFontSize(30),
                                                  fontWeight: FontManager.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: trueProv.billModel.inDateTime,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize:
                                                          setResponsiveFontSize(30),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'ساعة الخروج : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: setResponsiveFontSize(30),
                                                  fontWeight: FontManager.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: trueProv.billModel.outDateTime,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize:
                                                          setResponsiveFontSize(32),
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'القيمة : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: setResponsiveFontSize(30),
                                                  fontWeight: FontManager.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: trueProv.billModel.total.toString()??'-',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize:
                                                          setResponsiveFontSize(32),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          child: Image.network(
                                            prov.billModel.image1,
                                            width: isTab(context)
                                                ? 300.w
                                                : (MediaQuery.of(context).size.width -
                                                        65) /
                                                    2,
                                            height: 230.h,
                                            fit: BoxFit.fill,
                                          ),
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                40)),
                                                    elevation: 16,
                                                    child: SizedBox(
                                                      height: 400.h,
                                                      width: 600.w,
                                                      child: Image.network(
                                                        prov.billModel.image1,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                        ),
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                40)),
                                                    elevation: 16,
                                                    child: SizedBox(
                                                      height: 400.h,
                                                      width: 600.w,
                                                      child: Image.asset(
                                                        prov.billModel.image2,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Image.network(
                                            prov.billModel.image2,
                                            width: isTab(context)
                                                ? 300.w
                                                : (MediaQuery.of(context).size.width -
                                                        65) /
                                                    2,
                                            height: 230.h,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    )
                    : Column(
                      children: [
                        SizedBox(height: 140.h,),
                        Lottie.asset(
                          'assets/lotties/search2.json',
                        ),
                      ],
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
