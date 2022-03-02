import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/Shared/camera.dart';
import '../../Utilities/Shared/dialogs/bill_dialog.dart';
import '../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import '../../ViewModel/guard/visitorProv.dart';
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
import 'package:path/path.dart' as nPath;
import 'package:provider/provider.dart';
import '../../print_page2.dart';

List<CameraDescription> cameras = [];

class HomeScreen extends StatefulWidget {
  static const String routeName = '/Home';
  final screen;
  final CameraDescription camera;


  HomeScreen({Key key, this.screen, this.camera}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>   with WidgetsBindingObserver{
  int _citizensValue = 0;
  int _militaryValue = 0;
  int visitorTypeId;
  var selectedVisitorType;
  var typesListener;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
    typesListener = Provider.of<VisitorProv>(context, listen: false).getVisitorTypes();
    Provider.of<VisitorProv>(context, listen: false).rokhsa = null;
    Provider.of<VisitorProv>(context, listen: false).idCard = null;
  }

  Future<File> testCompressAndGetFile({File file, String targetPath}) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 30,
    );

    return result;
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        // Provider.of<VisitorProv>(context,listen: false).cancel(widget.logId)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const EntryScreen()));
        throw '';
      },
      child: Scaffold(
        body: SafeArea(
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
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
                                    color: ColorManager.primary, width: 2.w),
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
                                      FutureBuilder(
                                          future: typesListener,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child: Platform.isIOS
                                                    ? const CupertinoActivityIndicator()
                                                    : const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      ),
                                              );
                                            } else if (snapshot
                                                    .connectionState ==
                                                ConnectionState.done) {
                                              visitorTypeId ??= Provider.of<VisitorProv>(
                                                            context,
                                                            listen: false)
                                                        .visitorObjects[0]
                                                        .id;

                                              print('type id $visitorTypeId');
                                              return widget.screen !=
                                                      'invitation'
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 1.w)),
                                                      width: 250.w,
                                                      height: 70.h,
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                              child:
                                                                  ButtonTheme(
                                                        alignedDropdown: true,
                                                        child: Container(
                                                            child:
                                                                DropdownButton(
                                                          elevation: 2,
                                                          isExpanded: true,
                                                          items: Provider.of<
                                                                      VisitorProv>(
                                                                  context,
                                                                  listen: false)
                                                              .visitorTypes
                                                              .map((String x) {
                                                            return DropdownMenuItem<
                                                                    String>(
                                                                value: x,
                                                                child: Center(
                                                                  child: Text(
                                                                    x,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            setResponsiveFontSize(
                                                                                25),
                                                                        color: Colors
                                                                            .green,
                                                                        fontFamily:
                                                                            'Almarai'),
                                                                  ),
                                                                ));
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              visitorTypeId = Provider.of<
                                                                          VisitorProv>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .visitorObjects[Provider.of<
                                                                              VisitorProv>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .visitorTypes
                                                                      .indexOf(
                                                                          value)]
                                                                  .id;
                                                              selectedVisitorType =
                                                                  value;

                                                              print(
                                                                  'selected visitor type is $selectedVisitorType');
                                                              print(
                                                                  'selected visitor type id is $visitorTypeId');
                                                            });
                                                          },
                                                          value: selectedVisitorType ??
                                                              Provider.of<VisitorProv>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .visitorTypes[0],
                                                        )),
                                                      )),
                                                    )
                                                  : Text('دعوة',
                                                      style: TextStyle(
                                                          fontSize:
                                                              setResponsiveFontSize(
                                                                  28),
                                                          color: Colors.green,
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
                                            fontSize: setResponsiveFontSize(28),
                                            fontWeight: FontManager.bold),
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
                                widget.screen != 'invitation'
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 60.w, vertical: 20.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                          FontWeight.w400),
                                                ),
                                                NumberPicker(
                                                  value: _militaryValue,
                                                  minValue: 0,
                                                  selectedTextStyle: TextStyle(
                                                      color: Colors.green,
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              30),
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                          FontWeight.w400),
                                                ),
                                                NumberPicker(
                                                  value: _citizensValue,
                                                  minValue: 0,
                                                  selectedTextStyle: TextStyle(
                                                      color: Colors.green,
                                                      fontSize:
                                                          setResponsiveFontSize(
                                                              30),
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize:
                                                      setResponsiveFontSize(26),
                                                  fontWeight: FontManager.bold),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                widget.screen != 'invitation'
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 60.w),
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: Row(
                                      children: [
                                        AutoSizeText(
                                          'رخصة السيارة      ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize:
                                                  setResponsiveFontSize(28),
                                              fontWeight: FontManager.bold),
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            cameras = await availableCameras();

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CameraPicker(
                                                          camera: cameras[0],
                                                          instruction: '1',
                                                          dropdownValue:
                                                              selectedVisitorType,
                                                        )));
                                          },
                                          child: const Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.green,
                                            size: 35,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16.w,
                                        ),
                                        Provider.of<VisitorProv>(context,
                                                        listen: true)
                                                    .rokhsa !=
                                                null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 2),
                                                child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40)),
                                                              elevation: 16,
                                                              child: Image.file(
                                                                Provider.of<VisitorProv>(
                                                                        context,
                                                                        listen:
                                                                            true)
                                                                    .rokhsa,
                                                                width: 600.w,
                                                                height: 600.h,
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
                                                          width: 300.w,
                                                          height: 150.h,
                                                          fit: BoxFit.fill,
                                                        ),
                                                        Positioned(
                                                          left: 4.w,
                                                          top: 4.w,
                                                          child: InkWell(
                                                            onTap: () {
                                                              print('deleted');
                                                              Provider.of<VisitorProv>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .deleteRokhsa();
                                                            },
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .solidWindowClose,
                                                              color: Colors
                                                                  .grey[500],
                                                              size: 35,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 60.w),
                                  child: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: Row(
                                      children: [
                                        AutoSizeText(
                                          'تحقيق الشخصية',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize:
                                                  setResponsiveFontSize(28),
                                              fontWeight: FontManager.bold),
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            cameras = await availableCameras();

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CameraPicker(
                                                          camera: cameras[0],
                                                          instruction: '2',
                                                          dropdownValue:
                                                              selectedVisitorType,
                                                        )));
                                          },
                                          child: const Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.green,
                                            size: 35,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16.w,
                                        ),
                                        Provider.of<VisitorProv>(context,
                                                        listen: true)
                                                    .idCard !=
                                                null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 2),
                                                child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40)),
                                                              elevation: 16,
                                                              child: Image.file(
                                                                Provider.of<VisitorProv>(
                                                                        context,
                                                                        listen:
                                                                            true)
                                                                    .idCard,
                                                                width: 600.w,
                                                                height: 600.h,
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
                                                          width: 300.w,
                                                          height: 150.h,
                                                          fit: BoxFit.fill,
                                                        ),
                                                        Positioned(
                                                          left: 4.w,
                                                          top: 4.w,
                                                          child: InkWell(
                                                            onTap: () {
                                                              print('deleted');
                                                              Provider.of<VisitorProv>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .deleteId();
                                                            },
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .solidWindowClose,
                                                              color: Colors
                                                                  .grey[500],
                                                              size: 35,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                                (Provider.of<VisitorProv>(context, listen: true)
                                                .idCard !=
                                            null &&
                                        Provider.of<VisitorProv>(context,
                                                    listen: true)
                                                .rokhsa !=
                                            null)
                                    ? RoundedButton(
                                        width: 220,
                                        height: 60,
                                        ontap: () async {
                                          showLoaderDialog(
                                              context, 'Loading...');



                                          widget.screen == 'invitation'
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PrintScreen2(
                                                            civilCount: 0,
                                                            militaryCount: 0,resendType: 'Normal',from: 'send',
                                                          )))



                                              : Provider.of<VisitorProv>(
                                                      context,
                                                      listen: false)
                                                  .getBill(
                                                      visitorTypeId.toString(),
                                                      _citizensValue.toString(),
                                                      _militaryValue.toString())
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
                                        },
                                        title: 'إستمرار',
                                        buttonColor: ColorManager.primary,
                                        titleColor:
                                            ColorManager.backGroundColor,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}