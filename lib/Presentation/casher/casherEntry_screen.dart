// ignore_for_file: missing_return
import 'casherHome_screen.dart';
import '../guard/scanner.dart';
import '../login_screen/Widgets/outlined_button.dart';
import '../../Utilities/Shared/noInternet.dart';
import '../../ViewModel/casher/servicesProv.dart';
import '../../Utilities/Shared/dialogs/exit_dialog2.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../Utilities/connectivityStatus.dart';
import '../../../Utilities/Colors/colorManager.dart';
import '../../../Utilities/Constants/constants.dart';
import '../../../Utilities/Fonts/fontsManager.dart';
import '../../../Utilities/Shared/sharedWidgets.dart';
import '../../../ViewModel/guard/authProv.dart';
import '../../../ViewModel/guard/visitorProv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';

class CasherEntryScreen extends StatefulWidget {
  const CasherEntryScreen({Key key}) : super(key: key);

  @override
  State<CasherEntryScreen> createState() => _CasherEntryScreenState();
}

class _CasherEntryScreenState extends State<CasherEntryScreen> {
  String token;

  @override
  void initState() {
    super.initState();
    if (Provider.of<ServicesProv>(context, listen: false)
        .serviceObjects
        .isNotEmpty) {

/*      Provider.of<ServicesProv>(context, listen: false).servicePrice =
          Provider.of<ServicesProv>(context, listen: false)
              .serviceObjects[0]
              .servicePrice;*/

      Provider.of<ServicesProv>(context, listen: false).resetPrice();
    }

    token = prefs.getString('token');
    print(token);
    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
      cachingData();
    });
  }

  Future<void> cachingData() async {
    Provider.of<VisitorProv>(context, listen: false).logId = null;
    Provider.of<AuthProv>(context, listen: false).guardName =
        prefs.getString('guardName');
    Provider.of<AuthProv>(context, listen: false).printerAddress =
        prefs.getString('printerAddress');
    Provider.of<AuthProv>(context, listen: false).balance =
        prefs.getDouble('balance');
    Provider.of<AuthProv>(context, listen: false).lostTicketPrice =
        prefs.getDouble('ticketLostPrice');
    Provider.of<AuthProv>(context, listen: false).gateName =
        prefs.getString('gateName');
    Provider.of<AuthProv>(context, listen: false).token =
        prefs.getString('token');
    Provider.of<AuthProv>(context, listen: false).userId =
        prefs.getString('guardId');
  }

  @override
  Widget build(BuildContext context) {
/*    if(mounted){
      if(Provider.of<ServicesProv>(context,listen: false).serviceObjects.isNotEmpty){
        Provider.of<ServicesProv>(context, listen: false).resetPrice();
      }
    }*/
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: connectionStatus == ConnectivityStatus.Offline
            ? NoInternet()
            : SafeArea(
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
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              child: SizedBox(
                                height: 45.h,
                                width: 50.w,
                                child: const Center(
                                  child: Icon(
                                    Icons.table_view,
                                    color: Colors.blue,
                                    size: 36,
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                      color: Colors.blue, width: 1.4.w)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 20.h, horizontal: 20.w)),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))))),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              child: SizedBox(
                                height: 45.h,
                                child: Row(
                                  children: [
                                    AutoSizeText(
                                        '${Provider.of<AuthProv>(context, listen: true).balance ?? '0'} ',
                                        style: TextStyle(
                                          fontSize: setResponsiveFontSize(28),
                                          fontWeight: FontManager.bold,
                                          color: Colors.red,
                                        )),
                                    AutoSizeText(
                                      Provider.of<AuthProv>(context,
                                                  listen: true)
                                              .guardName ??
                                          '',
                                      style: TextStyle(
                                          fontSize: setResponsiveFontSize(22),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    AutoSizeText(
                                      ' إجمالى فواتير',
                                      style: TextStyle(
                                        fontSize: setResponsiveFontSize(22),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                      color: Colors.blue, width: 1.4.w)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 20.h, horizontal: 20.w)),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 80.h,
                        ),
                        Hero(
                          tag: 'logo',
                          child: ZoomIn(
                            child: SizedBox(
                              height: (height * 0.17),
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
                          height: 80.h,
                        ),
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 70.h, horizontal: 70.w),
                            child: Column(
                              children: [
                                RoundedButton(
                                  ontap: () async {
                                    navigateTo(context, CasherHomeScreen());
                                  },
                                  title: 'فواتير',
                                  width: 250,
                                  height: 55,
                                  buttonColor: ColorManager.primary,
                                  titleColor: ColorManager.backGroundColor,
                                ),
                                SizedBox(
                                  height: 26.h,
                                ),
                                RoundedButton(
                                  ontap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const QrCodeScreen(
                                                  screen: 'sports_casher',
                                                )),
                                        (Route<dynamic> route) => false);
                                  },
                                  title: 'أنشطة',
                                  width: 250,
                                  height: 55,
                                  buttonColor: Colors.orange,
                                  titleColor: ColorManager.backGroundColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 280.h,
                        ),
                        FadeInUp(
                            child: OutlineButtonFb1(
                          text: 'Logout',
                          onPressed: () => showDialog<Dialog>(
                              context: context,
                              builder: (BuildContext context) =>
                                  ZoomIn(child: const DialogFb1())),
                        ))
                      ],
                    ),
                  ),
                ),
              )),
      ),
    );
  }
}
