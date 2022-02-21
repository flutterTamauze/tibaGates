import 'dart:io';

import 'package:clean_app/Core/Routes/routes.dart';
import 'package:clean_app/Presentation/splash_screen/Screens/splash_screen.dart';
import 'package:clean_app/ViewModel/authProv.dart';
import 'package:clean_app/ViewModel/visitorProv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  //HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(Routes()));
}

class MyApp extends StatelessWidget {
  final Routes routes;
  MyApp(this.routes);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(800.0, 1232.0),
      builder: () {
        return MultiProvider(
          providers: [
          ChangeNotifierProvider(
            create: (context) => VisitorProv(),
          ),     ChangeNotifierProvider(
            create: (context) => AuthProv(),
          ),

        ],
          child: MaterialApp(
            title: "Tiba Rose",
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            theme: ThemeData(fontFamily: "Almarai"),
            onGenerateRoute: routes.onGenerateRoute,
          ),
        );
      },
    );
  }
}
/*
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}*/
