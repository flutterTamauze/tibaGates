import 'package:clean_app/ViewModel/authProv.dart';
import 'package:clean_app/ViewModel/visitorProv.dart';
import 'package:get_it/get_it.dart';


final instance = GetIt.instance;

class InitLocator {
  GetIt locator = GetIt.I;

  void intalizeLocator() {
    _setUpLocator();
    print("initialized locators");
  }

  void _setUpLocator() async {
    //Providers
    locator.registerLazySingleton(() => VisitorProv());

    locator.registerLazySingleton(() => AuthProv());


    //Network

    // ignore: cascade_invocations
    // instance.registerLazySingleton<DataConnectionChecker>(
    //     () => DataConnectionChecker());
    // ignore: cascade_invocations
    // instance
    //     .registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(instance()));
  }
}
