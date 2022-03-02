import 'package:clean_app/ViewModel/guard/authProv.dart';
import 'package:clean_app/ViewModel/guard/visitorProv.dart';
import 'package:clean_app/ViewModel/manager/managerProv.dart';
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
    locator.registerLazySingleton(() => ManagerProv());


    //Network

    // ignore: cascade_invocations
    // instance.registerLazySingleton<DataConnectionChecker>(
    //     () => DataConnectionChecker());
    // ignore: cascade_invocations
    // instance
    //     .registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(instance()));
  }
}
