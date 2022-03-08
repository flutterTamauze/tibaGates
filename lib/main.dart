import 'dart:io';

import 'package:clean_app/Presentation/splash_screen/splash_screen.dart';
import 'package:clean_app/ViewModel/guard/authProv.dart';
import 'package:clean_app/ViewModel/guard/visitorProv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utilities/Routes/routes.dart';
import 'Utilities/locators.dart';
import 'ViewModel/admin/adminProv.dart';
import 'ViewModel/manager/managerProv.dart';

SharedPreferences prefs;
GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  InitLocator locator = InitLocator();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  locator.intalizeLocator();

  runApp(MyApp(Routes()));
}

class MyApp extends StatelessWidget {
  final Routes routes;

  MyApp(this.routes);

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
            ),   ChangeNotifierProvider(
              create: (context) => getIt<AdminProv>(),
            ),
          ],
          child: MaterialApp(
            title: 'Tiba Rose',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            theme: ThemeData(fontFamily: 'Almarai'),
            onGenerateRoute: routes.onGenerateRoute,
          ),
        );
      },
    );
  }
}
