

import '../../Presentation/guard/g_home_screen.dart';
import '../../Presentation/login_screen/Screens/login.dart';
import '../../Presentation/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  Route onGenerateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );
        case HomeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );


      default:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }
}
