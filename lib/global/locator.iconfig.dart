// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:reminder_app/services/database_service.dart';
import 'package:reminder_app/services/date_time_service.dart';
import 'package:reminder_app/services/package_services_module.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final packageServicesModule = _$PackageServicesModule();
  g.registerLazySingleton<DatabaseService>(() => DatabaseService());
  g.registerLazySingleton<DateTimeService>(() => DateTimeService());
  g.registerLazySingleton<DialogService>(
      () => packageServicesModule.dialogService);
  g.registerLazySingleton<NavigationService>(
      () => packageServicesModule.navigationService);
  g.registerLazySingleton<NotificationService>(() => NotificationService());
}

class _$PackageServicesModule extends PackageServicesModule {
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
}
