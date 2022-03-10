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
  final startDateController = TextEditingController();
  var selectedType;
  String date;
  bool loadReport = false;
  var fromDate;
  var toDate;
  String dateFromString;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
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
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'id',
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
                ),
              ],
              rows: Provider.of<AReportsProv>(context, listen: false)
                  .reportsList
                  .map(
                    (ReportRecord) => DataRow(
                      cells: [
                        DataCell(
                          Text(ReportRecord.id.toString()),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(ReportRecord.type),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(ReportRecord.civilCount.toString()),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(ReportRecord.militryCount.toString()),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(ReportRecord.inDateTime.toString()),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(ReportRecord.outDateTime.toString()),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                      ],
                    ),
                  )
                  .toList()),
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
      body: Container(
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
                    scrollDirection: Axis.horizontal,reverse: true,
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
                                value: reportProv.summaryModel.total_Fines
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
                              ), summaryItem(
                                reportProv: reportProv,
                                title: ' : إجمالى الغرامات',
                                value: reportProv.summaryModel.rePrintFines
                                    .toString(),
                              ),
                              SizedBox(
                                width: 36.w,
                              ),
                              summaryItem(
                                reportProv: reportProv,
                                title: ' : إجمالى مدنيين',
                                value: reportProv.summaryModel.civilPrice
                                    .toString(),
                              ),
                              SizedBox(
                                width: 36.w,
                              ),
                              summaryItem(
                                reportProv: reportProv,
                                title: ' : إجمالى ق.م',
                                value: reportProv.summaryModel.militryPrice
                                    .toString(),
                              ),
                              SizedBox(
                                width: 36.w,
                              ),
                              summaryItem(
                                reportProv: reportProv,
                                title: ' : إجمالى باركينج',
                                value: reportProv.summaryModel.parkPrice
                                    .toString(),
                              ),
                              SizedBox(
                                width: 36.w,
                              ),
                              summaryItem(
                                reportProv: reportProv,
                                title: ' : مدنيين',
                                value: reportProv.summaryModel.civilCount
                                    .toString(),
                              ),
                              SizedBox(
                                width: 36.w,
                              ),
                              summaryItem(
                                reportProv: reportProv,
                                title: ' : ق.م',
                                value: reportProv.summaryModel.militryCount
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
                                value: reportProv.summaryModel.carsCount
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
                          showLoaderDialog(context, 'جارى تحميل التقرير');
                          Provider.of<AReportsProv>(context,
                              listen: false)
                              .getDailyReport(fromDate, toDate,
                              selectedType, pageNumber - 1)
                              .then((value) {
                            Navigator.pop(context);
                            if (value == 'Success') {
                              if (Provider.of<AReportsProv>(context,
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
                                    backgroundColor: Colors.green,
                                    toastLength: Toast.LENGTH_LONG);
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
                      if((Provider.of<AReportsProv>(context,listen: true).summaryModel.carsCount/10).ceil()>pageNumber)
                        InkWell(
                            onTap: () {
                              showLoaderDialog(context, 'جارى تحميل التقرير');
                              Provider.of<AReportsProv>(context,
                                  listen: false)
                                  .getDailyReport(fromDate, toDate, selectedType,
                                  pageNumber + 1)
                                  .then((value) {
                                Navigator.pop(context);
                                if (value == 'Success') {
                                  if (Provider.of<AReportsProv>(context,
                                      listen: false)
                                      .reportsList
                                      .isNotEmpty) {
                                    setState(() {
                                      loadReport = true;
                                      pageNumber++;
                                    });

                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'لا توجد تقارير فى هذا اليوم',
                                        backgroundColor: Colors.green,
                                        toastLength: Toast.LENGTH_LONG);

                                    setState(() {
                                      loadReport = false;
                                    });
                                  }
                                }
                              });
                            },
                            child: Icon(Icons.arrow_forward_ios)),
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
                            controller: startDateController,
                            keyboardType: TextInputType.datetime,
                            autovalidate: true,
                            readOnly: true,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: SizedBox(
                                      height: 430.h,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SfDateRangePicker(
                                            view: DateRangePickerView.month,
                                            enablePastDates: true,
                                            rangeSelectionColor: Colors.green,
                                            todayHighlightColor: Colors.green,
                                            selectionMode:
                                                DateRangePickerSelectionMode.range,
                                            // onSelectionChanged: _onSelectionChanged,
                                            showActionButtons: true,
                                            controller: dateRangePickerController,
                                            onCancel: () {
                                              dateRangePickerController
                                                  .selectedDates = null;
                                              Navigator.pop(context);
                                            },
                                            onSubmit: (Object val) {
                                              print(' ${val.toString().length}');
                                              if (val != null &&
                                                  val.toString().length > 72) {
                                                setState(() {
                                                  fromDate = val
                                                      .toString()
                                                      .substring(32, 43);
                                                  toDate = val
                                                      .toString()
                                                      .substring(67, 78);
                                                });

                                                print(val);
                                                print('from is $fromDate');
                                                print('to is $toDate');
                                                Navigator.pop(context);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: 'اختر الفترة اولا',
                                                    backgroundColor: Colors.green,
                                                    toastLength: Toast.LENGTH_LONG);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text((fromDate == null && toDate == null)
                                        ? 'اختر الفترة'
                                        : 'من $fromDate  إلى $toDate'),
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
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                            ),
                          ),
                          width: 350.w,
                        ),
                        Provider.of<AdminHomeProv>(context, listen: true)
                                .parkTypes
                                .isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.green, width: 1.w)),
                                width: 350.w,
                                height: 80.h,
                                child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    elevation: 2,
                                    isExpanded: true,
                                    items: Provider.of<AdminHomeProv>(context,
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
                                                      setResponsiveFontSize(20),
                                                  color: Colors.black,
                                                  fontFamily: 'Almarai'),
                                            ),
                                          ));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        //filterInvitations(value);

                                        selectedType = value;

                                        print(
                                            'selected invitation type is $selectedType');
                                      });
                                    },
                                    value: selectedType ??
                                        Provider.of<AdminHomeProv>(context,
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
                              child: Lottie.asset('assets/lotties/reports.json',
                                  repeat: false),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 40.h,
                ),
                OutlinedButton(
                  onPressed: () {
                    if (fromDate == null || toDate == null) {
                      Fluttertoast.showToast(
                          msg: 'اختر الفترة اولا',
                          backgroundColor: Colors.green,
                          toastLength: Toast.LENGTH_LONG);
                      return;
                    }

                    showLoaderDialog(context, 'جارى تحميل التقرير');

                    print(
                        'selectedType   ${selectedType ?? Provider.of<AdminHomeProv>(context, listen: false).parkTypes[0]}    from  $fromDate     to $toDate');

                    Provider.of<AReportsProv>(context, listen: false)
                        .getDailyReport(fromDate, toDate, selectedType)
                        .then((value) {
                      if (value == 'Success') {
                        if (Provider.of<AReportsProv>(context, listen: false)
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
                    width: 200.w,
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
                        Text(
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
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.green, width: 3.w)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w)),
                      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))))),
                ),
                loadReport == true ? const Spacer() : Container(),
/*                loadReport == true
                    ? const Align(
                        child: Divider(
                        thickness: 2,
                        color: Colors.green,
                      ))
                    : Container()*/
/*
                loadReport == true
                    ? Expanded(
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
                                      value:
                                          reportProv.summaryModel.total.toString(),
                                    ),
                                    SizedBox(
                                      width: 26.w,
                                    ),
                                    summaryItem(
                                      reportProv: reportProv,
                                      title: 'أجمالى بالغرامات',
                                      value: reportProv.summaryModel.total_Fines
                                          .toString(),
                                    ),
                                    SizedBox(
                                      width: 26.w,
                                    ),
                                    summaryItem(
                                      reportProv: reportProv,
                                      title: 'أجمالى مدنيين',
                                      value: reportProv.summaryModel.civilPrice
                                          .toString(),
                                    ),
                                    SizedBox(
                                      width: 26.w,
                                    ),
                                    summaryItem(
                                      reportProv: reportProv,
                                      title: 'أجمالى ق.م',
                                      value: reportProv.summaryModel.militryPrice
                                          .toString(),
                                    ),
                                    SizedBox(
                                      width: 26.w,
                                    ),
                                    summaryItem(
                                      reportProv: reportProv,
                                      title: 'أجمالى باركينج',
                                      value: reportProv.summaryModel.parkPrice
                                          .toString(),
                                    ),
                                    SizedBox(
                                      width: 26.w,
                                    ),
                                    summaryItem(
                                      reportProv: reportProv,
                                      title: 'مدنيين',
                                      value: reportProv.summaryModel.civilCount
                                          .toString(),
                                    ),
                                    SizedBox(
                                      width: 26.w,
                                    ),
                                    summaryItem(
                                      reportProv: reportProv,
                                      title: 'ق.م',
                                      value: reportProv.summaryModel.militryCount
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
                                      value: reportProv.summaryModel.citizenCarCount
                                          .toString(),
                                    ),
                                    SizedBox(
                                      width: 26.w,
                                    ),
                                    summaryItem(
                                      reportProv: reportProv,
                                      title: 'سيارات الجيش',
                                      value: reportProv.summaryModel.militryCarCount
                                          .toString(),
                                    ),
                                    SizedBox(
                                      width: 26.w,
                                    ),
                                    summaryItem(
                                      reportProv: reportProv,
                                      title: 'سيارات الأعضاء',
                                      value: reportProv.summaryModel.memberCarCount
                                          .toString(),
                                    ),
                                    SizedBox(
                                      width: 26.w,
                                    ),
                                    summaryItem(
                                      reportProv: reportProv,
                                      title: 'عدد السيارات',
                                      value: reportProv.summaryModel.carsCount
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container()
*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future pickDateRange() async {
    showDateRangePicker(
        context: context, firstDate: DateTime(1900), lastDate: DateTime(2100));
  }

/*  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    print('range is    ${dateRangePickerSelectionChangedArgs.value}');
  }*/
}

