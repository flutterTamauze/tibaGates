import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Data/Models/admin/prices.dart';
import 'package:clean_app/Presentation/admin/admin_bottomNav.dart';
import 'package:clean_app/Presentation/login_screen/Widgets/memberDisplay.dart';
import 'package:clean_app/Utilities/Colors/colorManager.dart';
import 'package:clean_app/Utilities/Constants/constants.dart';
import 'package:clean_app/Utilities/Fonts/fontsManager.dart';
import 'package:clean_app/Utilities/Shared/dialogs/loading_dialog.dart';
import 'package:clean_app/Utilities/Shared/sharedWidgets.dart';
import 'package:clean_app/Utilities/Shared/textField.dart';
import 'package:clean_app/Utilities/connectivityStatus.dart';
import 'package:clean_app/ViewModel/admin/reports/admin_reportsProv.dart';
import 'package:clean_app/ViewModel/guard/authProv.dart';
import 'package:clean_app/ViewModel/admin/more/pricesProv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class PricesScreen extends StatefulWidget {
  const PricesScreen({Key key}) : super(key: key);

  @override
  _PricesScreenState createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceNholidayController =
      TextEditingController();
  List<PricesModel> pricesList = [];
  Future pricesListener;

  @override
  void initState() {
    super.initState();
    pricesListener =
        Provider.of<PricesProv>(context, listen: false).getPrices();
  }

  @override
  Widget bodyData() => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Park Type',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                ),
                DataColumn(
                  label: Text(
                    'Prices',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                ),
                DataColumn(
                  label: Text(
                    'Price in holidays',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                ),
                DataColumn(
                  label: Text(
                    '',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(24),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                ),
              ],
              rows: pricesList
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(
                          Text(e.type,
                            style: TextStyle(
                                fontSize: setResponsiveFontSize(20),
                                fontWeight: FontManager.bold),),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(e.price.toString(),
                            style: TextStyle(
                                fontSize: setResponsiveFontSize(24),
                                fontWeight: FontManager.bold,color: Colors.blue),),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(e.priceInHoliday.toString(),
                            style: TextStyle(
                                fontSize: setResponsiveFontSize(24),
                                fontWeight: FontManager.bold,color: Colors.blue),),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return newPriceDialog( e:         e,context:  context,hintType: 'النوع الحالى ${e.type.toString()}',hintPrice: 'السعر الحالى ${e.price.toString()}',hintPriceNHoliday: 'السعر فى الأجازات ${e.priceInHoliday.toString()}',
                                         saveCallback:    (){
                                              if (!_formKey.currentState.validate()) {
                                                return;
                                              } else {
                                                debugPrint(
                                                    'new type is ${_typeController.text}  new price is ${_priceController.text}   new price holiday is ${_priceNholidayController.text}');
                                                showLoaderDialog(context, 'جارى التعديل');
                                                Provider.of<PricesProv>(context, listen: false)
                                                    .updatePrices(
                                                    e.id,
                                                    _typeController.text,
                                                    double.parse(_priceController.text),
                                                    double.parse(_priceNholidayController.text))
                                                    .then((value) {
                                                  if (value == 'Success') {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    e.type = _typeController.text;
                                                    e.price = double.parse(_priceController.text);
                                                    e.priceInHoliday =
                                                        double.parse(_priceNholidayController.text);
                                                  }
                                                });
                                              }
                                            }
                                        );
                                      });
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          elevation: 16,
                                          child: SizedBox(
                                              height: 320.h,
                                              width: 600.w,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 25.h,
                                                  ),
                                                  Directionality(
                                                    textDirection:
                                                        ui.TextDirection.rtl,
                                                    child: AutoSizeText(
                                                      'هل انت متأكد من حذف ${e.type} ؟ ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              setResponsiveFontSize(
                                                                  28)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 60.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        RoundedButton(
                                                          height: 55,
                                                          width: 220,
                                                          ontap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          title: 'لا',
                                                          buttonColor:
                                                              Colors.grey,
                                                          titleColor: ColorManager
                                                              .backGroundColor,
                                                        ),
                                                        RoundedButton(
                                                          height: 55,
                                                          width: 220,
                                                          ontap: () {
                                                            showLoaderDialog(
                                                                context,
                                                                'جارى الحذف');

                                                            Provider.of<
                                                                        PricesProv>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deletePrice(
                                                                    e.id,
                                                                    Provider.of<AuthProv>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .userId)
                                                                .then((value) {
                                                              if (value ==
                                                                  'success') {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            });
                                                          },
                                                          title: 'حذف',
                                                          buttonColor:
                                                              Colors.redAccent,
                                                          titleColor: ColorManager
                                                              .backGroundColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                ],
                                              )),
                                        );
                                      });
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
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
      );

  Dialog newPriceDialog({PricesModel e, BuildContext context,String hintType,String hintPrice,String hintPriceNHoliday,VoidCallback saveCallback}) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 16,
      child: SizedBox(
          height: 580.h,
          width: 600.w,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25.h,
                ),
                AutoSizeText(
                  'ادخل القيم الجديدة',
                  style: TextStyle(
                      color: ColorManager.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: setResponsiveFontSize(28)),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
                  child: TextEditField(
                    controller: _typeController,
                    inputType: TextInputType.text,
                    hintText: hintType,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
                  child: TextEditField(
                    controller: _priceController,
                    inputType: TextInputType.number,
                    hintText: hintPrice,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
                  child: TextEditField(
                    controller: _priceNholidayController,
                    inputType: TextInputType.number,
                    hintText:hintPriceNHoliday
                        ,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedButton(
                        height: 55,
                        width: 220,
                        ontap: () {
                          _typeController.text = '';
                          _priceController.text = '';
                          _priceNholidayController.text = '';
                          Navigator.pop(context);
                        },
                        title: 'إلغاء',
                        buttonColor: Colors.grey,
                        titleColor: ColorManager.backGroundColor,
                      ),
                      RoundedButton(
                        height: 55,
                        width: 220,
                        ontap: saveCallback,
                        title: 'حفظ',
                        buttonColor: ColorManager.primary,
                        titleColor: ColorManager.backGroundColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: ZoomIn(
          child: FloatingActionButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return newPriceDialog(context:  context,hintType: 'أضف النوع', hintPrice: 'أضف السعر',hintPriceNHoliday: 'أضف السعر فالأجازات',
                       saveCallback:      (){
                          if (!_formKey.currentState.validate()) {
                            return;
                          } else {
                            debugPrint(
                                'new type is ${_typeController.text}  new price is ${_priceController.text}   new price holiday is ${_priceNholidayController.text}');
                            showLoaderDialog(context, 'جارى الحفظ');
                            Provider.of<PricesProv>(context, listen: false)
                                .addPrices(

                                _typeController.text,
                                double.parse(_priceController.text),
                                double.parse(_priceNholidayController.text))
                                .then((value) {
                              if (value == 'Success') {
                                _typeController.text='';
                                _priceController.text='';
                                _priceNholidayController.text='';
                                Fluttertoast.showToast(
                                    msg:
                                    'تم الحفظ بنجاح',
                                    backgroundColor:
                                    Colors.green,
                                    toastLength: Toast
                                        .LENGTH_LONG);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Provider.of<PricesProv>(context,listen: false).getPrices();
                              }
                            });
                          }
                        }
                    );
                  });
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: Colors.green,
              size: 36,
            ),
          ),
        ),
        body:connectionStatus == ConnectivityStatus.Offline
            ? Center(
            child: SizedBox(
              height: 400.h,
              width: 400.w,
              child: Lottie.asset('assets/lotties/noInternet.json'),
            ))
            :  WillPopScope(
            onWillPop: () {
              navigateTo(
                  context,
                  BottomNav(
                    comingIndex: 0,
                  ));
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
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
                              image: AssetImage('assets/images/tipasplash.png')),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  AutoSizeText(
                    'قائمة الأسعار الحالية',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: setResponsiveFontSize(33)),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  FutureBuilder(
                      future: pricesListener,
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
                          pricesList =
                              Provider.of<PricesProv>(context, listen: true)
                                  .pricesObjects;
                          return Center(child: bodyData());
                        }
                        return Container();
                      }),
                ],
              ),
            )),
        backgroundColor: Colors.green,
      ),
    );
  }
}
