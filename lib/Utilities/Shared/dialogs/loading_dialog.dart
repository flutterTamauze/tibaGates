import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context, String text) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        Platform.isIOS
            ? CupertinoActivityIndicator()
            : CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
        Container(margin: const EdgeInsets.only(left: 7), child: Text(text)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
