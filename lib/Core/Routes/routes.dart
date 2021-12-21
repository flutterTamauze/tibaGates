import 'package:clean_app/Data/Models/user.dart';
import 'package:clean_app/Presentation/home_screen/Screens/home.dart';
import 'package:clean_app/Presentation/intro_screen/Screens/intro_screen.dart';
import 'package:clean_app/Presentation/pinCode_screen/pincode.dart';

import 'package:clean_app/Presentation/splash_screen/Screens/splash_screen.dart';
import 'package:clean_app/Presentation/user_profile/screens/userProfile.dart';
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
      case IntroScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => IntroScreen(),
        );
      case HomePage.routeName:
        return MaterialPageRoute(
          builder: (context) => HomePage(args as User),
        );
      case ProfilePage.routeName:
        return MaterialPageRoute(
          builder: (context) => ProfilePage(args as User),
        );

      default:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }
}
