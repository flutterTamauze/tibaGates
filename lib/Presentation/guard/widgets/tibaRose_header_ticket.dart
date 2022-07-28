import '../../../Utilities/Constants/constants.dart';
import '../../../Utilities/Fonts/fontsManager.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TibaRoseHeader extends StatelessWidget {
  const TibaRoseHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        'دار الدفاع الجوى - التجمع الخامس',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            fontSize:
            setResponsiveFontSize(
                26),
            fontWeight:
            FontManager.bold));
  }
}
