import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Qr extends StatelessWidget {
  String data;
  int version;
  double size;

  Qr({Key key, this.data, this.size, this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          QrImage(
            data: data,
            version: version,
            size: size,
          ),
        ],
      ),
    );
  }
}