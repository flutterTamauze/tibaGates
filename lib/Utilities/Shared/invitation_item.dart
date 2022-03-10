import 'dart:io';
import 'dart:typed_data';

import '../../Data/Models/manager/invitation_model.dart';
import 'qr.dart';
import '../../ViewModel/manager/managerProv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../Constants/constants.dart';
import '../Fonts/fontsManager.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvitationItem extends StatefulWidget {
  final Invitation invitation;

  const InvitationItem({Key key, this.invitation}) : super(key: key);

  @override
  _InvitationItemState createState() => _InvitationItemState();
}

class _InvitationItemState extends State<InvitationItem> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        // height: 200.h,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.invitation.creationDate,
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(20),
                          color: Colors.red,
                          fontWeight: FontManager.bold),
                    ),
                    Text(
                      'G-${widget.invitation.id}',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(26),
                          fontWeight: FontManager.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 70.h,width: 70.w,
                      child: Image.asset(widget.invitation.status == 0
                          ? 'assets/images/refused.png'
                          : widget.invitation.status == 1
                              ? 'assets/images/historicalbrief.png'
                              : 'assets/images/done.png'),
                    ),
                    RichText(
                      text: TextSpan(
                        text: widget.invitation.visitorName,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: setResponsiveFontSize(30),
                            fontWeight: FontManager.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' : اسم المدعو ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: setResponsiveFontSize(32),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                ExpandablePanel(
                  expanded: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2.w, color: Colors.green)),
                            child: Screenshot(
                              controller: screenshotController,
                              child: Qr(
                                data: widget.invitation.qrCode ?? 'abc',
                                size: 200.0.w,
                                version: QrVersions.auto,
                              ),
                            ),
                          ),
                          onTap: ()async{
                            Uint8List byteImage = await screenshotController.captureFromWidget(Qr(
                            version: QrVersions.auto,
                            data: Provider.of<ManagerProv>(context, listen: false).qrCode ??'abc',
                            size: 250.0,
                          ));
                          Directory directory = await getApplicationDocumentsDirectory();
                           File image = File('${directory.path}/qr.png');
                          image.writeAsBytesSync(byteImage);
                          const String text = 'You are welcome to spend nice time ';
                          await Share.shareFiles([image.path], text: text);},
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.invitation.visitorDescription,
                                style: TextStyle(
                                    fontSize: setResponsiveFontSize(22),
                                    color: Colors.green,
                                    fontWeight: FontManager.bold),
                              ),
                            ),
                            Text(
                              'الوصف',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: setResponsiveFontSize(20),
                              ),
                              softWrap: true,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.invitation.inTime != ''
                                  ? widget.invitation.inTime
                                  : 'لم يتم الدخول بعد',
                              style: TextStyle(
                                  fontSize: setResponsiveFontSize(22),
                                  color: Colors.green,
                                  fontWeight: FontManager.bold),
                            ),
                            Text('تاريخ الدخول',
                                softWrap: true,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: setResponsiveFontSize(20),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.invitation.outTime != ''
                                  ? widget.invitation.outTime
                                  : 'لم يتم الخروج بعد',
                              style: TextStyle(
                                  fontSize: setResponsiveFontSize(22),
                                  color: Colors.green,
                                  fontWeight: FontManager.bold),
                            ),
                            Text(
                              'تاريخ الخروج',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: setResponsiveFontSize(20),
                              ),
                              softWrap: true,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  collapsed: null,
                  header: SizedBox(
                    height: 1.h,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
