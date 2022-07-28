// ignore_for_file: missing_return

import 'dart:developer';

import 'package:Tiba_Gates/Presentation/casher/casherEntry_screen.dart';
import 'package:Tiba_Gates/Utilities/Shared/dialogs/invitation_dialog.dart';
import 'package:animate_do/animate_do.dart';
import '../admin/admin_bottomNav.dart';
import '../game/game_home.dart';
import '../game/memberInfo.dart';

import '../../Utilities/Shared/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import '../../Utilities/connectivityStatus.dart';
import 'package:lottie/lottie.dart';
import 'entryScreen.dart';
import 'g_home_screen.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'guardPrint_Screen.dart';
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
  bool ifScanned = false;
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

  void adminCheckInvitation(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_LONG);
    controller.dispose();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BottomNav(
                  comingIndex: 3,
                )));
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

        if (widget.screen == 'invitation' ||
            widget.screen == 'invitation_admin') {
          Provider.of<VisitorProv>(context, listen: false)
              .checkInvitationValidation(result)
              .then((value) {
            if (value == 'vip') {
              if (widget.screen == 'invitation_admin') {
                // hna
                showDialog(
                    context: context,
                    builder: (context) {
                      return const InvitationDialog();
                    });

                log('invitation_admin ');
                //adminCheckInvitation('VIP Invitation');
              } else {
             showToast('مرحباً بك');
                controller.dispose();
                navigateReplacementTo(context, const PrintScreen(
                  from: 'send',
                  resendType: 'VIP Invitation',
                ));

              }
            } else if (value == 'not valid') {
              if (widget.screen == 'invitation_admin') {
                adminCheckInvitation('كود غير صحيح');
              } else {
            showToast('كود غير صحيح');
                controller.dispose();
                navigateReplacementTo(context, const EntryScreen());

              }
            } else if (value == 'not vip') {
              if (widget.screen == 'invitation_admin') {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const InvitationDialog();
                    });

              } else {
                showToast('كود صحيح , مرحباً بك');
                controller.dispose();

                Provider.of<VisitorProv>(context, listen: false)
                    .getBill(
                        Provider.of<VisitorProv>(context, listen: false)
                            .ownerId
                            .toString(),
                        '0',
                        '0')
                    .then((value) {
                      navigateTo(context,PrintScreen(
                        civilCount: 0,
                        militaryCount: 0,
                        from: 'send',
                        resendType: 'Normal',
                        typeId: Provider.of<VisitorProv>(context,
                            listen: false)
                            .ownerId
                            .toString(),
                      ) );                });
              }
            } else {
              if (widget.screen == 'invitation_admin') {
                adminCheckInvitation('كود غير صحيح');
              } else {
                debugPrint('value is $value');
            showToast('كود غير صحيح');
                controller.dispose();
                navigateReplacementTo(context, const EntryScreen());

              }
            }
          });
        } else if (widget.screen == 'memberShip' ||
            widget.screen == 'memberShip_admin') {
          log('memberShip');

          Provider.of<VisitorProv>(context, listen: false)
              .checkMemberShipValidation(result)
              .then((value) async {
            log('value is $value');

            if (widget.screen == 'memberShip_admin') {
              log('memberShip Admin');
              if (value == 'Success') {
                controller.dispose();
                navigateReplacementTo(context,const MemberInformation(
                  screen: 'admin',
                ) );

              } else if (value.toString().contains('منتهية')) {

                debugPrint('value is $value');
                showToast(value);
                navigateReplacementTo(context,BottomNav(
                  comingIndex: 3,
                ) );

              } else {
                debugPrint('value is $value');
                showToast('كود غير صحيح');
                navigateReplacementTo(context,BottomNav(
                  comingIndex: 3,
                ) );

              }
            } else {
              if (value == 'Success') {
                navigateReplacementTo(context,HomeScreen(
                  screen: 'memberShip',
                  memberShipModel: Provider.of<VisitorProv>(context,
                      listen: false)
                      .memberShipModel,
                ) );

              } else if (value.toString().contains('منتهية')) {
                debugPrint('value is $value');
              showToast(value);
                navigateReplacementTo(context,const EntryScreen() );
              } else {
                debugPrint('value is $value');
                showToast('كود غير صحيح');
                navigateReplacementTo(context,const EntryScreen() );

              }
            }
          });
        } else if (widget.screen == 'sports' ||
            widget.screen == 'sports_casher') {
          log('sports');

          Provider.of<VisitorProv>(context, listen: false)
              .checkMemberShipValidation(result)
              .then((value) async {
            log('value is $value');
            if (value == 'Success') {
              if (widget.screen == 'sports_casher') {
                controller.dispose();
                navigateReplacementTo(
                    context, const MemberInformation(screen: 'casher'));
              } else {
                controller.dispose();
                navigateReplacementTo(context, const MemberInformation());
              }
            } else if (value.toString().contains('منتهية')) {
              print('value is $value');
              Fluttertoast.showToast(
                  msg: value,
                  backgroundColor: Colors.green,
                  toastLength: Toast.LENGTH_LONG);

              if (widget.screen == 'sports_casher') {
                navigateReplacementTo(context, const CasherEntryScreen());
              } else {
                navigateReplacementTo(context, const GameHome());
              }
            } else {
              print('value =  $value');
              Fluttertoast.showToast(
                  msg: 'كود غير صحيح',
                  backgroundColor: Colors.green,
                  toastLength: Toast.LENGTH_LONG);

              if (widget.screen == 'sports_casher') {
                navigateReplacementTo(context, const CasherEntryScreen());
              } else {
                navigateReplacementTo(context, const GameHome());
              }
            }
          });
        } else {
          Provider.of<VisitorProv>(context, listen: false)
              .checkOut(result)
              .then((value) async {
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
            } else if (value is! String && value != null) {
              print('in time ${value.inTime}');

              await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => ZoomIn(
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          elevation: 16,
                          child: SizedBox(
                            height: 800.h,
                            width: 900.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2.w, color: Colors.green)),
                                  child: Qr(
                                    data: value.qrCode ?? 'abc',
                                    size: 270.0.w,
                                    version: QrVersions.auto,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.h, horizontal: 60.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${value.inTime.toString().substring(0, 10)}   ${value.inTime.toString().substring(11)}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: setResponsiveFontSize(28),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                      Flexible(
                                        child: Text('وقت الدخول              ',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(30),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 60.w),
                                  child: Divider(
                                    thickness: 1,
                                    height: 2.h,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.h, horizontal: 60.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${value.outTime.toString().substring(0, 10)}   ${value.outTime.toString().substring(11)}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: setResponsiveFontSize(28),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                      Flexible(
                                        child: Text('وقت الخروج              ',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(30),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 60.w),
                                  child: Divider(
                                    thickness: 1,
                                    height: 2.h,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.h, horizontal: 60.w),
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('الإجمالى :             ',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(30),
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          '${value.total}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize:
                                                  setResponsiveFontSize(30),
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 60.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RoundedButton(
                                          ontap: () {
                                            controller.dispose();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PrintScreen(
                                                          perHourObj: value,
                                                          from: 'send',
                                                          resendType: 'perHour',
                                                          logId: value.id,
                                                        )));
                                          },
                                          title: 'إستمرار',
                                          height: 60,
                                          width: 220,
                                          buttonColor: ColorManager.primary,
                                          titleColor:
                                              ColorManager.backGroundColor,
                                        ),
                                        SizedBox(
                                          width: 16.w,
                                        ),
                                        RoundedButton(
                                          ontap: () {
                                            Navigator.pop(context);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const EntryScreen()));
                                          },
                                          title: 'إلغاء',
                                          width: 220,
                                          height: 60,
                                          buttonColor: Colors.red,
                                          titleColor:
                                              ColorManager.backGroundColor,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
            } else {
              print('value is $value');
              Fluttertoast.showToast(
                      msg: value,
                      backgroundColor: Colors.green,
                      toastLength: Toast.LENGTH_LONG)
                  .then((value) {
                Future.delayed(const Duration(seconds: 1)).whenComplete(() {
                  scanned = false;
                });
              });
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: InkWell(
            onTap: () {
              if (widget.screen == 'sports') {
                navigateReplacementTo(context, const GameHome());
              } else if (widget.screen == 'memberShip_admin') {
                navigateReplacementTo(context, BottomNav(
                  comingIndex: 3,
                ));
              } else if (widget.screen == 'invitation_admin') {
                navigateReplacementTo(context, BottomNav(
                  comingIndex: 3,
                ));
              } else if (widget.screen == 'sports_casher') {
                navigateReplacementTo(context, const CasherEntryScreen());
              } else {
                navigateReplacementTo(context, const EntryScreen());
              }
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
            )),
      ),
      body: connectionStatus == ConnectivityStatus.Offline
          ? Center(
              child: SizedBox(
              height: 400.h,
              width: 400.w,
              child: Lottie.asset('assets/lotties/noInternet.json'),
            ))
          : WillPopScope(
              onWillPop: () {
                if (widget.screen == 'sports') {
                  navigateReplacementTo(context, const GameHome());
                } else if (widget.screen == 'memberShip_admin') {
                  navigateReplacementTo(context, BottomNav(
                    comingIndex: 3,
                  ));
                } else if (widget.screen == 'invitation_admin') {
                  navigateReplacementTo(context, BottomNav(
                    comingIndex: 3,
                  ));
                } else if (widget.screen == 'sports_casher') {
                  navigateReplacementTo(context, const CasherEntryScreen());
                } else {
                  navigateReplacementTo(context, const EntryScreen());
                }
              },
              child: Column(
                children: <Widget>[
                  Expanded(child: _buildQrView(context)),
                ],
              ),
            ),
    );
  }
}
