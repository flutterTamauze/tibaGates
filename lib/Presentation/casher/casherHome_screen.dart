import 'dart:io';
import 'package:flutter/scheduler.dart';

import '../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../ViewModel/guard/authProv.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:intl/intl.dart';
import '../../Utilities/Shared/noInternet.dart';
import '../../ViewModel/casher/servicesProv.dart';
import '../../main.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:image/image.dart' as img;
import 'casherEntry_screen.dart';
import 'casherPrint_screen.dart';
import '../../Utilities/Shared/tiba_logo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../Utilities/responsive.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import '../../Utilities/connectivityStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class CasherHomeScreen extends StatefulWidget {
  const CasherHomeScreen({Key key}) : super(key: key);

  @override
  _CasherHomeScreenState createState() => _CasherHomeScreenState();
}

class _CasherHomeScreenState extends State<CasherHomeScreen>
    with WidgetsBindingObserver {
  int _count = 1;
  int serviceTypeId;
  double servicePrice;
  String selectedServiceType;
  String enSelectedServiceType;
  Future servicesListener;
  final PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  bool isScaning = false;
  String _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  PrinterBluetooth myDevice;

  @override
  void initState() {

    if (mounted) {
      //  if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (!mounted) {
          return;
        }
        if (val == 12) {
          print('on');
          initPrinter();
        } else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = 'Bluetooth Disconnect!');
        }
      });
    }

    super.initState();
  }


  void initDropDown(ServicesProv defServiceProv){
    serviceTypeId ??= defServiceProv.serviceObjects[0].id;
    servicePrice ??= defServiceProv.serviceObjects[0].servicePrice;
    selectedServiceType ??= defServiceProv.serviceObjects[0].arServiceName;
    enSelectedServiceType ??= defServiceProv.serviceObjects[0].serviceName;

    debugPrint('type id $serviceTypeId');
    debugPrint('price $servicePrice');
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);
    ServicesProv serviceProv = Provider.of<ServicesProv>(context, listen: true);
    ServicesProv defServiceProv = Provider.of<ServicesProv>(context, listen: false);
    initDropDown(defServiceProv);

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Provider.of<ServicesProv>(context, listen: false).resetPrice();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const CasherEntryScreen()));
      },
      child: Scaffold(
        body: connectionStatus == ConnectivityStatus.Offline
            ? NoInternet()
            : SafeArea(
                child: SingleChildScrollView(
                    child: Container(
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/bg1.jpeg',
                        ),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          TibaLogo(
                            height: height,
                            width: width,
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          SizedBox(
                            width: width,
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 60.w, vertical: 20.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.green,
                                                    width: 1.w)),
                                            width: 300.w,
                                            height: 70.h,
                                            child: DropdownButtonHideUnderline(
                                                child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButton(
                                                elevation: 2,
                                                isExpanded: true,
                                                items: defServiceProv
                                                    .serviceTypes
                                                    .map((String x) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: x,
                                                      child: Center(
                                                        child: Text(
                                                          x,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  setResponsiveFontSize(
                                                                      25),
                                                              color:
                                                                  Colors.green,
                                                              fontFamily:
                                                                  'Almarai'),
                                                        ),
                                                      ));
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    serviceTypeId =
                                                        defServiceProv
                                                            .serviceObjects[
                                                                defServiceProv
                                                                    .serviceTypes
                                                                    .indexOf(
                                                                        value)]
                                                            .id;
                                                    servicePrice = defServiceProv
                                                        .serviceObjects[
                                                            defServiceProv
                                                                .serviceTypes
                                                                .indexOf(value)]
                                                        .servicePrice;
                                                    selectedServiceType =
                                                        defServiceProv
                                                            .serviceObjects[
                                                                defServiceProv
                                                                    .serviceTypes
                                                                    .indexOf(
                                                                        value)]
                                                            .arServiceName;
                                                    enSelectedServiceType =
                                                        defServiceProv
                                                            .serviceObjects[
                                                                defServiceProv
                                                                    .serviceTypes
                                                                    .indexOf(
                                                                        value)]
                                                            .serviceName;

                                                    serviceProv.calcPrice(
                                                        _count, servicePrice);
                                                    debugPrint(
                                                        'selected service type is $selectedServiceType    and $enSelectedServiceType');
                                                    debugPrint(
                                                        'selected service type id is $serviceTypeId');
                                                  });
                                                },
                                                value: selectedServiceType ??
                                                    defServiceProv
                                                        .serviceTypes[0],
                                              ),
                                            )),
                                          ),
                                          AutoSizeText(
                                            ' : نوع الخدمة',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(28),
                                                fontWeight: FontManager.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    buildDivider(),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              isTab(context) ? 60.w : 40.w,
                                          vertical: 20.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Consumer<ServicesProv>(builder:
                                              (context, message, child) {
                                            return SizedBox(
                                              /*           height: (height * 0.15),
                                              width: (width * 0.32),*/
                                              child: AutoSizeText(
                                                message.servicePrice
                                                        .toString() +
                                                    '  LE',
                                                style: TextStyle(
                                                    fontSize:
                                                        setResponsiveFontSize(
                                                            26),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                            );
                                          }),
                                          AutoSizeText(
                                            ' : السعر',
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(28),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          NumberPicker(
                                            value: _count,
                                            minValue: 1,
                                            selectedTextStyle: TextStyle(
                                                color: Colors.green,
                                                fontSize:
                                                    setResponsiveFontSize(30),
                                                fontWeight: FontWeight.bold),
                                            maxValue: 30,
                                            onChanged: (value) => setState(() {
                                              _count = value;
                                              serviceProv.calcPrice(
                                                  _count, servicePrice);
                                            }),
                                          ),
                                          AutoSizeText(
                                            ' : العدد',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize:
                                                    setResponsiveFontSize(26),
                                                fontWeight: FontManager.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    buildDivider(),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    isScaning == true
                                        ? const CircularProgressIndicator()
                                        : ((_devices.isEmpty ||
                                                defServiceProv
                                                    .serviceObjects.isEmpty || myDevice==null)
                                            ? Center(
                                                child: RoundedButton(
                                                width: 220,
                                                height: 60,
                                                ontap: () async {
                                                  setState(() {
                                                    isScaning = true;
                                                  });
                                                  refreshPrinter();
                                                },
                                                title: 'Refresh',
                                                buttonColor:
                                                    ColorManager.primary,
                                                titleColor: ColorManager
                                                    .backGroundColor,
                                              ))
                                            : SizedBox(
                                                height: 70.h,
                                                width: 220.w,
                                                child: (

                                                    myDevice.address ==
                                                         Provider.of<AuthProv>(context,listen: false).printerAddress
                                                        // 'DC:0D:30:CC:27:07'
                                      //                  'DC:0D:30:A0:64:74'
                                                    //  'DC:0D:30:A0:65:A8'

                                                    )
                                                    ? RoundedButton(
                                                        width: 220,
                                                        height: 60,
                                                        ontap: () async {
                                                          showLoaderDialog(
                                                              context,
                                                              'جارى التحميل..');
                                                          serviceProv
                                                              .addBill(
                                                                  serviceTypeId,
                                                                  servicePrice,
                                                                  _count,
                                                                  prefs.getString(
                                                                      'guardId'))
                                                              .then(
                                                                  ((value) async {
                                                            if (value ==
                                                                'Success') {
                                                              Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              1))
                                                                  .whenComplete(
                                                                      () async {

                                                                        PosPrintResult result =  await  _printerManager.printTicket(
                                                                    await casherTicket(
                                                                        PaperSize
                                                                            .mm58),
                                                                    queueSleepTimeMs:
                                                                        50);

                                                                        Navigator.pop(context);
                                                                        print('printing result is ${result.msg}');
                                                                        if (result.msg == 'Success') {
                                                                          showSnakBar(
                                                                              color: Colors.green,
                                                                              context: context,
                                                                              text: result.msg,
                                                                              icon: Icons.done_outline);


                                                                        } else if (result.msg == 'Error. Printer connection timeout') {
                                                                          showSnakBar(
                                                                              color: Colors.red[400],
                                                                              context: context,
                                                                              text: 'Error!! Printer connection timeout',
                                                                              icon: Icons.watch_later_outlined);
                                                                        } else if (result.msg == 'Error. Printer not selected') {
                                                                          showSnakBar(
                                                                              color: Colors.red[400],
                                                                              context: context,
                                                                              text: 'Error!! Printer not selected',
                                                                              icon: Icons.print_disabled_outlined);
                                                                        } else {
                                                                          showSnakBar(
                                                                              color: Colors.red[400],
                                                                              context: context,
                                                                              text: result.msg,
                                                                              icon: Icons.error_outline);
                                                                        }
                                                                        navigateReplacementTo(context, const CasherEntryScreen());

                                                             /*   _startPrint(
                                                                    myDevice);*/
                                                              });
                                                            }
                                                          }));
                                                        },
                                                        title: 'تأكيد',
                                                        buttonColor:
                                                            ColorManager
                                                                .primary,
                                                        titleColor: ColorManager
                                                            .backGroundColor,
                                                      )
                                                    : RoundedButton(
                                                        width: 220,
                                                        height: 60,
                                                        ontap: () async {
                                                          setState(() {
                                                            isScaning = true;
                                                          });
                                                          refreshPrinter();
                                                        },
                                                        title: 'Refresh',
                                                        buttonColor:
                                                            ColorManager
                                                                .primary,
                                                        titleColor: ColorManager
                                                            .backGroundColor,
                                                      ),
                                              ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
      ),
    );
  }

  Padding buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 60.w,
      ),
      child: Divider(
        thickness: 1,
        height: 2.h,
        color: Colors.green,
      ),
    );
  }

  Future<Ticket> casherTicket(PaperSize paper) async {
    final ticket = Ticket(paper);

/*    final ByteData data = await rootBundle.load(
      'assets/images/logoPrint.png',
    );
    final Uint8List bytes = data.buffer.asUint8List();
    final img.Image image = img.decodeImage(
      bytes,
    );
    ticket.image(image, align: PosAlign.center);*/
    ticket.feed(1);


    ticket.text(
      'Tiba Rose Ticketing System',
      styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true,
          fontType: PosFontType.fontA),
    );
    ticket.text('===================',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true,
            fontType: PosFontType.fontA),
        linesAfter: 1);

/*
    Uint8List encArabic1 = await CharsetConverter.encode('UTF-8','احمد');

    ticket.textEncoded(encArabic1,
        styles: const PosStyles(codeTable: PosCodeTable.arabic,));

*/

    ticket.row([
      PosColumn(
        text: 'Date :',
        width: 5,
        styles: const PosStyles(
          bold: true,
        ),
      ),
      PosColumn(
          text: DateFormat('yyyy-MM-dd / hh:mm')
              .format(DateTime.parse(
                  Provider.of<ServicesProv>(context, listen: false).printTime))
              .toString(),
          width: 7,
          styles: const PosStyles(bold: true)),
    ]);

    ticket.row([
      PosColumn(
          text: 'User Name :',
          width: 5,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(
          text: (Provider.of<AuthProv>(context, listen: false).guardName) ??
              '  -  ',
          width: 7,
          styles: const PosStyles(bold: true)),
    ]);

    ticket.row([
      PosColumn(
          text: 'Gate :',
          width: 5,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(
          text: (Provider.of<AuthProv>(context, listen: false).gateName) ??
              '  -  ',
          width: 7,
          styles: const PosStyles(bold: true)),
    ]);

    ticket.text(
      '================================',
      styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true,
          fontType: PosFontType.fontA),
    );

    ticket.feed(1);
    ticket.row([
      PosColumn(
          text: 'Service Name :',
          width: 7,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(
          text: enSelectedServiceType,
          width: 5,
          styles: const PosStyles(bold: true)),
    ]);

    ticket.row([
      PosColumn(
          text: 'Service Fee :',
          width: 7,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(
          text:
              ('${Provider.of<ServicesProv>(context, listen: false).servicePrice / _count}  Le')
                  .toString(),
          width: 5,
          styles: const PosStyles(bold: true)),
    ]);

    ticket.row([
      PosColumn(
          text: 'Count :',
          width: 7,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(
          text: _count.toString(),
          width: 5,
          styles: const PosStyles(bold: true)),
    ]);

    ticket.text('================================',
        styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true,
            fontType: PosFontType.fontA));
    ticket.row([
      PosColumn(
          text: 'Total :',
          width: 5,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(
          text:
              '${Provider.of<ServicesProv>(context, listen: false).servicePrice} Le',
          width: 7,
          styles: const PosStyles(bold: true)),
    ]);
    ticket.feed(1);

    // for small printer
    ticket.qrcode(
      serviceTypeId.toString(),
      size: QRSize.Size8
      // const QRSize(30)
      ,
      align: PosAlign.center,
    );
    //ticket.feed(1);

    ticket.text('S-${Provider.of<ServicesProv>(context, listen: false).billId}',
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true,
            fontType: PosFontType.fontB));
/*    ticket.feed(1);
    ticket.text(
        'Keep the bill to present upon departure \n A fine for losing the bill is 5 pounds',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: false,
          fontType: PosFontType.fontB,
        ));*/

/*
    // for large printer
    ticket.qrcode('abc',size: const QRSize(30),align: PosAlign.center,);

*/

    ticket.cut();

    return ticket;
  }



  Future<void> initPrinter() async {
    _printerManager.startScan(const Duration(seconds: 2));
    _printerManager.scanResults.listen((val) {
      if (!mounted) {
        return;
      }
      setState(() => _devices = val);
      if (_devices.isEmpty) {
        setState(() => _devicesMsg = 'No Devices');
      } else {
        try {
          debugPrint('devices length is ${_devices.length}');
          myDevice = _devices.firstWhere((element) =>
              element.address ==
               Provider.of<AuthProv>(context,listen: false).printerAddress
                  //     'DC:0D:30:A0:65:A8'
           //    'DC:0D:30:A0:64:74'
                  ??''
              );
          _printerManager.selectPrinter(myDevice);
        } catch (ex) {
          debugPrint('ex is $ex');
        }
      }
    });
  }



  void refreshPrinter() {
    bluetoothManager.state.listen((val) {
      print('state = $val');
      setState(() {
        isScaning = false;
      });
      if (!mounted) {
        return;
      }
      if (val == 12) {
        print('on');
        initPrinter();
      } else if (val == 10) {
        print('off');
        setState(() => _devicesMsg = 'Bluetooth Disconnect!');
      }
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);

    PosPrintResult result =
        await _printerManager.printTicket(await casherTicket(
      PaperSize.mm58,
    ));

    Navigator.pop(context);
    print('printing result is ${result.msg}');
    if (result.msg == 'Success') {
      showSnakBar(
          color: Colors.green,
          context: context,
          text: result.msg,
          icon: Icons.done_outline);

/*      _startPrint(
          _devices.firstWhere((device) => device.address == myDevice.address));*/
    } else if (result.msg == 'Error. Printer connection timeout') {
      showSnakBar(
          color: Colors.red[400],
          context: context,
          text: 'Error!! Printer connection timeout',
          icon: Icons.watch_later_outlined);
    } else if (result.msg == 'Error. Printer not selected') {
      showSnakBar(
          color: Colors.red[400],
          context: context,
          text: 'Error!! Printer not selected',
          icon: Icons.print_disabled_outlined);
    } else {
      showSnakBar(
          color: Colors.red[400],
          context: context,
          text: result.msg,
          icon: Icons.error_outline);
    }
    navigateReplacementTo(context, const CasherEntryScreen());
    /*   showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );*/
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }
}
