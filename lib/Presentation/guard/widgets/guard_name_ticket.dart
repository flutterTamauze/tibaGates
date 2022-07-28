import 'package:Tiba_Gates/Utilities/Constants/constants.dart';
import 'package:Tiba_Gates/Utilities/Fonts/fontsManager.dart';
import 'package:Tiba_Gates/ViewModel/guard/authProv.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GuardName extends StatelessWidget {
  const GuardName({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      'Guard Name : ${Provider.of<AuthProv>(context, listen: true).guardName}',
      textAlign: TextAlign.start,
      style: TextStyle(
          color: Colors.black,
          fontSize:
          setResponsiveFontSize(
              26),
          fontWeight:
          FontManager.bold),
    );
  }
}
