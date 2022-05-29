import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../Data/Models/guard/memberChip_model.dart';
import '../../../Utilities/responsive.dart';
import '../../../ViewModel/guard/authProv.dart';
import '../../../Utilities/Colors/colorManager.dart';
import '../../../Utilities/Constants/constants.dart';
import '../../../Utilities/Fonts/fontsManager.dart';
import '../../../Utilities/Shared/camera.dart';
import '../../../Utilities/Shared/dialogs/bill_dialog.dart';
import '../../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../../Utilities/Shared/sharedWidgets.dart';
import '../../../Utilities/connectivityStatus.dart';
import '../../../ViewModel/guard/visitorProv.dart';
import 'package:lottie/lottie.dart';
import '../../../main.dart';
import '../../admin/admin_bottomNav.dart';
import '../print_page2.dart';
import '../entry_screen/entryScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';

List<CameraDescription> cameras = [];

class HomeScreen extends StatefulWidget {
  static const String routeName = '/Home';
  final String screen;
  final MemberShipModel memberShipModel;
  final CameraDescription camera;

  const HomeScreen({Key key, this.screen, this.camera, this.memberShipModel})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _citizensValue = 0;
  int _militaryValue = 0;
  int visitorTypeId;
  final ImagePicker picker = ImagePicker();
  bool isPerHour = false;
  String selectedVisitorType;
  Future typesListener;
  CameraController _controller;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    typesListener =
        Provider.of<VisitorProv>(context, listen: false).getVisitorTypes();
    Provider.of<VisitorProv>(context, listen: false).rokhsa = null;
    Provider.of<VisitorProv>(context, listen: false).idCard = null;
  }

  Future<File> testCompressAndGetFile({File file, String targetPath}) async {
    File result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 30,
    );

    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);
    var visitorProv = Provider.of<VisitorProv>(context, listen: true);
    var defVisitorProv = Provider.of<VisitorProv>(context, listen: false);
    var authProv = Provider.of<AuthProv>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        prefs.getString('role') != 'Admin'
            ? Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const EntryScreen()))
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomNav(
                          comingIndex: 3,
                        )));
      },
      child: Scaffold(
        body: connectionStatus == ConnectivityStatus.Offline
            ? Center(
                child: SizedBox(
                height: 400.h,
                width: 400.w,
                child: Lottie.asset('assets/lotties/noInternet.json'),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                  child: widget.screen != 'memberShip'
                      ? Container(
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 40.h),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Hero(
                                    tag: 'logo',
                                    child: ZoomIn(
                                      child: SizedBox(
                                        height: (height * 0.15),
                                        width: (width * 0.32),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: ColorManager.primary,
                                                width: 2.w),
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/tipasplash.png')),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  SizedBox(
                                    width: width,
                                    child: Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.h),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 60.w,
                                                  vertical: 20.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  FutureBuilder(
                                                      future: typesListener,
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<dynamic>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Center(
                                                            child: Platform
                                                                    .isIOS
                                                                ? const CupertinoActivityIndicator()
                                                                : const Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                    ),
                                                                  ),
                                                          );
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          visitorTypeId ??=
                                                              Provider.of<VisitorProv>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .visitorObjects[
                                                                      0]
                                                                  .id;

                                                          print(
                                                              'type id $visitorTypeId');
                                                          return widget
                                                                      .screen !=
                                                                  'invitation'
                                                              ? Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .green,
                                                                          width:
                                                                              1.w)),
                                                                  width: 250.w,
                                                                  height: 70.h,
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                          child:
                                                                              ButtonTheme(
                                                                    alignedDropdown:
                                                                        true,
                                                                    child:
                                                                        DropdownButton(
                                                                      elevation:
                                                                          2,
                                                                      isExpanded:
                                                                          true,
                                                                      items: Provider.of<VisitorProv>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .visitorTypes
                                                                          .map((String
                                                                              x) {
                                                                        return DropdownMenuItem<
                                                                                String>(
                                                                            value:
                                                                                x,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                x,
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontSize: setResponsiveFontSize(25), color: Colors.green, fontFamily: 'Almarai'),
                                                                              ),
                                                                            ));
                                                                      }).toList(),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          visitorTypeId = Provider.of<VisitorProv>(context, listen: false)
                                                                              .visitorObjects[Provider.of<VisitorProv>(context, listen: false).visitorTypes.indexOf(value)]
                                                                              .id;

                                                                          selectedVisitorType =
                                                                              value;

                                                                          if (selectedVisitorType ==
                                                                              'المحاسبه بالساعه') {
                                                                            isPerHour =
                                                                                true;
                                                                          } else {
                                                                            isPerHour =
                                                                                false;
                                                                          }

                                                                          print(
                                                                              'selected visitor type is $selectedVisitorType');
                                                                          print(
                                                                              'selected visitor type id is $visitorTypeId');
                                                                        });
                                                                      },
                                                                      value: selectedVisitorType ??
                                                                          Provider.of<VisitorProv>(context, listen: false)
                                                                              .visitorTypes[0],
                                                                    ),
                                                                  )),
                                                                )
                                                              : AutoSizeText(
                                                                  'دعوة',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          setResponsiveFontSize(
                                                                              28),
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontManager
                                                                              .bold));
                                                        }
                                                        return Container();
                                                      }),
                                                  AutoSizeText(
                                                    ' : نوع الزائر',
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize:
                                                            setResponsiveFontSize(
                                                                28),
                                                        fontWeight:
                                                            FontManager.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 60.w,
                                              ),
                                              child: Divider(
                                                thickness: 1,
                                                height: 2.h,
                                                color: Colors.green,
                                              ),
                                            ),
                                            (widget.screen != 'invitation' &&
                                                    isPerHour == false)
                                                ? Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                isTab(context)
                                                                    ? 60.w
                                                                    : 40.w,
                                                            vertical: 20.h),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            AutoSizeText(
                                                              'عسكرى',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      setResponsiveFontSize(
                                                                          28),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            NumberPicker(
                                                              value:
                                                                  _militaryValue,
                                                              minValue: 0,
                                                              selectedTextStyle: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize:
                                                                      setResponsiveFontSize(
                                                                          30),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              maxValue: 30,
                                                              onChanged: (value) =>
                                                                  setState(() =>
                                                                      _militaryValue =
                                                                          value),
                                                            ),
                                                            AutoSizeText(
                                                              'مدنى',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      setResponsiveFontSize(
                                                                          28),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            NumberPicker(
                                                              value:
                                                                  _citizensValue,
                                                              minValue: 0,
                                                              selectedTextStyle: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize:
                                                                      setResponsiveFontSize(
                                                                          30),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              maxValue: 30,
                                                              onChanged: (value) =>
                                                                  setState(() =>
                                                                      _citizensValue =
                                                                          value),
                                                            ),
                                                          ],
                                                        ),
                                                        AutoSizeText(
                                                          ' : المرافقين',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  setResponsiveFontSize(
                                                                      26),
                                                              fontWeight:
                                                                  FontManager
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                            (widget.screen != 'invitation' &&
                                                    isPerHour == false)
                                                ? Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 60.w),
                                                    child: Divider(
                                                      thickness: 1,
                                                      height: 2.h,
                                                      color: Colors.green,
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 60.w),
                                              child: Directionality(
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                child: Row(
                                                  children: [
                                                    AutoSizeText(
                                                      'رخصة السيارة      ',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize:
                                                              setResponsiveFontSize(
                                                                  28),
                                                          fontWeight:
                                                              FontManager.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        cameras =
                                                            await availableCameras();

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CameraPicker(
                                                                      camera:
                                                                          cameras[
                                                                              0],
                                                                      instruction:
                                                                          'carId',
                                                                      dropdownValue:
                                                                          selectedVisitorType,
                                                                    )));
                                                      },
                                                      child: const Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        color: Colors.green,
                                                        size: 35,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16.w,
                                                    ),
                                                    Provider.of<VisitorProv>(
                                                                    context,
                                                                    listen:
                                                                        true)
                                                                .rokhsa !=
                                                            null
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2),
                                                            child: InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Dialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                          elevation:
                                                                              16,
                                                                          child:
                                                                              Image.file(
                                                                            Provider.of<VisitorProv>(context, listen: true).rokhsa,
                                                                            width:
                                                                                600.w,
                                                                            height:
                                                                                600.h,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                child: Stack(
                                                                  children: [
                                                                    Image.file(
                                                                      Provider.of<VisitorProv>(
                                                                              context,
                                                                              listen: true)
                                                                          .rokhsa,
                                                                      width:
                                                                          300.w,
                                                                      height:
                                                                          150.h,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                    Positioned(
                                                                      left: 4.w,
                                                                      top: 4.w,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              'deleted');
                                                                          Provider.of<VisitorProv>(context, listen: false)
                                                                              .deleteRokhsa();
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          FontAwesomeIcons
                                                                              .solidWindowClose,
                                                                          color:
                                                                              Colors.grey[500],
                                                                          size:
                                                                              35,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          )
                                                        /*   : Provider.of<VisitorProv>(context,
                                                                  listen: true)
                                                              .memberShipModel !=
                                                          null
                                                      ? (Provider.of<VisitorProv>(
                                                                          context,
                                                                          listen:
                                                                              true)
                                                                      .memberShipModel
                                                                      .carImagePath !=
                                                                  null &&
                                                              !Provider.of<VisitorProv>(
                                                                      context,
                                                                      listen:
                                                                          true)
                                                                  .memberShipModel
                                                                  .carImagePath
                                                                  .contains(
                                                                      'first time'))
                                                          ? Stack(
                                                              children: [
                                                                Image.network(
                                                                  "$BASE_URL${Provider.of<VisitorProv>(context, listen: true).memberShipModel.carImagePath.toString().replaceAll("\\", "/")}",
                                                                  width: 300.w,
                                                                  height: 150.h,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                                Positioned(
                                                                  left: 4.w,
                                                                  top: 4.w,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      print(
                                                                          'deleted');
                                                                      Provider.of<VisitorProv>(
                                                                              context,
                                                                              listen: false)
                                                                          .deleteCarPath();
                                                                    },
                                                                    child: Icon(
                                                                      FontAwesomeIcons
                                                                          .solidWindowClose,
                                                                      color: Colors
                                                                              .grey[
                                                                          500],
                                                                      size: 35,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          : Container()*/
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 60.w),
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
                                                  horizontal: 60.w),
                                              child: Directionality(
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                child: Row(
                                                  children: [
                                                    AutoSizeText(
                                                      'تحقيق الشخصية',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize:
                                                              setResponsiveFontSize(
                                                                  28),
                                                          fontWeight:
                                                              FontManager.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        cameras =
                                                            await availableCameras();

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CameraPicker(
                                                                      camera:
                                                                          cameras[
                                                                              0],
                                                                      instruction:
                                                                          'personId',
                                                                      dropdownValue:
                                                                          selectedVisitorType,
                                                                    )));
                                                      },
                                                      child: const Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        color: Colors.green,
                                                        size: 35,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16.w,
                                                    ),
                                                    Provider.of<VisitorProv>(
                                                                    context,
                                                                    listen:
                                                                        true)
                                                                .idCard !=
                                                            null
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2),
                                                            child: InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Dialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                          elevation:
                                                                              16,
                                                                          child:
                                                                              Image.file(
                                                                            Provider.of<VisitorProv>(context, listen: true).idCard,
                                                                            width:
                                                                                600.w,
                                                                            height:
                                                                                600.h,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                child: Stack(
                                                                  children: [
                                                                    Image.file(
                                                                      Provider.of<VisitorProv>(
                                                                              context,
                                                                              listen: true)
                                                                          .idCard,
                                                                      width:
                                                                          300.w,
                                                                      height:
                                                                          150.h,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                    Positioned(
                                                                      left: 4.w,
                                                                      top: 4.w,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              'deleted');
                                                                          Provider.of<VisitorProv>(context, listen: false)
                                                                              .deleteId();
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          FontAwesomeIcons
                                                                              .solidWindowClose,
                                                                          color:
                                                                              Colors.grey[500],
                                                                          size:
                                                                              35,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          )
                                                        /*  : Provider.of<VisitorProv>(context,
                                                                  listen: true)
                                                              .memberShipModel !=
                                                          null
                                                      ? (Provider.of<VisitorProv>(
                                                                          context,
                                                                          listen:
                                                                              true)
                                                                      .memberShipModel
                                                                      .identityImagePath !=
                                                                  null &&
                                                              !Provider.of<VisitorProv>(
                                                                      context,
                                                                      listen:
                                                                          true)
                                                                  .memberShipModel
                                                                  .carImagePath
                                                                  .contains(
                                                                      'first time'))
                                                          ? Stack(
                                                              children: [
                                                                Image.network(
                                                                  "$BASE_URL${Provider.of<VisitorProv>(context, listen: true).memberShipModel.identityImagePath.toString().replaceAll("\\", "/")}",
                                                                  width: 300.w,
                                                                  height: 150.h,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                                Positioned(
                                                                  left: 4.w,
                                                                  top: 4.w,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      print(
                                                                          'deleted');
                                                                      Provider.of<VisitorProv>(
                                                                              context,
                                                                              listen: false)
                                                                          .deleteIdPath();
                                                                    },
                                                                    child: Icon(
                                                                      FontAwesomeIcons
                                                                          .solidWindowClose,
                                                                      color: Colors
                                                                              .grey[
                                                                          500],
                                                                      size: 35,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container()*/
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            /*    ((visitorProv.idCard != null &&
                                                    visitorProv.rokhsa != null))
                                                ?*/
                                            RoundedButton(
                                              width: 220,
                                              height: 60,
                                              ontap: () async {
                                                /*     if (visitorProv.memberShipModel != null) {
                                                  print('member ship model is not null');

                                                  if (visitorProv.memberShipModel.identityImagePath.contains('first time') &&
                                                      visitorProv.memberShipModel.carImagePath.contains('first time')
                                                          ) {
                                                    print('cc');
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'برجاء إلتقاط الصور أولاً',
                                                        backgroundColor:
                                                            Colors.green,
                                                        toastLength:
                                                            Toast.LENGTH_LONG);
                                                    return;
                                                  }
                                                  print('dd');
                                                }
*/
                                                showLoaderDialog(
                                                    context, 'Loading...');

                                                if (widget.screen ==
                                                    'invitation') {
                                                  debugPrint('INVITATION CASE');
                                                  invitationCase();
                                                } else if (isPerHour == true) {
                                                  debugPrint('PER HOUR CASE');
                                                  perHourCase();
                                                }
                                                /*else if (defVisitorProv
                                                                  .memberShipModel !=
                                                              null &&
                                                          defVisitorProv
                                                                  .rokhsa !=
                                                              null &&
                                                          defVisitorProv
                                                                  .idCard !=
                                                              null &&
                                                          defVisitorProv
                                                              .memberShipModel
                                                              .carImagePath
                                                              .contains(
                                                                  'first time')) {
                                                        debugPrint(
                                                            'MEMBERSHIP UPDATE IMAGES CASE');
                                                        membershipUpdateImagesCase();
                                                      } else if (widget
                                                                  .memberShipModel !=
                                                              null &&
                                                          !defVisitorProv
                                                              .memberShipModel
                                                              .carImagePath
                                                              .contains(
                                                                  'first time')) {
                                                        debugPrint(
                                                            'MEMBERSHIP IMAGES NOT NULL CASE');
                                                        membershipImagesNonNullCase();
                                                      } */
                                                else {
                                                  defVisitorProv
                                                      .getBill(
                                                          visitorTypeId
                                                              .toString(),
                                                          _citizensValue
                                                              .toString(),
                                                          _militaryValue
                                                              .toString())
                                                      .then((value) {
                                                    print('value is $value');
                                                    Navigator.pop(context);
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return BillDialog(
                                                              typeValue:
                                                                  visitorTypeId,
                                                              citizenValue:
                                                                  _citizensValue,
                                                              militaryValue:
                                                                  _militaryValue);
                                                        });
                                                  });
                                                }

                                                /*

                                                widget.screen == 'invitation'
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const PrintScreen2(
                                                                  civilCount: 0,
                                                                  militaryCount:
                                                                      0,
                                                                  resendType:
                                                                      'Normal',
                                                                  from: 'send',
                                                                )))
                                                    : isPerHour == true
                                                        ? defVisitorProv
                                                            .checkInPerHour(
                                                            authProv.userId,
                                                            defVisitorProv
                                                                .rokhsa,
                                                            defVisitorProv
                                                                .idCard,
                                                          )
                                                            .then(
                                                                (value) async {
                                                            if (value.message ==
                                                                'Success') {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          const PrintScreen2(
                                                                            civilCount:
                                                                                0,
                                                                            militaryCount:
                                                                                0,
                                                                            resendType:
                                                                                'perHour',
                                                                            from:
                                                                                'send',
                                                                          )));
                                                            }
                                                          })
                                                        : (widget.memberShipModel != null &&
                                                                Provider.of<VisitorProv>(context, listen: false).rokhsa !=
                                                                    null &&
                                                                Provider.of<VisitorProv>(context, listen: false).idCard !=
                                                                    null)
                                                            ? Provider.of<VisitorProv>(context, listen: false)
                                                                .updateMemberShipImages(
                                                                    widget
                                                                        .memberShipModel
                                                                        .id,
                                                                    Provider.of<VisitorProv>(context, listen: false)
                                                                        .rokhsa,
                                                                    Provider.of<VisitorProv>(context, listen: false)
                                                                        .idCard)
                                                                .then((value) {
                                                                if (value ==
                                                                    'Success') {
                                                                  Provider.of<VisitorProv>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getBill(
                                                                          widget
                                                                              .memberShipModel
                                                                              .ownerTypeId
                                                                              .toString(),
                                                                          '0',
                                                                          '0')
                                                                      .then(
                                                                          (value) {
                                                                    print(
                                                                        'value is $value');
                                                                    Navigator.pop(
                                                                        context);
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return BillDialog(
                                                                              typeValue: widget.memberShipModel.ownerTypeId,
                                                                              citizenValue: 0,
                                                                              militaryValue: 0);
                                                                        });
                                                                  });
                                                                }
                                                              })
                                                            : (widget.memberShipModel != null &&
                                                                    Provider.of<VisitorProv>(context, listen: false).memberShipModel.carImagePath !=
                                                                        null)
                                                                ? Provider.of<VisitorProv>(context, listen: false).getBill(widget.memberShipModel.ownerTypeId.toString(), '0', '0').then(
                                                                    (value) {
                                                                    print(
                                                                        'value is $value');
                                                                    Navigator.pop(
                                                                        context);
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return BillDialog(
                                                                              typeValue: widget.memberShipModel.ownerTypeId.toString(),
                                                                              citizenValue: 0,
                                                                              militaryValue: 0);
                                                                        });
                                                                  })
                                                                : Provider.of<VisitorProv>(context, listen: false)
                                                                    .getBill(
                                                                        visitorTypeId.toString(),
                                                                        _citizensValue.toString(),
                                                                        _militaryValue.toString())
                                                                    .then((value) {
                                                                    print(
                                                                        'value is $value');
                                                                    Navigator.pop(
                                                                        context);
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return BillDialog(
                                                                              typeValue: visitorTypeId,
                                                                              citizenValue: _citizensValue,
                                                                              militaryValue: _militaryValue);
                                                                        });
                                                                  });*/
                                              },
                                              title: 'إستمرار',
                                              buttonColor: ColorManager.primary,
                                              titleColor:
                                                  ColorManager.backGroundColor,
                                            )
                                            // : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 40.h),
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),

                                  /*

                                  Stack(
                                    children: [

                                      SizedBox(
                                        width: 180.w,
                                        height: 180.h,
                                        child: Container(
                                          color: Colors.white,
                                          child: FadeInImage.memoryNetwork(
                                            image:( Provider.of<VisitorProv>(context, listen: true).memberShipModel.memberProfilePath!='empty') ? BASE_URL +
                                                    Provider.of<VisitorProv>(
                                                            context,
                                                            listen: true)
                                                        .memberShipModel
                                                        .memberProfilePath
                                                        .replaceAll(
                                                            '\\', '/') :
                                                'https://rsconsultancy.com/wp-content/themes/consultix/images/no-image-found-360x250.png',
                                            placeholder: kTransparentImage,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        child: InkWell(
                                          onTap: getImage,
                                          child: const CircleAvatar(
                                            radius: 17,
                                            backgroundColor: Colors.green,
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        bottom: 25.h,
                                        left: 145.w,
                                      ),
                                    ],
                                  ),


                                     */

                                  Consumer<VisitorProv>(
                                      builder: (context, message, child) {
                                    return ZoomIn(
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: (height * 0.15),
                                            width: (width * 0.32),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: ColorManager.primary,
                                                    width: 2.w),
                                                image: DecorationImage(
                                                    image: message
                                                                .memberShipModel
                                                                .memberProfilePath ==
                                                            'empty'
                                                        ? const AssetImage(
                                                            'assets/images/avatar.png')
                                                        : NetworkImage(
                                                            message.memberShipModel
                                                                    .memberProfilePath +
                                                                "?v=${Random().nextInt(1000)}",

                                                            /*image??visitorProv
                                                          .memberShipModel
                                                          .memberProfilePath*/
                                                          )),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            child: const InkWell(
                                              //    onTap: getImage,
                                              child: CircleAvatar(
                                                radius: 17,
                                                backgroundColor: Colors.green,
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            bottom: 25.h,
                                            left: 180.w,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: defVisitorProv
                                              .memberShipModel.memberName ??
                                          'مشترك ',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: setResponsiveFontSize(30),
                                          fontWeight: FontManager.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' : اسم المشترك ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize:
                                                  setResponsiveFontSize(32),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width,
                                    child: Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.h),
                                        child: Column(
                                          children: [
                                            defVisitorProv.memberShipModel
                                                        .memberShipSports !=
                                                    null
                                                ? Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 12.w),
                                                          child: AutoSizeText(
                                                            'قائمة إشتراكاتى',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    setResponsiveFontSize(
                                                                        28),
                                                                fontWeight:
                                                                    FontManager
                                                                        .bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 26.h,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12.w),
                                                          child: SizedBox(
                                                            height: defVisitorProv
                                                                        .memberShipModel
                                                                        .memberShipSports
                                                                        .length >
                                                                    3
                                                                ? 350.h
                                                                : 170.h,
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .rtl,
                                                              child: GridView
                                                                  .builder(
                                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                    childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2.5),
                                                                    crossAxisSpacing: Platform.isIOS
                                                                        ? 5.w
                                                                        : isTab(context)
                                                                            ? 2.w
                                                                            : 1.w,
                                                                    mainAxisSpacing: Platform.isIOS ? 7.w : 10.w,
                                                                    crossAxisCount: 3),
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Card(
                                                                    elevation:
                                                                        6,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25.0),
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                AssetImage('assets/images/sportbg2.jpg'),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 10.w,
                                                                              right: 10.w,
                                                                              top: 10.h),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              AutoSizeText(
                                                                                defVisitorProv.memberShipModel.memberShipSports[index].sportName,
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontSize: setResponsiveFontSize(24), color: Colors.white),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 20.w,
                                                                              ),
                                                                              SizedBox(
                                                                                width: isTab(context) ? 160.w : 145.w,
                                                                                child: AutoSizeText(
                                                                                    ''
                                                                                    'ينتهى الإشتراك فى ',
                                                                                    maxLines: 2,
                                                                                    textAlign: TextAlign.end,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: setResponsiveFontSize(16))),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 20.w,
                                                                              ),
                                                                              SizedBox(
                                                                                width: isTab(context) ? 160.w : 145.w,
                                                                                child: AutoSizeText(defVisitorProv.memberShipModel.memberShipSports[index].sportExpireDate, maxLines: 2, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: setResponsiveFontSize(22))),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                itemCount: defVisitorProv
                                                                    .memberShipModel
                                                                    .memberShipSports
                                                                    .length,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : AutoSizeText(
                                                    'لا توجد إشتراكات حالية لهذا العضو ولا يمكنه الدخول',
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize:
                                                            setResponsiveFontSize(
                                                                26),
                                                        fontWeight:
                                                            FontManager.bold),
                                                  ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 60.w),
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
                                                  horizontal: 60.w),
                                              child: Directionality(
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                child: Row(
                                                  children: [
                                                    AutoSizeText(
                                                      'رخصة السيارة      ',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize:
                                                              setResponsiveFontSize(
                                                                  28),
                                                          fontWeight:
                                                              FontManager.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        cameras =
                                                            await availableCameras();

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) => CameraPicker(
                                                                    camera:
                                                                        cameras[
                                                                            0],
                                                                    instruction:
                                                                        'carId',
                                                                    type:
                                                                        'membership',
                                                                    membershipId: widget
                                                                        .memberShipModel
                                                                        .id)));
                                                      },
                                                      child: const Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        color: Colors.green,
                                                        size: 35,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16.w,
                                                    ),
                                                    Provider.of<VisitorProv>(
                                                                    context,
                                                                    listen:
                                                                        true)
                                                                .memberShipModel
                                                                .carImagePath !=
                                                            'empty'
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2),
                                                            child: InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Dialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                          elevation:
                                                                              16,
                                                                          child:
                                                                              Image.network(
                                                                            Provider.of<VisitorProv>(context, listen: true).memberShipModel.carImagePath,
                                                                            loadingBuilder: (BuildContext context,
                                                                                Widget child,
                                                                                ImageChunkEvent loadingProgress) {
                                                                              if (loadingProgress == null) {
                                                                                return child;
                                                                              }
                                                                              return Center(
                                                                                child: CircularProgressIndicator(
                                                                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
                                                                                ),
                                                                              );
                                                                            },
                                                                            width:
                                                                                600.w,
                                                                            height:
                                                                                600.h,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                child: Image
                                                                    .network(
                                                                  Provider.of<VisitorProv>(
                                                                          context,
                                                                          listen:
                                                                              true)
                                                                      .memberShipModel
                                                                      .carImagePath,
                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null) {
                                                                      return child;
                                                                    }
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes
                                                                            : null,
                                                                      ),
                                                                    );
                                                                  },
                                                                  width: 300.w,
                                                                  height: 150.h,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 60.w),
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
                                                  horizontal: 60.w),
                                              child: Directionality(
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                child: Row(
                                                  children: [
                                                    AutoSizeText(
                                                      'تحقيق الشخصية',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize:
                                                              setResponsiveFontSize(
                                                                  28),
                                                          fontWeight:
                                                              FontManager.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        cameras =
                                                            await availableCameras();

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CameraPicker(
                                                                      camera:
                                                                          cameras[
                                                                              0],
                                                                      instruction:
                                                                          'personId',
                                                                      type:
                                                                          'membership',
                                                                      membershipId:
                                                                          widget
                                                                              .memberShipModel
                                                                              .id,
                                                                    )));
                                                      },
                                                      child: const Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        color: Colors.green,
                                                        size: 35,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16.w,
                                                    ),
                                                    Provider.of<VisitorProv>(
                                                                    context,
                                                                    listen:
                                                                        true)
                                                                .memberShipModel
                                                                .identityImagePath !=
                                                            'empty'
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2),
                                                            child: InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Dialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                          elevation:
                                                                              16,
                                                                          child:
                                                                              Image.network(
                                                                            Provider.of<VisitorProv>(context, listen: true).memberShipModel.identityImagePath,
                                                                            loadingBuilder: (BuildContext context,
                                                                                Widget child,
                                                                                ImageChunkEvent loadingProgress) {
                                                                              if (loadingProgress == null) {
                                                                                return child;
                                                                              }
                                                                              return Center(
                                                                                child: CircularProgressIndicator(
                                                                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
                                                                                ),
                                                                              );
                                                                            },
                                                                            width:
                                                                                600.w,
                                                                            height:
                                                                                600.h,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                child: Image
                                                                    .network(
                                                                  Provider.of<VisitorProv>(
                                                                          context,
                                                                          listen:
                                                                              true)
                                                                      .memberShipModel
                                                                      .identityImagePath,
                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null) {
                                                                      return child;
                                                                    }
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes
                                                                            : null,
                                                                      ),
                                                                    );
                                                                  },
                                                                  width: 300.w,
                                                                  height: 150.h,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            /*  ((visitorProv.idCard != null &&
                                                visitorProv.rokhsa !=
                                                    null) ||
                                                (visitorProv.memberShipModel !=
                                                    null &&
                                                    !visitorProv
                                                        .memberShipModel
                                                        .identityImagePath
                                                        .contains(
                                                        'first time')))*/

                                            /*  (!visitorProv.memberShipModel
                                                        .identityImagePath
                                                        .contains('empty') &&
                                                    !visitorProv.memberShipModel
                                                        .carImagePath
                                                        .contains('empty'))
                                                ?*/
                                            prefs.getString('role') != 'Admin'
                                                ? RoundedButton(
                                                    width: 220,
                                                    height: 60,
                                                    ontap: () async {
                                                      if (defVisitorProv
                                                              .memberShipModel
                                                              .memberShipSports ==
                                                          null) {
                                                        navigateTo(context,
                                                            EntryScreen());
                                                        return;
                                                      }

                                                      showLoaderDialog(context,
                                                          'Loading...');

                                                      Provider.of<VisitorProv>(
                                                              context,
                                                              listen: false)
                                                          .getBill(
                                                              widget
                                                                  .memberShipModel
                                                                  .ownerTypeId
                                                                  .toString(),
                                                              '0',
                                                              '0')
                                                          .then((value) {
                                                        debugPrint(
                                                            'value is $value');
                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return BillDialog(
                                                                  typeValue: widget
                                                                      .memberShipModel
                                                                      .ownerTypeId,
                                                                  citizenValue:
                                                                      0,
                                                                  militaryValue:
                                                                      0);
                                                            });
                                                      });

                                                      /*   if (defVisitorProv
                                                    .memberShipModel !=
                                                    null &&
                                                    defVisitorProv
                                                        .rokhsa !=
                                                        null &&
                                                    defVisitorProv
                                                        .idCard !=
                                                        null &&
                                                    defVisitorProv
                                                        .memberShipModel
                                                        .carImagePath
                                                        .contains(
                                                        'first time')) {
                                                  debugPrint(
                                                      'MEMBERSHIP UPDATE IMAGES CASE');
                                                  membershipUpdateImagesCase();
                                                } else if (widget
                                                    .memberShipModel !=
                                                    null &&
                                                    !defVisitorProv
                                                        .memberShipModel
                                                        .carImagePath
                                                        .contains(
                                                        'first time')) {
                                                  debugPrint(
                                                      'MEMBERSHIP IMAGES NOT NULL CASE');
                                                  membershipImagesNonNullCase();
                                                } else {
                                                  defVisitorProv
                                                      .getBill(
                                                      visitorTypeId
                                                          .toString(),
                                                      _citizensValue
                                                          .toString(),
                                                      _militaryValue
                                                          .toString())
                                                      .then((value) {
                                                    print(
                                                        'value is $value');
                                                    Navigator.pop(
                                                        context);
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (context) {
                                                          return BillDialog(
                                                              typeValue:
                                                              visitorTypeId,
                                                              citizenValue:
                                                              _citizensValue,
                                                              militaryValue:
                                                              _militaryValue);
                                                        });
                                                  });
                                                }*/
                                                    },
                                                    title: defVisitorProv
                                                                .memberShipModel
                                                                .memberShipSports !=
                                                            null
                                                        ? 'إستمرار'
                                                        : 'عودة',
                                                    buttonColor:
                                                        ColorManager.primary,
                                                    titleColor: ColorManager
                                                        .backGroundColor,
                                                  )
                                                : RoundedButton(
                                                    width: 220,
                                                    height: 60,
                                                    ontap: () async {
                                                      navigateTo(
                                                          context,
                                                          BottomNav(
                                                            comingIndex: 3,
                                                          ));
                                                    },
                                                    title: 'عودة',
                                                    buttonColor:
                                                        ColorManager.primary,
                                                    titleColor: ColorManager
                                                        .backGroundColor,
                                                  )

                                            //  : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )))),
                ),
              ),
      ),
    );
  }

  String image;

  Future getImage() async {
    //imageCache.clear();
    File pickedImage =
        (await ImagePicker.pickImage(source: ImageSource.gallery));
    if (pickedImage != null) {
      print('profile path is ${pickedImage.path}');
      showLoaderDialog(context, 'جارى رفع الصورة');
      await Provider.of<VisitorProv>(context, listen: false)
          .updateMemberShipImages(
              widget.memberShipModel.id, null, null, pickedImage, 'profile')
          .then((value) async {
        if (value == 'Success') {
          image = Provider.of<VisitorProv>(context, listen: false)
              .memberShipModel
              .memberProfilePath;

          (await NetworkAssetBundle(Uri.parse(image)).load(image))
              .buffer
              .asUint8List();

          print('=prof image is $image');

          Fluttertoast.showToast(
              msg: 'تم التعديل',
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG);
        }
      });

      Navigator.pop(context);
    } else {
      print('No image selected.');
    }
  }

  void invitationCase() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const PrintScreen2(
                  civilCount: 0,
                  militaryCount: 0,
                  resendType: 'Normal',
                  from: 'send',
                )));
  }

  void perHourCase() {
    Provider.of<VisitorProv>(context, listen: false)
        .checkInPerHour(
      Provider.of<AuthProv>(context, listen: false).userId,
      Provider.of<VisitorProv>(context, listen: false).rokhsa,
      Provider.of<VisitorProv>(context, listen: false).idCard,
    )
        .then((value) async {
      if (value.message == 'Success') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PrintScreen2(
                      civilCount: 0,
                      militaryCount: 0,
                      resendType: 'perHour',
                      from: 'send',
                    )));
      }
    });
  }

  void membershipUpdateImagesCase() {
    Provider.of<VisitorProv>(context, listen: false)
        .updateMemberShipImages(
            widget.memberShipModel.id,
            Provider.of<VisitorProv>(context, listen: false).rokhsa,
            Provider.of<VisitorProv>(context, listen: false).idCard)
        .then((value) {
      if (value == 'Success') {
        Provider.of<VisitorProv>(context, listen: false)
            .getBill(widget.memberShipModel.ownerTypeId.toString(), '0', '0')
            .then((value) {
          debugPrint('value is $value');
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) {
                return BillDialog(
                    typeValue: widget.memberShipModel.ownerTypeId,
                    citizenValue: 0,
                    militaryValue: 0);
              });
        });
      }
    });
  }

  void membershipImagesNonNullCase() {
    Provider.of<VisitorProv>(context, listen: false)
        .getBill(widget.memberShipModel.ownerTypeId.toString(), '0', '0')
        .then((value) {
      print('value is $value');
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return BillDialog(
                typeValue: widget.memberShipModel.ownerTypeId.toString(),
                citizenValue: 0,
                militaryValue: 0);
          });
    });
  }
}
