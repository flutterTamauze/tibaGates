import 'package:animate_do/animate_do.dart';
import 'package:clean_app/Presentation/manager/m_share_qr.dart';
import 'package:clean_app/Utilities/Shared/dialogs/loading_dialog.dart';
import 'package:clean_app/ViewModel/guard/authProv.dart';
import 'package:clean_app/ViewModel/manager/managerProv.dart';
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

  const MAddInvitation({Key key, this.invitationType, this.invitationTypeId})
      : super(key: key);

  @override
  _MAddInvitationState createState() => _MAddInvitationState();
}

class _MAddInvitationState extends State<MAddInvitation> {
  TextEditingController visitorNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String date;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MHomeScreen()));
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                                                  setResponsiveFontSize(13)),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 2.w,
                                                color: Colors.green),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 4.w)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 0.w)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 0.w)),
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  setResponsiveFontSize(14),
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
                                        fontSize: setResponsiveFontSize(26),
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
                                                  setResponsiveFontSize(13)),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 2.w,
                                                color: Colors.green),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 4.w)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 0.w)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 0.w)),
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  setResponsiveFontSize(14),
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
                                        fontSize: setResponsiveFontSize(26),
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
                                    width: 300.w,
                                    child: TextFormField(
                                      controller: startDateController,
                                      keyboardType: TextInputType.datetime,
                                      autovalidate: true,
                                      readOnly: true,
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.parse(
                                                    '2010-01-01'),
                                                lastDate: DateTime.parse(
                                                    '2030-12-31'))
                                            .then((value) {
                                          if (value == null) {
                                            startDateController.text = '';
                                          } else {
                                            startDateController.text =
                                                DateUtil.formatDate(value)
                                                    .toString();
                                            debugPrint(
                                                'Date Time Value : ${value.toString()}\n');
                                            date = value
                                                .toString()
                                                .substring(0, 10);
                                          }
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'you must enter date';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: const Icon(
                                          Icons.calendar_today,
                                          color: Colors.green,
                                        ),
                                        hintText: 'تاريخ الدعوة',
                                        hintStyle: TextStyle(
                                            //    color: darkBlueColor,
                                            fontFamily: 'Open Sans',
                                            fontSize: setResponsiveFontSize(16),
                                            fontWeight: FontWeight.w600),
                                        alignLabelWithHint: true,
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.green,
                                                width: 1.0),
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
                                                color: Colors.green,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'تاريخ الدعوة',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: setResponsiveFontSize(26),
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
                              'visitor name ${visitorNameController.text}  description ${descriptionController.text}  managerId ${Provider.of<AuthProv>(context, listen: false).userId}  invitationTypeID ${widget.invitationTypeId} date $date ');
                          Provider.of<ManagerProv>(context, listen: false)
                              .addInvitation(
                                  visitorNameController.text,
                                  descriptionController.text,
                                  Provider.of<AuthProv>(context, listen: false)
                                      .userId,
                                  widget.invitationTypeId,
                                  date)
                              .then((value) {
                            debugPrint('value is $value');
                            if (value == 'Success') {
                              debugPrint('Success');
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => MShareQr()),
                                  (Route<dynamic> route) => false);
                            } else {
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
