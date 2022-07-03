// ignore_for_file: always_specify_types

import 'dart:io';

import 'Presentation/casher/casherEntry_screen.dart';
import 'Presentation/splash_screen/splash_screen.dart';
import 'ViewModel/casher/casherServicesProv.dart';
import 'ViewModel/common/commonProv.dart';
import 'ViewModel/game/gameProv.dart';
import 'ViewModel/guard/authProv.dart';
import 'ViewModel/guard/visitorProv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utilities/Routes/routes.dart';
import 'Utilities/connectivityStatus.dart';
import 'Utilities/locators.dart';
import 'ViewModel/admin/a_homeBioProv.dart';
import 'ViewModel/admin/adminProv.dart';
import 'ViewModel/admin/vm/publicHolidaysProv.dart';
import 'ViewModel/admin/reports/admin_reportsProv.dart';
import 'ViewModel/admin/more/holidaysProv.dart';
import 'ViewModel/manager/managerProv.dart';
import 'ViewModel/admin/more/pricesProv.dart';
import 'ocr_test.dart';

SharedPreferences prefs;
GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                details.exception.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  };

  bool isInRelease = true;
  assert(() {
    isInRelease = false;
    return true;
  }());

  if (isInRelease) {
    debugPrint = (String message, {int wrapWidth}) {};
  }

  prefs = await SharedPreferences.getInstance();
  prefs.setString('baseUrl', 'https://tibarose.tibarosehotel.com');
  InitLocator locator = InitLocator();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  locator.intalizeLocator();
  runApp(MyApp(Routes()));
}

class MyApp extends StatelessWidget {
  final Routes routes;

  const MyApp(this.routes);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(800.0, 1232.0),
      builder: () {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => getIt<VisitorProv>(),
            ),
            ChangeNotifierProvider(
              create: (context) => getIt<AuthProv>(),
            ),
            ChangeNotifierProvider(
              create: (context) => getIt<ManagerProv>(),
            ),
            ChangeNotifierProvider(
              create: (context) => getIt<AdminProv>(),
            ),
            ChangeNotifierProvider(
              create: (context) => getIt<AdminHomeProv>(),
            ),
            ChangeNotifierProvider(
              create: (context) => getIt<AReportsProv>(),
            ),
            ChangeNotifierProvider(
              create: (context) => getIt<PricesProv>(),
            ),
            ChangeNotifierProvider(
              create: (context) => getIt<HolidaysProv>(),
            ),
            ChangeNotifierProvider(
              create: (context) => getIt<PublicHolidaysProv>(),
            ),
            ChangeNotifierProvider(
              create: (context) => getIt<GameProv>(),
            ),       ChangeNotifierProvider(
              create: (context) => getIt<ServicesProv>(),
            ),     ChangeNotifierProvider(
              create: (context) => getIt<CommonProv>(),
            ),
          ],
          child: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 3)),
              builder: (context, AsyncSnapshot snapshot) {
                return StreamProvider<ConnectivityStatus>(
                    initialData: ConnectivityStatus.Wifi,
                    create: (context) =>
                        ConnectivityService().connectionStatusController.stream,
                    builder: (context, snapshot) {
                      return GetMaterialApp(
                        title: 'Tiba Rose',
                        debugShowCheckedModeBanner: false,
                        home:
                        //OcrTest()
                        SplashScreen()
                        //SplashScreen()

                        //MyBluetooth()
                        // DiscoveryPage()

                        ,
                        theme: ThemeData(fontFamily: 'Almarai'),
                        onGenerateRoute: routes.onGenerateRoute,
                      );
                    });
              }),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
// hi