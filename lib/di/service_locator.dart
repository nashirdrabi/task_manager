
import 'package:get_it/get_it.dart';

import '../dashboard/repo/dashboard_repo.dart';
import '../dashboard/services/web/dashboard_web_api.dart';
import '../dashboard/viewmodel/dashboard_viewmodel.dart';

final serviceLocator = GetIt.instance;

void setupServices() {
  //dashboard
  
  serviceLocator
    ..registerLazySingleton<DashboardWebApi>(() => DashboardWebApiImpl())
    ..registerLazySingleton<DashboardRepo>(
        () => DashboardRepo())
    ..registerFactory<DashboardViewModel>(() => DashboardViewModel());


}
