import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'entry_screen/entryScreen.dart';
import 'home_screen/g_home_screen.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'print_page2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:ui' as ui;

import '../../Utilities/Shared/dialogs/successDialog.dart';

class QrCodeScreen extends StatefulWidget {
  final screen;

  const QrCodeScreen({Key key, this.screen}) : super(key: key);

  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  var result;
  var ifScanned = false;
  QRViewController controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    bool scanned = false;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData.code;
      if (!scanned) {
        scanned = true;

        if (widget.screen == 'invitation') {
          Provider.of<VisitorProv>(context, listen: false)
              .checkOutInvitation(result)
              .then((value) {
            if (value == 'vip') {
              Fluttertoast.showToast(
                  msg: 'مرحباً بك',
                  backgroundColor: Colors.green,
                  toastLength: Toast.LENGTH_LONG);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrintScreen2(  from: 'send',resendType: 'VIP Invitation',)));
            }




            else if (value == 'Success') {
              Fluttertoast.showToast(
                  msg: 'كود صحيح , مرحباً بك',
                  backgroundColor: Colors.green,
                  toastLength: Toast.LENGTH_LONG);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(screen: 'invitation',)));
            } else {
              print('value is $value');
              Fluttertoast.showToast(
                  msg: 'كود غير صحيح',
                  backgroundColor: Colors.green,
                  toastLength: Toast.LENGTH_LONG);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EntryScreen()));
            }
          });
        } else {
          Provider.of<VisitorProv>(context, listen: false)
              .checkOut(result)
              .then((value) {
            if (value == 'Success') {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const invitationSendDialog(
                      text: 'تم تسجيل الخروج بنجاح',
                    );
                  });
              Future.delayed(const Duration(seconds: 1)).whenComplete(() {
                Navigator.pop(context);
                scanned = false;
              });
            } else {
              print('value is $value');
              Fluttertoast.showToast(
                      msg: 'كود غير صحيح',
                      backgroundColor: Colors.green,
                      toastLength: Toast.LENGTH_LONG)
                  .then((value) {
                Future.delayed(const Duration(seconds: 1)).whenComplete(() {
                  scanned = false;
                });
              });

              /*  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EntryScreen()));*/
            }
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(result?.code);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) => EntryScreen()));
              },
              child: const Icon(
                Icons.arrow_back,
                size: 30,
              )),
        ),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => EntryScreen()));
            throw '';
          },
          child: Column(
            children: <Widget>[
              Expanded(child: _buildQrView(context)),
            ],
          ),
        ),
      ),
    );
  }
}
