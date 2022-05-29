import 'package:auto_size_text/auto_size_text.dart';
import '../../../Utilities/responsive.dart';

import '../../../Utilities/Colors/colorManager.dart';
import '../../../Utilities/Shared/sharedWidgets.dart';
import '../../../ViewModel/guard/authProv.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/connectivityStatus.dart';
import '../../../ViewModel/admin/a_homeBioProv.dart';
import '../../../ViewModel/admin/reports/admin_reportsProv.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../admin_bottomNav.dart';
import '../../../Utilities/Constants/constants.dart';
import '../../../Utilities/Fonts/fontsManager.dart';
import '../../../Utilities/Shared/dialogs/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DailyReportsScreen extends StatefulWidget {
  const DailyReportsScreen({Key key}) : super(key: key);

  @override
  _DailyReportsScreenState createState() => _DailyReportsScreenState();
}

class _DailyReportsScreenState extends State<DailyReportsScreen> {
  int invitationTypeId;
  final TextEditingController startDateController = TextEditingController();
  String selectedType;
  String date;
  bool loadReport = false;
  int pageNumber = 1;
  int maxPages;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    date = formatted;
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
              dataRowHeight: 70.h,
              dividerThickness: 3.w,
              showBottomBorder: true,
              columnSpacing: isTab(context) ? 30.0 : 15,
              headingRowColor:
                  MaterialStateProperty.all<Color>(Colors.blueGrey),
              headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),

              // dataRowColor: MaterialStateProperty.all<Color>(Colors.green),
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'id',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(24),
                        // background: Paint()..color = Colors.green,
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                  tooltip: 'To display first id of the ReportRecord',
                ),
                DataColumn(
                  label: Text(
                    'النوع',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                  tooltip: '',
                ),
                DataColumn(
                  label: Text(
                    'مدنى',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                  tooltip: '',
                ),
                DataColumn(
                  label: Text(
                    'عسكرى',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                  tooltip: '',
                ),
                DataColumn(
                  label: Text(
                    'دخول',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                  tooltip: '',
                ),
                DataColumn(
                  label: Text(
                    'خروج',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                  tooltip: '',
                ),
                const DataColumn(
                  label: Text(
                    '',
                  ),
                  numeric: false,
                ),
                const DataColumn(
                  label: Text(
                    '',
                  ),
                  numeric: false,
                ),
              ],
              rows: Provider.of<AReportsProv>(context, listen: false)
                  .reportsList
                  .map(
                    (ReportRecord) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            ReportRecord.id.toString(),
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: setResponsiveFontSize(24)),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(ReportRecord.type,
                              style: TextStyle(
                                  fontSize: setResponsiveFontSize(20))),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(ReportRecord.civilCount.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: setResponsiveFontSize(26))),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(ReportRecord.militryCount.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: setResponsiveFontSize(26))),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: SizedBox(
                                width: 70.w,
                                child: Text(ReportRecord.inDateTime.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: setResponsiveFontSize(22))),
                              )),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: SizedBox(
                                width: 70.w,
                                child: Text(
                                  ReportRecord.outDateTime.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: setResponsiveFontSize(22)),
                                ),
                              )),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
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
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 25.h,
                                              ),
                                              Directionality(
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                child: Text(
                                                  'هل انت متأكد من حذف تلك الفاتورة ؟ ',
                                                  textAlign: TextAlign.center,
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
                                                padding: EdgeInsets.symmetric(
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
                                                        Navigator.pop(context);
                                                      },
                                                      title: 'لا',
                                                      buttonColor: Colors.grey,
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

                                                        Provider.of<AReportsProv>(
                                                                context,
                                                                listen: false)
                                                            .deleteBill(
                                                                ReportRecord.id,
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
                            child: Icon(
                              Icons.delete,
                              size: isTab(context) ? 30 : 20,
                              color: Colors.red,
                            ),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      elevation: 16,
                                      child: SizedBox(
                                          height: 300.h,
                                          width: isTab(context) ? 900.w : 700.w,
                                          child: ReportRecord.type
                                                  .toLowerCase()
                                                  .contains('vip')
                                              ? SizedBox(
                                                  child: Image.asset(
                                                      'assets/images/vip.png'),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      child: Image.network(
                                                        ReportRecord.image1,
                                                        width: isTab(context)
                                                            ? 340.w
                                                            : 300.w,
                                                        height: isTab(context)
                                                            ? 250.h
                                                            : 250.h,
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
                                                                  child: Image
                                                                      .network(
                                                                    ReportRecord
                                                                        .image1,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                    ),
                                                    InkWell(
                                                      child: Image.network(
                                                        ReportRecord.image2,
                                                        width: isTab(context)
                                                            ? 340.w
                                                            : 300.w,
                                                        height: isTab(context)
                                                            ? 250.h
                                                            : 250.h,
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
                                                                  child: Image
                                                                      .network(
                                                                    ReportRecord
                                                                        .image2,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                    )
                                                  ],
                                                )),
                                    );
                                  });
                            },
                            child: Icon(
                              Icons.info_outlined,
                              size: isTab(context) ? 30 : 20,
                              color: Colors.grey,
                            ),
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

  @override
  Widget build(BuildContext context) {
    var reportProv = Provider.of<AReportsProv>(context, listen: false);
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () async {
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
            const Text(
              'تقرير عن يوم',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: connectionStatus == ConnectivityStatus.Offline
          ? Center(
              child: SizedBox(
              height: 400.h,
              width: 400.w,
              child: Lottie.asset('assets/lotties/noInternet.json'),
            ))
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Stack(
                children: [
                  loadReport == true
                      ? Positioned(
                          bottom: 16.h,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: 60.h,
                            width: MediaQuery.of(context).size.width - 70.w,
                            child: ListView.builder(
                              itemCount: 1,
                              scrollDirection: Axis.horizontal,
                              //  shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: SizedBox(
                                    height: 50.h,
                                    child: Row(
                                      children: [
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'الإجمالى',
                                          value: reportProv.summaryModel.total
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'أجمالى بالغرامات',
                                          value: reportProv
                                              .summaryModel.total_Fines
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : إجمالى الغرامات',
                                          value: reportProv
                                              .summaryModel.rePrintFines
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'أجمالى مدنيين',
                                          value: reportProv
                                              .summaryModel.civilPrice
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'أجمالى ق.م',
                                          value: reportProv
                                              .summaryModel.militryPrice
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'أجمالى باركينج',
                                          value: reportProv
                                              .summaryModel.parkPrice
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'مدنيين',
                                          value: reportProv
                                              .summaryModel.civilCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'ق.م',
                                          value: reportProv
                                              .summaryModel.militryCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'سيارات الأنشطة',
                                          value: reportProv
                                              .summaryModel.activityCarCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'سيارات المدنيين',
                                          value: reportProv
                                              .summaryModel.citizenCarCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'سيارات الجيش',
                                          value: reportProv
                                              .summaryModel.militryCarCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'سيارات الأعضاء',
                                          value: reportProv
                                              .summaryModel.memberCarCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 26.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: 'عدد السيارات',
                                          value: reportProv
                                              .summaryModel.carsCount
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ))
                      : Container(),
                  loadReport == true
                      ? Positioned(
                          bottom: 70.h,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: 10.h,
                            width: MediaQuery.of(context).size.width - 70.w,
                            child: const Align(
                                child: Divider(
                              thickness: 3,
                              color: Colors.green,
                            )),
                          ))
                      : Container(),
                  loadReport == true
                      ? Positioned(
                          bottom: 120.h,
                          left: 370.w,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                pageNumber > 1
                                    ? InkWell(
                                        child: const Icon(Icons.arrow_back_ios),
                                        onTap: () {
                                          showLoaderDialog(
                                              context, 'جارى تحميل التقرير');
                                          Provider.of<AReportsProv>(context,
                                                  listen: false)
                                              .getDailyReport(date, date,
                                                  selectedType, pageNumber - 1)
                                              .then((value) {
                                            Navigator.pop(context);
                                            if (value == 'Success') {
                                              if (Provider.of<AReportsProv>(
                                                      context,
                                                      listen: false)
                                                  .reportsList
                                                  .isNotEmpty) {
                                                setState(() {
                                                  loadReport = true;
                                                  pageNumber--;
                                                });
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'لا توجد تقارير فى هذا اليوم',
                                                    backgroundColor:
                                                        Colors.green,
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                                setState(() {
                                                  loadReport = false;
                                                });
                                              }
                                            }
                                          });
                                        },
                                      )
                                    : Container(),
                                Text(
                                  '$pageNumber   ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: setResponsiveFontSize(30),
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '- ${Provider.of<AReportsProv>(context, listen: true).summaryModel.carsCount}   ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: setResponsiveFontSize(30),
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                                if ((Provider.of<AReportsProv>(context,
                                                    listen: true)
                                                .summaryModel
                                                .carsCount /
                                            10)
                                        .ceil() >
                                    pageNumber)
                                  InkWell(
                                      onTap: () {
                                        showLoaderDialog(
                                            context, 'جارى تحميل التقرير');
                                        Provider.of<AReportsProv>(context,
                                                listen: false)
                                            .getDailyReport(date, date,
                                                selectedType, pageNumber + 1)
                                            .then((value) {
                                          Navigator.pop(context);
                                          if (value == 'Success') {
                                            if (Provider.of<AReportsProv>(
                                                    context,
                                                    listen: false)
                                                .reportsList
                                                .isNotEmpty) {
                                              setState(() {
                                                loadReport = true;
                                                pageNumber++;
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'لا توجد تقارير فى هذا اليوم',
                                                  backgroundColor: Colors.green,
                                                  toastLength:
                                                      Toast.LENGTH_LONG);

                                              setState(() {
                                                loadReport = false;
                                              });
                                            }
                                          }
                                        });
                                      },
                                      child:
                                          const Icon(Icons.arrow_forward_ios)),
                              ],
                            ),
                          ))
                      : Container(),
                  Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
                                  controller: startDateController,
                                  keyboardType: TextInputType.datetime,
                                  readOnly: true,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate:
                                                DateTime.parse('2010-01-01'),
                                            lastDate:
                                                DateTime.parse('2030-12-31'))
                                        .then((value) {
                                      if (value == null) {
                                        startDateController.text = '';
                                      } else {
                                        //showLoaderDialog(context, 'Loading...');

                                        startDateController.text =
                                            DateUtil.formatDate(value)
                                                .toString();

                                        debugPrint(
                                            'Date Time Value : ${value.toString().substring(0, 10)}\n');
                                        setState(() {
                                          loadReport = false;
                                          date =
                                              value.toString().substring(0, 10);
                                        });
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                            date ?? '',
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(24)),
                                          ),
                                          const Icon(
                                            Icons.calendar_today,
                                            color: Colors.green,
                                            size: 26,
                                          ),
                                        ],
                                      ),
                                    ),
                                    hintText: '',
                                    hintStyle: TextStyle(
                                        //    color: darkBlueColor,
                                        fontFamily: 'Open Sans',
                                        fontSize: setResponsiveFontSize(16),
                                        fontWeight: FontWeight.w600),
                                    alignLabelWithHint: true,
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                  ),
                                ),
                                width: 300.w,
                              ),
                              Provider.of<AdminHomeProv>(context, listen: true)
                                      .parkTypes
                                      .isNotEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.green, width: 1.w)),
                                      width: 300.w,
                                      height: 80.h,
                                      child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton(
                                          elevation: 2,
                                          isExpanded: true,
                                          items: Provider.of<AdminHomeProv>(
                                                  context,
                                                  listen: true)
                                              .parkTypes
                                              .map((String x) {
                                            return DropdownMenuItem<String>(
                                                value: x,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    x,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize:
                                                            setResponsiveFontSize(
                                                                22),
                                                        color: Colors.black,
                                                        fontFamily: 'Almarai'),
                                                  ),
                                                ));
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              loadReport = false;
                                              selectedType = value;

                                              debugPrint(
                                                  'selected invitation type is $selectedType');
                                            });
                                          },
                                          value: selectedType ??
                                              Provider.of<AdminHomeProv>(
                                                      context,
                                                      listen: false)
                                                  .parkTypes[0],
                                        ),
                                      )),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                      loadReport == true
                          ? bodyData()
                          : Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 150.h,
                                  ),
                                  Container(
                                    child: Lottie.asset(
                                        'assets/lotties/reports.json',
                                        repeat: false),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 40.h,
                      ),
                      loadReport == false
                          ? OutlinedButton(
                              onPressed: () {
                                if (date == null) {
                                  DateTime now = DateTime.now();
                                  DateFormat formatter =
                                      DateFormat('yyyy-MM-dd');
                                  String formatted = formatter.format(now);
                                  date = formatted;
                                }
                                showLoaderDialog(context, 'جارى تحميل التقرير');

                                print(
                                    'selectedType   ${selectedType ?? Provider.of<AdminHomeProv>(context, listen: false).parkTypes[0]}    date $date');

                                Provider.of<AReportsProv>(context,
                                        listen: false)
                                    .getDailyReport(date, date, selectedType)
                                    .then((value) {
                                  if (value == 'Success') {
                                    if (Provider.of<AReportsProv>(context,
                                            listen: false)
                                        .reportsList
                                        .isNotEmpty) {
                                      setState(() {
                                        loadReport = true;
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'لا توجد تقارير فى هذا اليوم',
                                          backgroundColor: Colors.green,
                                          toastLength: Toast.LENGTH_LONG);
                                      Navigator.pop(context);
                                      setState(() {
                                        loadReport = false;
                                      });
                                    }
                                  }
                                });
                              },
                              child: SizedBox(
                                height: 45.h,
                                width: isTab(context) ? 200.w : 250.w,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.description_outlined,
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
                                      'عرض التقرير',
                                      style: TextStyle(
                                          fontSize: setResponsiveFontSize(24),
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                      color: Colors.green, width: 3.w)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 20.h, horizontal: 20.w)),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))))),
                            )
                          : Container(),
                      loadReport == true ? const Spacer() : Container(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class summaryItem extends StatelessWidget {
  String title;
  String value;

  summaryItem({Key key, @required this.reportProv, this.value, this.title})
      : super(key: key);

  final AReportsProv reportProv;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AutoSizeText(
          value,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        SizedBox(
          width: 8.w,
        ),
        AutoSizeText(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }
}
