// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:reminder_app/services/package_services_module.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final packageServicesModule = _$PackageServicesModule();
  g.registerLazySingleton<NavigationService>(
      () => packageServicesModule.navigationService);
}

class _$PackageServicesModule extends PackageServicesModule {
  @override
  NavigationService get navigationService => NavigationService();
}
