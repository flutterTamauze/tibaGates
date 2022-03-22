import 'package:clean_app/Utilities/Colors/colorManager.dart';
import 'package:clean_app/Utilities/Shared/sharedWidgets.dart';
import 'package:clean_app/ViewModel/admin/a_homeBioProv.dart';
import 'package:clean_app/ViewModel/admin/reports/admin_reportsProv.dart';
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
import '../../../Utilities/Shared/tableHeader.dart';
import '../../../ViewModel/manager/managerProv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final startDateController = TextEditingController();
  var selectedType;
  String date;
  bool loadReport = false;
  int pageNumber = 1;
  int maxPages;
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
                          Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: Text(ReportRecord.inDateTime.toString())),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: Text(ReportRecord.outDateTime.toString())),
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
                                        .getDailyReport(date, date,
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
                                    .getDailyReport(date, date, selectedType,
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
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.parse('2010-01-01'),
                                      lastDate: DateTime.parse('2030-12-31'))
                                  .then((value) {
                                if (value == null) {
                                  startDateController.text = '';
                                } else {
                                  //showLoaderDialog(context, 'Loading...');
                                  startDateController.text =
                                      DateUtil.formatDate(value).toString();

                                  print(
                                      'Date Time Value : ${value.toString().substring(0, 10)}\n');
                                  setState(() {
                                    date = value.toString().substring(0, 10);
                                  });
                                }
                              });
                            },
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      date ?? '',
                                      style: TextStyle(fontSize: 20),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                            ),
                          ),
                          width: 300.w,
                        ),
                        Provider.of<AdminHomeProv>(context, listen: true)
                                .parkTypes
                                .isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
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
                    if (date == null) {
                      final DateTime now = DateTime.now();
                      final DateFormat formatter = DateFormat('yyyy-MM-dd');
                      final String formatted = formatter.format(now);
                      date = formatted;
                    }
                    showLoaderDialog(context, 'جارى تحميل التقرير');

                    print(
                        'selectedType   ${selectedType ?? Provider.of<AdminHomeProv>(context, listen: false).parkTypes[0]}    date $date');

                    Provider.of<AReportsProv>(context, listen: false)
                        .getDailyReport(date, date, selectedType)
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
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 20.w)),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))))),
                ),
                loadReport == true ? const Spacer() : Container(),
                /*   loadReport == true
                    ? const Align(
                        child: Divider(
                        thickness: 2,
                        color: Colors.green,
                      ))
                    : Container(),*/
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
}

class summaryItem extends StatelessWidget {
  String title, value;

  summaryItem({Key key, @required this.reportProv, this.value, this.title})
      : super(key: key);

  final AReportsProv reportProv;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }
}
