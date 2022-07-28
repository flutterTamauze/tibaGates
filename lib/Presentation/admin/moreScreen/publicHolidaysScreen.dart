import 'dart:io';

import 'package:Tiba_Gates/Utilities/Shared/calendar_popup_view.dart';
import 'package:animate_do/animate_do.dart';
import '../../../Utilities/responsive.dart';
import 'package:intl/intl.dart';
import '../../../Data/Models/admin/publicHolidaysModel.dart';
import '../../../Utilities/connectivityStatus.dart';
import '../../../ViewModel/admin/vm/publicHolidaysProv.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../admin_bottomNav.dart';
import '../../../Utilities/Colors/colorManager.dart';
import '../../../Utilities/Constants/constants.dart';
import '../../../Utilities/Fonts/fontsManager.dart';
import '../../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../../Utilities/Shared/sharedWidgets.dart';
import '../../../Utilities/Shared/textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class PublicHolidaysScreen extends StatefulWidget {
  const PublicHolidaysScreen({Key key}) : super(key: key);

  @override
  _PublicHolidaysScreenState createState() => _PublicHolidaysScreenState();
}

class _PublicHolidaysScreenState extends State<PublicHolidaysScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  List<PublicHolidaysModel> publicHolidaysList = [];
  Future publicHolidaysListener;

  @override
  void initState() {
    super.initState();
    publicHolidaysListener =
        Provider.of<PublicHolidaysProv>(context, listen: false)
            .getPublicHolidays();
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
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'الوصف',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                ),
                DataColumn(
                  label: Text(
                    'من',
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(20),
                        fontWeight: FontManager.bold),
                  ),
                  numeric: false,
                ),
                DataColumn(
                  label: Text(
                    'إلى',
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
              rows: publicHolidaysList
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 220.w,
                            child: Text(
                              e.description,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: setResponsiveFontSize(20),
                                  fontWeight: FontManager.bold),
                            ),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(
                            e.startDate.toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: setResponsiveFontSize(20),
                                fontWeight: FontManager.bold,
                                color: Colors.blue),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(
                            e.endDate.toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: setResponsiveFontSize(20),
                                fontWeight: FontManager.bold,
                                color: Colors.blue),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  PublicHolidaysProv holidaysProv =
                                      Provider.of<PublicHolidaysProv>(context,
                                          listen: false);
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AddOrEditPublicHoliday(
                                            successMessage: 'تم التعديل بنجاح',
                                            holidaysProv: holidaysProv,
                                            descriptionHint: e.description,
                                            onSubmit: () {
                                              debugPrint(
                                                  'desc is ${_descriptionController.text}  start date is ${Provider.of<PublicHolidaysProv>(context, listen: false).startDate}'
                                                      '   end date is ${Provider.of<PublicHolidaysProv>(context, listen: false).endDate}');

                                              showLoaderDialog(
                                                  context, 'جارى التعديل');
                                              Provider.of<PublicHolidaysProv>(
                                                      context,
                                                      listen: false)
                                                  .updatePublicHolidays(
                                                      e.id,
                                                      holidaysProv.startDate,
                                                      holidaysProv.endDate,
                                                      _descriptionController
                                                          .text)
                                                  .then((value) {
                                                if (value == 'Success') {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  e.description =
                                                      _descriptionController
                                                          .text;
                                                  e.startDate = holidaysProv
                                                      .startDate
                                                      .toString();
                                                  e.endDate = holidaysProv
                                                      .endDate
                                                      .toString();
                                                  _descriptionController.text =
                                                      '';
                                                  dateRangePickerController
                                                      .selectedDates = null;
                                                  holidaysProv.changeDate(
                                                      null, null);
                                                }
                                              });
                                            },
                                            context: context,
                                            title: 'قم بتعديل العطلة');
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
                                                    child: Text(
                                                      'هل انت متأكد من حذف العطلة ؟ ',
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

                                                            Provider.of<PublicHolidaysProv>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deleteHoliday(
                                                              e.id,
                                                            )
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

  final startDateController = TextEditingController();
  DateTimeRange dateRange =
      DateTimeRange(start: DateTime(2022, 11, 5), end: DateTime(2022, 12, 24));
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();
  var fromDate;
  var toDate;
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
  Widget build(BuildContext context) {
    var holidaysProv = Provider.of<PublicHolidaysProv>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: ZoomIn(
          child: FloatingActionButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AddOrEditPublicHoliday(
                        context: context,
                        holidaysProv: holidaysProv,
                        title: 'قم بإنشاء عطلة جديدة',
                        descriptionHint: 'ادخل وصف العطلة',
                        successMessage: 'تمت الإضافة بنجاح',
                        onSubmit: () {
                          debugPrint(
                              'desc is ${_descriptionController.text}  start date is ${Provider.of<PublicHolidaysProv>(context, listen: false).startDate}   end date is ${Provider.of<PublicHolidaysProv>(context, listen: false).endDate}');
                          showLoaderDialog(context, 'جارى الحفظ');

                          Provider.of<PublicHolidaysProv>(context,
                                  listen: false)
                              .addPublicHolidays(
                                  Provider.of<PublicHolidaysProv>(context,
                                          listen: false)
                                      .startDate,
                                  Provider.of<PublicHolidaysProv>(context,
                                          listen: false)
                                      .endDate,
                                  _descriptionController.text)
                              .then((value) {
                            if (value == 'Success') {
                              _descriptionController.text = '';
                              dateRangePickerController.selectedDates = null;
                              holidaysProv.changeDate(null, null);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                  msg: 'تمت الإضافة بنجاح',
                                  backgroundColor: Colors.white,
                                  textColor: Colors.green,
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          });
                        });
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
        body: connectionStatus == ConnectivityStatus.Offline
            ? Center(
                child: SizedBox(
                height: 400.h,
                width: 400.w,
                child: Lottie.asset('assets/lotties/noInternet.json'),
              ))
            : WillPopScope(
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
                      FutureBuilder(
                          future: publicHolidaysListener,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                              publicHolidaysList =
                                  Provider.of<PublicHolidaysProv>(context,
                                          listen: true)
                                      .holidaysList;
                              return Center(
                                  child: publicHolidaysList.isNotEmpty
                                      ? Column(
                                          children: [
                                            InkWell(onTap: ()=>    navigateTo(
                                                context,
                                                BottomNav(
                                                  comingIndex: 0,
                                                )),
                                              child: Padding(
                                                padding:  EdgeInsets.only(top: 12.h,left: 30.w),
                                                child: const Align(
                                                    alignment: Alignment.topLeft,

                                                    child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30,)),
                                              ),
                                            ),
                                            ZoomIn(
                                              child: SizedBox(
                                                height: (height * 0.17),
                                                width: (width * 0.32),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: ColorManager
                                                            .primary,
                                                        width: 2.w),
                                                    image: const DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/tipasplash.png')),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 40.h,
                                            ),
                                            Text(
                                              'العطلات الرسمية الحالية',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      setResponsiveFontSize(
                                                          33)),
                                            ),
                                            SizedBox(
                                              height: 60.h,
                                            ),
                                            bodyData(),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            ZoomIn(
                                              child: SizedBox(
                                                height: (height * 0.17),
                                                width: (width * 0.32),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: ColorManager
                                                            .primary,
                                                        width: 2.w),
                                                    image: const DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/tipasplash.png')),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 100.h,
                                            ),
                                            Lottie.asset(
                                                'assets/lotties/emptyCalender.json'),
                                            SizedBox(
                                              height: 40.h,
                                            ),
                                            Text(
                                              'لا توجد عطلات رسمية ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      setResponsiveFontSize(
                                                          46)),
                                            ),
                                          ],
                                        ));
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
  Dialog AddOrEditPublicHoliday(
      {BuildContext context,
      PublicHolidaysProv holidaysProv,
      String title,
      String descriptionHint,
      String successMessage,
      VoidCallback onSubmit}) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 16,
      child: SizedBox(
          height: 450.h,
          width: 600.w,
          child: Form(
            key: _formKey,  autovalidateMode: AutovalidateMode.onUserInteraction,

            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25.h,
                ),
                Text(
                  title,
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
                    controller: _descriptionController,
                    inputType: TextInputType.text,
                    hintText: descriptionHint,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    controller: startDateController,
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () {
                      showDemoDialog(context: context);
                  /*    showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return StatefulBuilder(
                            builder: (context, ststate) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: SizedBox(
                                  height:Platform.isIOS?510.h: 430.h,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SfDateRangePicker(
                                        view: DateRangePickerView.month,
                                        enablePastDates: false,
                                        rangeSelectionColor: Colors.green,
                                        todayHighlightColor: Colors.green,
                                        selectionMode:
                                            DateRangePickerSelectionMode.range,
                                        onSelectionChanged: _onSelectionChanged,
                                        showActionButtons: true,
                                        controller: dateRangePickerController,
                                        onCancel: () {
                                          dateRangePickerController
                                              .selectedDates = null;

                                          Navigator.pop(context);
                                        },
                                        onSubmit: (Object val) {
                                          print(
                                              'start date $fromDate    end date $toDate');
                                          if ((fromDate.toString().length ==
                                                  10) &&
                                              (toDate.toString().length ==
                                                  10)) {
                                            print('done');

                                            holidaysProv.changeDate(
                                                fromDate.toString(),
                                                toDate.toString());

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
                      );*/
                    },
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text((Provider.of<PublicHolidaysProv>(context,
                                                listen: true)
                                            .startDate ==
                                        null &&
                                    Provider.of<PublicHolidaysProv>(context,
                                                listen: true)
                                            .endDate ==
                                        null)
                                ? 'اختر الفترة'
                                : 'من ${Provider.of<PublicHolidaysProv>(context, listen: true).startDate}  إلى ${Provider.of<PublicHolidaysProv>(context, listen: true).endDate}'),
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                  ),
                  width: isTab(context) ? 530.w : 505.w,
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
                          _descriptionController.text = '';
                          dateRangePickerController.selectedDates = null;
                          holidaysProv.changeDate(null, null);

                          Navigator.pop(context);
                        },
                        title: 'إلغاء',
                        buttonColor: Colors.grey,
                        titleColor: ColorManager.backGroundColor,
                      ),
                      RoundedButton(
                        height: 55,
                        width: 220,
                        ontap: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          } else if (holidaysProv.endDate == null ||
                              holidaysProv.startDate == null) {
                            Fluttertoast.showToast(
                                msg: 'اختر الفترة اولا',
                                backgroundColor: Colors.green,
                                toastLength: Toast.LENGTH_LONG);
                            return;
                          } else {
                            onSubmit();
                          }
                        },
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
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  void showDemoDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          debugPrint('start $startData');
          debugPrint('end $endData');

          Provider.of<PublicHolidaysProv>(context, listen: false).changeDate(startData.toString().split(' ')[0], endData.toString().split(' ')[0]);



   /*       setState(() {
            startDate = startData;
            endDate = endData;
          });*/
        },
        onCancelClick: () {},
      ),
    );
  }

}
