import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemSizeDropDown extends StatefulWidget {
  final Function function;
  const ItemSizeDropDown({Key? key, required this.function}) : super(key: key);

  @override
  _ItemSizeDropDownState createState() => _ItemSizeDropDownState();
}

class _ItemSizeDropDownState extends State<ItemSizeDropDown> {
  String currentDropdownValue = "صغير";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
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
                "صغير",
                style: boldStyle.copyWith(fontSize: setResponsiveFontSize(15)),
                textAlign: TextAlign.right,
              ),
            ),
            value: "صغير",
          ),
          DropdownMenuItem(
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                "وسط",
                style: boldStyle.copyWith(fontSize: setResponsiveFontSize(15)),
                textAlign: TextAlign.right,
              ),
            ),
            value: "وسط",
          ),
          DropdownMenuItem(
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                "كبير",
                style: boldStyle.copyWith(fontSize: setResponsiveFontSize(15)),
                textAlign: TextAlign.right,
              ),
            ),
            value: "كبير",
          ),
        ],
      )),
    );
  }
}
