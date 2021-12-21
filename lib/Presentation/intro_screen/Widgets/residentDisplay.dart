import 'package:animate_do/animate_do.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResidentDisplay extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController roomController;

  ResidentDisplay(
      {required this.phoneController, required this.roomController});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Column(children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          maxLengthEnforced: true,
          maxLength: 11,
          validator: (text) {
            RegExp regex = new RegExp("^01[0-2|5]{1}[0-9]{8}\$");
            if (text!.isEmpty || text == null) {
              return 'برجاء إدخال رقم هاتفك';
            }
            if (!regex.hasMatch(text)) {
              return 'برجاء إدخال رقم هاتف صحيح';
            }
            return null;
          },
          controller: phoneController,
          style: TextStyle(
              color: Colors.black,
              fontSize: setResponsiveFontSize(17),
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
          decoration: kTextFieldDecorationWhite.copyWith(
              hintText: "رقم الهاتف",
              suffixIcon: Icon(
                Icons.phone_android,
                color: ColorManager.primary,
              )),
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          maxLengthEnforced: true,
          validator: (text) {
            if (text == "") {
              return "برجاء إدخال رقم الغرفة";
            }

            return null;
          },
          controller: roomController,
          style: TextStyle(
              color: Colors.black,
              fontSize: setResponsiveFontSize(17),
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
          decoration: kTextFieldDecorationWhite.copyWith(
              hintText: "رقم الغرفة",
              suffixIcon: Icon(
                Icons.person,
                color: ColorManager.primary,
              )),
        ),
      ]),
    );
  }
}
