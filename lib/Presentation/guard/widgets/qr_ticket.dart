import 'package:Tiba_Gates/Utilities/Shared/qr.dart';
import 'package:Tiba_Gates/ViewModel/guard/visitorProv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrTicket extends StatelessWidget {
  const QrTicket({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          border: Border.all(
              width: 2.w,
              color: Colors.green)),
      child: Qr(
        data:
        Provider.of<VisitorProv>(
            context,
            listen:
            true)
            .qrCode ??
            'abc',
        size: 270.0.w,
        version: QrVersions.auto,
      ),
    );
  }
}
