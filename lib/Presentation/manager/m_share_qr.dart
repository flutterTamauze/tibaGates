import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:clean_app/Presentation/manager/m_home_screen.dart';
import 'package:clean_app/Utilities/Constants/constants.dart';
import 'package:clean_app/ViewModel/manager/managerProv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../Utilities/Shared/qr.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class MShareQr extends StatefulWidget {
  const MShareQr({Key key}) : super(key: key);

  @override
  _MShareQrState createState() => _MShareQrState();
}

class _MShareQrState extends State<MShareQr> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MHomeScreen()));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: ZoomIn(
          child: FloatingActionButton(
            onPressed: () async {
              final byteImage = await screenshotController.captureFromWidget(Qr(
                version: QrVersions.auto,
                data: Provider.of<ManagerProv>(context, listen: false).qrCode ??
                    'abc',
                size: 250.0,
              ));
              final directory = await getApplicationDocumentsDirectory();
              final image = File('${directory.path}/qr.png');
              image.writeAsBytesSync(byteImage);
              final text = 'You are welcome to spend nice time ';
              await Share.shareFiles([image.path], text: text);
            },
            backgroundColor: Colors.green,
            child: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 400.h,),
                Screenshot(
                  controller: screenshotController,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.w, color: Colors.green)),
                          child: Qr(
                            data: Provider.of<ManagerProv>(context, listen: true)
                                    .qrCode ??
                                'abc',
                            size: 350.0.w,
                            version: QrVersions.auto,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
