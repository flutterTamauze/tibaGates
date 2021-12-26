import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/sharedWidgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;
import 'dart:ui';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

class ProposalScreen extends StatefulWidget {
  var selectedAction = "شكوى";

  @override
  _ProposalScreenState createState() => _ProposalScreenState();
}

late File imgFile1;
late File imgFile2;
late File imgFile3;

final _controller = ScrollController();

List<String> actions = ["شكوى", "مقترح"];
List<String> meetingActions = ["شخصية", "شركة", "مؤسسة"];
String meetingType = "شخصية";
final _formKey = GlobalKey<FormState>();
var isPressed = false;
// RequestModel request = RequestModel();
List<File> images = [];

class _ProposalScreenState extends State<ProposalScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var isPressed = true;
  late File localFile;
  var fileSize = 0;
  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorManager.primary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 26,
                      color: Colors.white,
                    )),
                AutoSizeText(
                  "الشكاوى والمقترحات   ",
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          //endDrawer: NotificationItem(),
          body: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                  physics: BouncingScrollPhysics(),
                  controller: _controller,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: ColorManager.primary,
                                        width: 1.w)),
                                width: 130.w,
                                height: 40.h,
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                  elevation: 2,
                                  isExpanded: true,
                                  items: actions.map((String x) {
                                    return DropdownMenuItem<String>(
                                        value: x,
                                        child: Center(
                                          child: Text(
                                            x,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: ColorManager.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.selectedAction = value.toString();
                                      print(widget.selectedAction);
                                    });
                                  },
                                  value: widget.selectedAction,
                                )),
                              ),
                              widget.selectedAction == "مقترح"
                                  ? Image.asset(
                                      "assets/images/ektrah.png",
                                      width: 48.w,
                                      height: 48.h,
                                    )
                                  : widget.selectedAction == "طلب مقابلة"
                                      ? Image.asset(
                                          "assets/images/meeting.png",
                                          width: 48.w,
                                          height: 48.h,
                                        )
                                      : Image.asset(
                                          "assets/images/shakwa.png",
                                          width: 48.w,
                                          height: 48.h,
                                        ),
                              Text(
                                "نوع الطلب",
                                style: TextStyle(
                                  fontSize: setResponsiveFontSize(17),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          widget.selectedAction == "شكوى"
                              ? "قم بإدخال شكواك"
                              : widget.selectedAction == "مقترح"
                                  ? "قم بإدخال مقترحك"
                                  : "قم بإدخال تفاصيل المقابلة",
                          style: TextStyle(
                              color: ColorManager.primary,
                              fontSize: setResponsiveFontSize(18),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: TextFormField(
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return " برجاء ادخال عنوان لل${widget.selectedAction}";
                                }
                                return null;
                              },
                              controller: titleController,
                              cursorColor: ColorManager.primary,
                              maxLines: null,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: setResponsiveFontSize(13)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 2.w, color: ColorManager.primary),
                                ),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                        width: 4.w)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                        width: 0.w)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                        width: 0.w)),
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: setResponsiveFontSize(14),
                                ),
                                hintText: "عنوان ال${widget.selectedAction}",
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        widget.selectedAction != "طلب مقابلة"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return " برجاء ادخال موضوع ال${widget.selectedAction}";
                                      }
                                      return null;
                                    },
                                    controller: descriptionController,
                                    cursorColor: ColorManager.primary,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: setResponsiveFontSize(13)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 2.w,
                                            color: ColorManager.primary),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .textSelectionColor,
                                              width: 4.w)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .textSelectionColor,
                                              width: 0.w)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .textSelectionColor,
                                              width: 0.w)),
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: setResponsiveFontSize(14),
                                      ),
                                      hintText: "ال${widget.selectedAction}",
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, bottom: 16.h),
                          child: RoundedButton(
                            buttonColor: ColorManager.primary,
                            titleColor: ColorManager.backGroundColor,
                            title: "ارسال",
                            ontap: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              } else {
                                if (widget.selectedAction != "طلب مقابلة") {
                                  if (titleController.text.isNotEmpty &&
                                      descriptionController.text.isNotEmpty) {
                                    // prepare the model

                                    /*  await Provider.of<RequestProv>(context,
                                  listen: false)
                              .sendRequest(request);*/

                                    titleController.text = "";
                                    descriptionController.text = "";
                                  }
                                } else {
                                  if (titleController.text.isNotEmpty) {
                                    // prepare the model

                                    /*  await Provider.of<RequestProv>(context,
                                  listen: false)
                              .sendRequest(request);*/

                                    titleController.text = "";
                                  }
                                }

                                Fluttertoast.showToast(
                                    msg: "تم الأرسال بنجاح",
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }
}
