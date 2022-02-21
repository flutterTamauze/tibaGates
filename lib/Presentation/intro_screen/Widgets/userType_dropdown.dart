import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTypeDropdown extends StatefulWidget {
  final Function function;
  const UserTypeDropdown({Key key,  this.function}) : super(key: key);

  @override
  _UserTypeDropdownState createState() => _UserTypeDropdownState();
}

class _UserTypeDropdownState extends State<UserTypeDropdown> {
  String currentDropdownValue = "عضو دار";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color(0xff4a4a4a), width: 1.0)),
      child: DropdownButtonHideUnderline(
          child: DropdownButton(
        elevation: 2,
        onChanged: (value) {
          setState(() {
            widget.function(value);
            currentDropdownValue = value.toString();
          });
        },
        isExpanded: true,
        value: currentDropdownValue,
        items: [
          DropdownMenuItem(
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                "عضو دار",
                style: boldStyle.copyWith(fontSize: setResponsiveFontSize(15)),
              ),
            ),
            value: "عضو دار",
          ),
          DropdownMenuItem(
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                "نزيل فندق",
                style: boldStyle.copyWith(fontSize: setResponsiveFontSize(15)),
              ),
            ),
            value: "نزيل فندق",
          ),
        ],
      )),
    );
  }
}
