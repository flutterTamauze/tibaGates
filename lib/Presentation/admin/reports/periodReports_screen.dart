import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import '../../../Utilities/Colors/colorManager.dart';
import '../../../Utilities/Shared/sharedWidgets.dart';
import '../../../Utilities/responsive.dart';
import '../../../ViewModel/guard/authProv.dart';

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
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'dailyReports_screen.dart';

class PeriodReportsScreen extends StatefulWidget {
  const PeriodReportsScreen({Key key}) : super(key: key);

  @override
  _PeriodReportsScreenState createState() => _PeriodReportsScreenState();
}

class _PeriodReportsScreenState extends State<PeriodReportsScreen> {
  int invitationTypeId;
  final TextEditingController startDateController = TextEditingController();
  String selectedType;
  String date;
  bool loadReport = false;
  String fromDate;
  String toDate;
  String dateFromString;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    date = formatted;
  }

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} -'
            ' ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';

        fromDate = DateFormat('yyyy-MM-dd')
            .format(args.value.startDate)
            .toString()
            .replaceAll('/', '-');
        toDate = DateFormat('yyyy-MM-dd')
            .format(args.value.endDate ?? args.value.startDate)
            .toString()
            .replaceAll('/', '-');
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
    print('selected range $_range');
  }

  @override
  Widget bodyData() => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                dataRowHeight: 70.h,
                dividerThickness: 3.w,
                showBottomBorder: true,
                columnSpacing: isTab(context) ? 30.0 : 20,
                headingRowColor:
                    MaterialStateProperty.all<Color>(Colors.blueGrey),
                headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
                columns:

                <DataColumn>
                [

                  DataColumn(
                    label: Text(
                      '#',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(24),
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
                    tooltip: 'To display first id of the ReportRecord',
                  ),
                  DataColumn(
                    label: Text(
                      'مدنى',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(20),
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                    tooltip: 'To display first id of the ReportRecord',
                  ),
                  DataColumn(
                    label: Text(
                      'عسكرى',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(20),
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                    tooltip: 'To display first id of the ReportRecord',
                  ),
                  DataColumn(
                    label: Text(
                      'دخول',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(20),
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                    tooltip: 'To display first id of the ReportRecord',
                  ),
                  DataColumn(
                    label: Text(
                      'خروج',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(20),
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                    tooltip: 'To display first id of the ReportRecord',
                  ),    DataColumn(
                    label: Text(
                      'تاريخ الفاتورة',textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(20),
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                    tooltip: 'To display first id of the ReportRecord',
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
                      (ReportRecord) =>  DataRow(
                        cells: [
                          DataCell(
                            Text(
                              ReportRecord.id.toString(),textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: setResponsiveFontSize(24)),
                            ),onLongPress: (){
                            deleteRow(ReportRecord);
                          },
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(ReportRecord.type,
                                style: TextStyle(
                                    fontSize: setResponsiveFontSize(20))),
                            showEditIcon: false,
                            placeholder: false,onLongPress: (){
                            deleteRow(ReportRecord);
                          },
                          ),
                          DataCell(
                            Text(ReportRecord.civilCount.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: setResponsiveFontSize(26))),
                            showEditIcon: false,
                            placeholder: false,onLongPress: (){
                            deleteRow(ReportRecord);
                          },
                          ),
                          DataCell(
                            Text(ReportRecord.militryCount.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: setResponsiveFontSize(26))),
                            showEditIcon: false,
                            placeholder: false,onLongPress: (){
                            deleteRow(ReportRecord);
                          },
                          ),
                          DataCell(
                            Directionality(
                                textDirection: ui.TextDirection.ltr,
                                child: SizedBox(
                                //  width: 70.w,
                                  child: Text(ReportRecord.inDateTime.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: setResponsiveFontSize(22))),
                                )),
                            showEditIcon: false,onLongPress: (){
                            deleteRow(ReportRecord);
                          },
                            placeholder: false,
                          ),
                          DataCell(
                            Directionality(
                                textDirection: ui.TextDirection.ltr,
                                child: SizedBox(
                                //  width: 70.w,
                                  child: Text(
                                    ReportRecord.outDateTime.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: setResponsiveFontSize(22)),
                                  ),
                                )),
                            showEditIcon: false,onLongPress: (){
                            deleteRow(ReportRecord);
                          },
                            placeholder: false,
                          ),     DataCell(
                            Directionality(
                                textDirection: ui.TextDirection.ltr,
                                child: SizedBox(
                               //   width: 70.w,
                                  child: Text(
                                    ReportRecord.inDate.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: setResponsiveFontSize(22)),
                                  ),
                                )),
                            showEditIcon: false,onLongPress: (){
                            deleteRow(ReportRecord);
                          },
                            placeholder: false,
                          ),
                          DataCell(
                            InkWell(
                              onTap: () {
                                Fluttertoast.showToast(
                                    msg: ReportRecord.userName??"اسم المستخدم غير منوفر ",
                                    backgroundColor: Colors.green,
                                    toastLength: Toast.LENGTH_LONG);
                              },
                              child: Icon(
                                Icons.person,
                                size: isTab(context) ? 30 : 20,
                                color: Colors.orange,
                              ),
                            ),
                            showEditIcon: false,
                            placeholder: false,onLongPress: (){
                            deleteRow(ReportRecord);
                          },
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
                                Icons.image
                                ,
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
        ),
      );

  DateTimeRange dateRange =
      DateTimeRange(start: DateTime(2022, 11, 5), end: DateTime(2022, 12, 24));
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  int pageNumber = 1;
  int maxPages;

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
              'تقرير عن فترة',
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
                          left: 35.w,
                          right: 35.w,
                          child: SizedBox(
                            height: 60.h,
                            width: MediaQuery.of(context).size.width - 70.w,
                            child: ListView.builder(
                              itemCount: 1,
                              scrollDirection: Axis.horizontal, reverse: true,
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
                                          title: ' : الإجمالى بالغرامات',
                                          value: reportProv
                                              .summaryModel.total_Fines
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : الإجمالى',
                                          value: reportProv.summaryModel.total
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : إجمالى الغرامات',
                                          value: reportProv
                                              .summaryModel.rePrintFines
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : إجمالى مدنيين',
                                          value: reportProv
                                              .summaryModel.civilPrice
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : إجمالى ق.م',
                                          value: reportProv
                                              .summaryModel.militryPrice
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : إجمالى باركينج',
                                          value: reportProv
                                              .summaryModel.parkPrice
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : مدنيين',
                                          value: reportProv
                                              .summaryModel.civilCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : ق.م',
                                          value: reportProv
                                              .summaryModel.militryCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : سيارات الأنشطة',
                                          value: reportProv
                                              .summaryModel.activityCarCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : سيارات المدنيين',
                                          value: reportProv
                                              .summaryModel.citizenCarCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : سيارات الجيش',
                                          value: reportProv
                                              .summaryModel.militryCarCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : سيارات الأعضاء',
                                          value: reportProv
                                              .summaryModel.memberCarCount
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: 36.w,
                                        ),
                                        summaryItem(
                                          reportProv: reportProv,
                                          title: ' : عدد السيارات',
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
                                        child: Icon(Icons.arrow_back_ios),
                                        onTap: () {
                                          showLoaderDialog(
                                              context, 'جارى تحميل التقرير');
                                          Provider.of<AReportsProv>(context,
                                                  listen: false)
                                              .getDailyReport(fromDate, toDate,
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
                                            .getDailyReport(fromDate, toDate,
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
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return StatefulBuilder(
                                            builder: (context, stState) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: SizedBox(
                                              height:Platform.isIOS?510.h: 430.h,
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SfDateRangePicker(
                                                    view: DateRangePickerView
                                                        .month,
                                                    enablePastDates: true,
                                                    rangeSelectionColor:
                                                        Colors.green,
                                                    todayHighlightColor:
                                                        Colors.green,
                                                    selectionMode:
                                                        DateRangePickerSelectionMode
                                                            .range,
                                                    onSelectionChanged:
                                                        _onSelectionChanged,
                                                    showActionButtons: true,
                                                    controller:
                                                        dateRangePickerController,
                                                    onCancel: () {
                                                      dateRangePickerController
                                                          .selectedDates = null;
                                                      Navigator.pop(context);
                                                    },
                                                    onSubmit: (Object val) {
                                                      print(
                                                          'start date $fromDate    end date $toDate');
                                                      if ((fromDate
                                                                  .toString()
                                                                  .length ==
                                                              10) &&
                                                          (toDate
                                                                  .toString()
                                                                  .length ==
                                                              10)) {
                                                        setState(() {
                                                          loadReport = false;
                                                        });
                                                        Navigator.pop(context);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'اختر الفترة اولا',
                                                            backgroundColor:
                                                                Colors.green,
                                                            toastLength: Toast
                                                                .LENGTH_LONG);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    );
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                            (fromDate == null && toDate == null)
                                                ? 'اختر الفترة'
                                                : '$fromDate / $toDate',
                                            style: TextStyle(
                                                fontSize: isTab(context)
                                                    ? setResponsiveFontSize(22)
                                                    : setResponsiveFontSize(
                                                        16)),
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
                                width: isTab(context) ? 350.w : 370.w,
                              ),
                              Provider.of<AdminHomeProv>(context, listen: true)
                                      .parkTypes
                                      .isNotEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.green,
                                              width: 1.5.w)),
                                      width: isTab(context) ? 350.w : 370.w,
                                      height: 80.h,
                                      child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton(
                                          elevation: 2,
                                          isExpanded: true,
                                          items: Provider.of<AdminHomeProv>(
                                                  context,
                                                  listen: false)
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
                                                                20),
                                                        color: Colors.black,
                                                        fontFamily: 'Almarai'),
                                                  ),
                                                ));
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              //filterInvitations(value);
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
                                if (fromDate == null || toDate == null) {
                                  Fluttertoast.showToast(
                                      msg: 'اختر الفترة اولا',
                                      backgroundColor: Colors.green,
                                      toastLength: Toast.LENGTH_LONG);
                                  return;
                                }

                                showLoaderDialog(context, 'جارى تحميل التقرير');

                                debugPrint(
                                    'selectedType   ${selectedType ?? Provider.of<AdminHomeProv>(context, listen: false).parkTypes[0]}    from  $fromDate     to $toDate');

                                Provider.of<AReportsProv>(context,
                                        listen: false)
                                    .getDailyReport(
                                        fromDate, toDate, selectedType)
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
                                          msg: 'لا توجد تقارير فى تلك الفترة',
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
  void deleteRow(var ReportRecord){
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
  }
}
/*
Widget build(BuildContext context) {
  return Scaffold(
    body: LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.minWidth),
          child: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: DataTable(
                dataRowHeight: 70.h,
                dividerThickness: 3.w,
                showBottomBorder: true,
                columnSpacing: isTab(context) ? 30.0 : 20,
                headingRowColor:
                MaterialStateProperty.all<Color>(Colors.blueGrey),
                headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
                columns:

                <DataColumn>
                [

                  DataColumn(
                    label: Text(
                      '#',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(24),
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
                    tooltip: 'To display first id of the ReportRecord',
                  ),
                  DataColumn(
                    label: Text(
                      'مدنى',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(20),
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                    tooltip: 'To display first id of the ReportRecord',
                  ),
                  DataColumn(
                    label: Text(
                      'عسكرى',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(20),
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                    tooltip: 'To display first id of the ReportRecord',
                  ),
                  DataColumn(
                    label: Text(
                      'دخول',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(20),
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                    tooltip: 'To display first id of the ReportRecord',
                  ),
                  DataColumn(
                    label: Text(
                      'خروج',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(20),
                          fontWeight: FontManager.bold),
                    ),
                    numeric: false,
                    tooltip: 'To display first id of the ReportRecord',
                  ),    DataColumn(
                  label: Text(
                    'تاريخ الخروج',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                  tooltip: 'To display first id of the ReportRecord',
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
                      (ReportRecord) =>  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          ReportRecord.id.toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: setResponsiveFontSize(24)),
                        ),onLongPress: (){
                        deleteRow(ReportRecord);
                      },
                        showEditIcon: false,
                        placeholder: false,
                      ),
                      DataCell(
                        Text(ReportRecord.type,
                            style: TextStyle(
                                fontSize: setResponsiveFontSize(20))),
                        showEditIcon: false,
                        placeholder: false,onLongPress: (){
                        deleteRow(ReportRecord);
                      },
                      ),
                      DataCell(
                        Text(ReportRecord.civilCount.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: setResponsiveFontSize(26))),
                        showEditIcon: false,
                        placeholder: false,onLongPress: (){
                        deleteRow(ReportRecord);
                      },
                      ),
                      DataCell(
                        Text(ReportRecord.militryCount.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: setResponsiveFontSize(26))),
                        showEditIcon: false,
                        placeholder: false,onLongPress: (){
                        deleteRow(ReportRecord);
                      },
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
                        showEditIcon: false,onLongPress: (){
                        deleteRow(ReportRecord);
                      },
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
                        showEditIcon: false,onLongPress: (){
                        deleteRow(ReportRecord);
                      },
                        placeholder: false,
                      ),     DataCell(
                        Directionality(
                            textDirection: ui.TextDirection.ltr,
                            child: SizedBox(
                              width: 70.w,
                              child: Text(
                                ReportRecord.inDate.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: setResponsiveFontSize(22)),
                              ),
                            )),
                        showEditIcon: false,onLongPress: (){
                        deleteRow(ReportRecord);
                      },
                        placeholder: false,
                      ),
                      DataCell(
                        InkWell(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: 'أحمد رضوان',
                                backgroundColor: Colors.green,
                                toastLength: Toast.LENGTH_LONG);
                          },
                          child: Icon(
                            Icons.person,
                            size: isTab(context) ? 30 : 20,
                            color: Colors.orange,
                          ),
                        ),
                        showEditIcon: false,
                        placeholder: false,onLongPress: (){
                        deleteRow(ReportRecord);
                      },
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
                            Icons.image
                            ,
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
        ),
      ),
    ),
  );
}*/
