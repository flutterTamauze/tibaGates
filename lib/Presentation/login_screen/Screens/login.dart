import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:camera/camera.dart';

import 'package:clean_app/Presentation/admin/dailyReports_screen.dart';
import 'package:clean_app/Presentation/admin/admin_bottomNav.dart';
import '../../guard/entry_screen/entryScreen.dart';
import '../../manager/m_home_screen.dart';
import '../../../Utilities/Colors/colorManager.dart';
import '../../../Utilities/Constants/constants.dart';
import '../../../Utilities/Shared/sharedWidgets.dart';
import '../../../ViewModel/guard/authProv.dart';
import '../../../ViewModel/manager/managerProv.dart';
import 'package:flutter_udid/flutter_udid.dart';

import '../../../../main.dart';
import '../Widgets/memberDisplay.dart';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as nPath;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

List<CameraDescription> cameras = [];

class LoginScreen extends StatefulWidget {
  static const String routeName = '/intro';
  final CameraDescription camera;

  const LoginScreen({Key key, this.camera}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final _forgetFormKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _memberShipController = TextEditingController();
  CameraController _controller;

  bool isLoggedIn;
  Future<void> _initializeControllerFuture;
  var authProv;
  String _platformVersion;

  String _udid = 'Unknown';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String udid;
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }

    if (!mounted) return;

    setState(() {
      _udid = udid;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    authProv = Provider.of<AuthProv>(context, listen: true);
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/tiba.jpg'),
                        fit: BoxFit.fitHeight)),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: SizedBox(
                        height: (height * 0.15),
                        width: (width * 0.32),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/tipasplash.png')),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: ColorManager.primary, width: 2.w),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BorderedText(
                          strokeWidth: 4.0.w,
                          strokeColor: Colors.black,
                          child: Text(
                            'Tiba Rose دار الدفاع الجوى ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: setResponsiveFontSize(26),
                                decoration: TextDecoration.none,
                                decorationColor: Colors.black,
                                height: 1.5.h,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    SizedBox(
                      height: 36.h,
                    ),
                    Center(
                      child: SizedBox(
                        width: 500.w,
                        height: 400.h,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 4,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Form(
                                  key: _forgetFormKey,
                                  child: Column(
                                    children: <Widget>[
                                      AutoSizeText(
                                        'قم بتسجيل الدخول',
                                        style: TextStyle(
                                            color: ColorManager.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                setResponsiveFontSize(24)),
                                      ),
                                      SizedBox(
                                        height: 25.h,
                                      ),
                                      MemberDisplay(
                                        isLogin: true,
                                        memberShipController:
                                            _memberShipController,
                                        passwordController: _passwordController,
                                      ),
                                      SizedBox(
                                        height: 25.0.h,
                                      ),
                                      Provider.of<AuthProv>(context,
                                                  listen: true)
                                              .loadingState
                                          ? Center(
                                              child: Platform.isIOS
                                                  ? const CupertinoActivityIndicator()
                                                  : const CircularProgressIndicator(
                                                      backgroundColor:
                                                          Colors.green,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.green),
                                                    ),
                                            )
                                          : RoundedButton(
                                              height: 55,
                                              width: 220,
                                              ontap: () {
                                                if (!_forgetFormKey.currentState
                                                    .validate()) {
                                                  return;
                                                } else {
                                                  takeImage().then((image) {
                                                    print(
                                                        'image during login is   $image');
                                                    if (image == null) {
                                                      authProv
                                                          .changeLoadingState(
                                                              false);
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'حدث خطأ ما برجاء المحاولة مجدداً',
                                                          backgroundColor:
                                                              Colors.green,
                                                          toastLength: Toast
                                                              .LENGTH_LONG);
                                                      return;
                                                    } else {
                                                      login(image);
                                                    }
                                                  });
                                                }
                                              },
                                              title: 'تسجيل',
                                              buttonColor: ColorManager.primary,
                                              titleColor:
                                                  ColorManager.backGroundColor,
                                            ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
    );
  }

  login(File img) {
    var authProv = Provider.of<AuthProv>(context, listen: false);
    authProv.changeLoadingState(true);

    print('_platformVersion  =   $_udid');
/*    Fluttertoast.showToast(
        msg: 'MAC ADDRESS IS $_udid',
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_LONG);*/
    if (_udid == 'Unknown' || _udid == null) {
      Fluttertoast.showToast(
          msg: 'حدث خطأ ما برجاء المحاولة لاحقاً',
          backgroundColor: Colors.green,
          toastLength: Toast.LENGTH_LONG);
      authProv.changeLoadingState(false);

      return;
    }
    print('****');
    authProv
        .login(_memberShipController.text, _passwordController.text, img, _udid)
        .then((value) async {

      authProv.changeLoadingState(false);

      print('value => $value');
      if (value == 'Success') {
        print('caching data');
        await cachingData();
        print('role is ${authProv.userRole}');
        if (authProv.userRole == 'Manager') {
          print('manager');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MHomeScreen()));
          return;
        } else if (authProv.userRole == 'Admin') {
          print('admin');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomNav(comingIndex: 3,)));
          return;
        }

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => EntryScreen()));
      } else if (value == 'Incorrect User') {
        Fluttertoast.showToast(
            msg: 'بيانات غير صحيحة',
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG);
      }else if (value == 'Incorrect Password') {
        Fluttertoast.showToast(
            msg: 'كلمة المرور غير صحيحة ',
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG);
      } else if (value == 'you need to be at same network with local host') {
        Fluttertoast.showToast(
            msg: value,
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG);
      } else {
        Fluttertoast.showToast(
            msg: value,
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG);
      }
    });
  }

  Future<void> cachingData() async {
    await prefs.setString('guardId', authProv.userId);
    await prefs.setString('role', authProv.userRole ?? '');
    await prefs.setString('token', authProv.token);
    await prefs.setString('guardName', authProv.guardName ?? '');
    await prefs.setDouble('balance', authProv.balance ?? 0.0);
    await prefs.setDouble('ticketLostPrice', authProv.lostTicketPrice ?? 0.0);
    await prefs.setString('printerAddress', authProv.printerAddress ?? '');
    await prefs.setString('gateName', authProv.gateName ?? '');
    await prefs.setBool('isLoggedIn', authProv.isLogged);
    await prefs.setStringList('parkingTypes', authProv.parkTypes);
  }

  Future<File> takeImage() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
    File compressedFile;
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;
      print('1');
      // Construct the path where the image should be saved using the
      // pattern package.

      final path = nPath.join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now().toString().split(":")[2]}.jpg',
      );
      await _controller.takePicture().then((value) => value.saveTo(path));

      // If the picture was taken, display it on a new screen.
      File img = File(path);
      print(img.lengthSync());

      String newPath = nPath.join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now().toString().split(":")[2]}.jpg',
      );

      compressedFile =
          await testCompressAndGetFile(file: img, targetPath: newPath);

      // here we will crop

      print('=====Compressed==========');
      print(newPath);

      _controller.dispose();
    } catch (e) {
      print(e);
    }
    return compressedFile;
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
    _controller.dispose();
    super.dispose();
  }
}
