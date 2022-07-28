import 'dart:io';
import 'package:animate_do/animate_do.dart';
import '../admin/admin_bottomNav.dart';
import '../admin/a_invitations_screen.dart';
import 'm_home_screen.dart';
import '../../Utilities/connectivityStatus.dart';
import '../../ViewModel/manager/managerProv.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../Utilities/Shared/qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class MShareQr extends StatefulWidget {
  final String role;
  const MShareQr({Key key, this.role}) : super(key: key);

  @override
  _MShareQrState createState() => _MShareQrState();
}

class _MShareQrState extends State<MShareQr> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);

    return WillPopScope(
      onWillPop: () {
        if (widget.role == 'Admin') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNav(
                        comingIndex: 1,
                      )));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MHomeScreen()));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading:  InkWell(
                  onTap: () {
                    if (widget.role == 'Admin') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNav(
                                    comingIndex: 1,
                                  )));
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MHomeScreen()));
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios))

        ),
        floatingActionButton: ZoomIn(
          child: FloatingActionButton(
            onPressed: () async {
              var byteImage = await screenshotController.captureFromWidget(Container(
                height: 400.h,
                width: 400.w,
                color: Colors.white,
                child: Column(
                  children: [
                    const Spacer(),
                    Qr(
                      version: QrVersions.auto,
                      data: Provider.of<ManagerProv>(context, listen: false)
                              .qrCode ??
                          'abc',
                      size: 250.0,
                    ),
                  ],
                ),
              ));
              var directory = await getApplicationDocumentsDirectory();
              var image = File('${directory.path}/qr.png');
              image.writeAsBytesSync(byteImage);
              const String text =
                  'تسعدنا زيارتك فى دار الدفاع الجوى بالتجمع الخامس';
              print('5 ${image.path}');
              await Share.shareFiles([image.path], text: text);
            },
            backgroundColor: Colors.green,
            child: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ),
        body: connectionStatus == ConnectivityStatus.Offline
            ? Center(
                child: SizedBox(
                height: 400.h,
                width: 400.w,
                child: Lottie.asset('assets/lotties/noInternet.json'),
              ))
            : SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Screenshot(
                      controller: screenshotController,
                      child: Center(
                        child: Container(
                            color: Colors.white,
                            child: Qr(
                              data: Provider.of<ManagerProv>(context,
                                          listen: true)
                                      .qrCode ??
                                  'abc',
                              size: 300.0,
                              version: QrVersions.auto,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
