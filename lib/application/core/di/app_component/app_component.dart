import 'package:tasks/application/core/di/app_component/app_component.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt locator = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<void> initAppComponentLocator() async => locator.init();
