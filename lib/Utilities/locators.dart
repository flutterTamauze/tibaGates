
import 'package:Tiba_Gates/ViewModel/casher/servicesProv.dart';
import 'package:Tiba_Gates/ViewModel/common/commonProv.dart';
import 'package:get_it/get_it.dart';

import '../ViewModel/admin/a_homeBioProv.dart';
import '../ViewModel/admin/adminProv.dart';
import '../ViewModel/admin/more/holidaysProv.dart';
import '../ViewModel/admin/more/pricesProv.dart';
import '../ViewModel/admin/reports/admin_reportsProv.dart';
import '../ViewModel/admin/vm/publicHolidaysProv.dart';
import '../ViewModel/game/gameProv.dart';
import '../ViewModel/guard/authProv.dart';
import '../ViewModel/guard/visitorProv.dart';
import '../ViewModel/manager/managerProv.dart';


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
    locator.registerLazySingleton(() => AdminProv());
    locator.registerLazySingleton(() => AdminHomeProv());
    locator.registerLazySingleton(() => AReportsProv());
    locator.registerLazySingleton(() => PricesProv());
    locator.registerLazySingleton(() => HolidaysProv());
    locator.registerLazySingleton(() => PublicHolidaysProv());
    locator.registerLazySingleton(() => GameProv());
    locator.registerLazySingleton(() => ServicesProv());
    locator.registerLazySingleton(() => CommonProv());


    //Network

    // ignore: cascade_invocations
    // instance.registerLazySingleton<DataConnectionChecker>(
    //     () => DataConnectionChecker());
    // ignore: cascade_invocations
    // instance
    //     .registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(instance()));
  }
}
