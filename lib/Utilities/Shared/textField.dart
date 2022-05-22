import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/constants.dart';

class TextEditField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  const TextEditField({Key key, this.controller, this.hintText, this.inputType}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value
            .isEmpty) {
          return 'required';
        }
        return null;
      }
      ,keyboardType: inputType,

      controller: controller,
      cursorColor:
      Colors.green,
      maxLines: null,
      decoration:
      InputDecoration(
        errorStyle: TextStyle(
            fontWeight:
            FontWeight
                .bold,
            fontSize:
            setResponsiveFontSize(
                20)),
        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius
              .circular(
              10),
          borderSide: BorderSide(
              width: 2.w,
              color: Colors
                  .green),
        ),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors
                    .green,
                width:
                4.w)),
        enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius
                .circular(
                10),
            borderSide: BorderSide(
                color: Colors
                    .green,
                width:
                0.w)),
        border: OutlineInputBorder(
            borderRadius:
            BorderRadius
                .circular(
                10),
            borderSide: BorderSide(
                color: Colors
                    .green,
                width:
                0.w)),
        hintStyle: TextStyle(
            fontWeight:
            FontWeight
                .w600,color: Colors.grey,
            fontSize:
            setResponsiveFontSize(
                26),
            fontFamily:
            'Almarai'),
        hintText: hintText,
      ),
      textAlign:
      TextAlign.right,
    );
  }
}