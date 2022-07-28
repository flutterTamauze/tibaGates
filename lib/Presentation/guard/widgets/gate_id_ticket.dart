import 'package:Tiba_Gates/Utilities/Constants/constants.dart';
import 'package:Tiba_Gates/ViewModel/guard/visitorProv.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GateID extends StatelessWidget {
  const GateID({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      'G-${Provider.of<VisitorProv>(context, listen: true).logId}',
      style: TextStyle(
          fontSize:
          setResponsiveFontSize(
              36),
          fontWeight:
          FontWeight
              .bold),
    );
  }
}
