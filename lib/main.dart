import 'package:clean_app/Core/Routes/routes.dart';
import 'package:clean_app/Presentation/splash_screen/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp(Routes()));
}

class MyApp extends StatelessWidget {
  final Routes routes;
  MyApp(this.routes);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(392.72, 807.27),
      builder: () {
        return MaterialApp(
          title: "دار الدفاع",
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          theme: ThemeData(fontFamily: "Almarai"),
          onGenerateRoute: routes.onGenerateRoute,
        );
      },
    );
  }
}
