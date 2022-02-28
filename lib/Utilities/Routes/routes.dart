import 'package:clean_app/Presentation/home_screen/home.dart';
import 'package:clean_app/Presentation/intro_screen/Screens/login.dart';
import 'package:clean_app/Presentation/splash_screen/splash_screen.dart';
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
