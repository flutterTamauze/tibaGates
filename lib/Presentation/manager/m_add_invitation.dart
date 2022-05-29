import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../admin/admin_bottomNav.dart';
import '../../Utilities/responsive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../main.dart';
import '../admin/a_invitations_screen.dart';
import 'm_share_qr.dart';
import '../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../Utilities/connectivityStatus.dart';
import '../../ViewModel/guard/authProv.dart';
import '../../ViewModel/manager/managerProv.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'm_home_screen.dart';
import 'package:flutter/material.dart';

class MAddInvitation extends StatefulWidget {
  final String invitationType;
  final int invitationTypeId;
  final String userRole;
  const MAddInvitation(
      {Key key, this.invitationType, this.invitationTypeId, this.userRole})
      : super(key: key);

  @override
  _MAddInvitationState createState() => _MAddInvitationState();
}

class _MAddInvitationState extends State<MAddInvitation> {
  TextEditingController visitorNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String date;
  String fromDate;
  String toDate;
  String dateFromString;
  String _range = '';

  DateRangePickerController dateRangePickerController =
  DateRangePickerController();

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
      }
    });
    print('selected range $_range');
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    date = formatted;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ConnectivityStatus connectionStatus =
    Provider.of<ConnectivityStatus>(context);

    return WillPopScope(
      onWillPop: () {
        if (widget.userRole == 'Admin') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BottomNav(
                    comingIndex: 1,
                  )));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const MHomeScreen()));
        }
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: connectionStatus == ConnectivityStatus.Offline
                ? Center(
                child: SizedBox(
                  height: 400.h,
                  width: 400.w,
                  child: Lottie.asset('assets/lotties/noInternet.json'),
                ))
                : SingleChildScrollView(
              child: Form(
                key: _formKey,  autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    SizedBox(
                      height: 80.h,
                    ),
                    Center(
                      child: ZoomIn(
                        child: SizedBox(
                          height: (height * 0.21),
                          width: (width * 0.43),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage(widget.invitationType
                                      .toLowerCase()
                                      .contains('vip')
                                      ? 'assets/images/vip.png'
                                      : 'assets/images/invitation.jpg')),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 30.h),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'required';
                                          }
                                          return null;
                                        },
                                        controller: visitorNameController,
                                        cursorColor: Colors.green,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              setResponsiveFontSize(
                                                  13)),
                                          focusedBorder:
                                          OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 2.w,
                                                color: Colors.green),
                                          ),
                                          disabledBorder:
                                          OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 4.w)),
                                          enabledBorder:
                                          OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 0.w)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 0.w)),
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                              setResponsiveFontSize(
                                                  14),
                                              fontFamily: 'Almarai'),
                                          hintText: 'الاسم',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    width: 300.w,
                                  ),
                                  Text(
                                    'اسم الضيف',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize:
                                        setResponsiveFontSize(26),
                                        fontWeight: FontManager.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'required';
                                          }
                                          return null;
                                        },
                                        controller: descriptionController,
                                        cursorColor: Colors.green,
                                        maxLines: null,
                                        maxLength: 500,
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              setResponsiveFontSize(
                                                  13)),
                                          focusedBorder:
                                          OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 2.w,
                                                color: Colors.green),
                                          ),
                                          disabledBorder:
                                          OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 4.w)),
                                          enabledBorder:
                                          OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 0.w)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 0.w)),
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                              setResponsiveFontSize(
                                                  14),
                                              fontFamily: 'Almarai'),
                                          hintText: 'التفاصيل',
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    width: 300.w,
                                  ),
                                  Text(
                                    'تفاصيل الدعوة',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize:
                                        setResponsiveFontSize(26),
                                        fontWeight: FontManager.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [


                                  SizedBox(
                                    child: TextFormField(
                                      autovalidateMode:
                                      AutovalidateMode.always,
                                      controller: startDateController,
                                      keyboardType:
                                      TextInputType.datetime,
                                      readOnly: true,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return StatefulBuilder(
                                                builder:
                                                    (context, stState) {
                                                  return Dialog(
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(20.0),
                                                    ),
                                                    child: SizedBox(
                                                      height:Platform.isIOS?510.h: 430.h,
                                                      width: double.infinity,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          SfDateRangePicker(
                                                            view:
                                                            DateRangePickerView
                                                                .month,
                                                            enablePastDates:
                                                            true,
                                                            rangeSelectionColor:
                                                            Colors.green,
                                                            todayHighlightColor:
                                                            Colors.green,
                                                            selectionMode:
                                                            DateRangePickerSelectionMode
                                                                .range,
                                                            onSelectionChanged:
                                                            _onSelectionChanged,
                                                            showActionButtons:
                                                            true,
                                                            controller:
                                                            dateRangePickerController,
                                                            onCancel: () {
                                                              dateRangePickerController
                                                                  .selectedDates =
                                                              null;
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            onSubmit:
                                                                (Object val) {
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
                                                                Navigator.pop(
                                                                    context);
                                                              } else {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                    'اختر الفترة اولا',
                                                                    backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                    toastLength:
                                                                    Toast
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
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                (fromDate == null &&
                                                    toDate == null)
                                                    ? 'اختر الفترة'
                                                    : '$fromDate / $toDate',
                                                style: TextStyle(
                                                    fontSize:
                                                    setResponsiveFontSize(
                                                        16)),
                                              ),
                                              const Icon(
                                                Icons.calendar_today,
                                                color: Colors.green,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        hintText: '',
                                        hintStyle: TextStyle(
                                          //    color: darkBlueColor,
                                            fontFamily: 'Open Sans',
                                            fontSize:
                                            setResponsiveFontSize(16),
                                            fontWeight: FontWeight.w600),
                                        alignLabelWithHint: true,
                                        focusedBorder:
                                        const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.green,
                                                width: 1.0),
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    8.0))),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        enabledBorder:
                                        const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.green,
                                                width: 1.0),
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    8.0))),
                                      ),
                                    ),
                                    width: 300.w,
                                  ),
                                  Text(
                                    'تاريخ الدعوة',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize:
                                        setResponsiveFontSize(26),
                                        fontWeight: FontManager.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    RoundedButton(
                      ontap: () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        } else {
                          showLoaderDialog(context, 'Loading...');
                          debugPrint(
                              'visitor name ${visitorNameController.text}  description ${descriptionController.text}  managerId ${Provider.of<AuthProv>(context, listen: false).userId}  invitationTypeID ${widget.invitationTypeId} from $fromDate   to $toDate ');
                          Provider.of<ManagerProv>(context, listen: false)
                              .addInvitation(
                              visitorNameController.text,
                              descriptionController.text,
                              Provider.of<AuthProv>(context,
                                  listen: false)
                                  .userId,
                              widget.invitationTypeId,
                              fromDate,
                              toDate)
                              .then((value) {
                            debugPrint('value is $value');
                            if (value == 'Success') {
                              debugPrint('Success');
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => MShareQr(
                                          role: prefs.getString('role'))),
                                      (Route<dynamic> route) => false);
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'حدث خطأ ما برجاء المحاولة لاحقاً',
                                  backgroundColor: Colors.green,
                                  toastLength: Toast.LENGTH_LONG);
                              Navigator.pop(context);
                              debugPrint('حدث خطا ما');
                            }
                          });
                        }
                      },
                      title: 'إضافة',
                      width: 220,
                      height: 55,
                      buttonColor: ColorManager.primary,
                      titleColor: ColorManager.backGroundColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
