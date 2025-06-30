import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'application/config/design_system/app_theme.dart';
import 'application/config/l10n.dart';
import 'application/core/di/app_component/app_component.dart';
import 'application/core/utils/auto_router_setup/app_router.dart';
import 'application/core/utils/helpers/app_flavor_helper/app_flavors_helper.dart';
import 'application/core/utils/helpers/cache/cache_manager.dart';
import 'application/core/utils/helpers/responsive_ui_helper/responsive_config.dart';
import 'presentaion/pages/pdf_editor/pad_editor.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initAppComponentLocator();

  await EasyLocalization.ensureInitialized();

  await CacheManager.instance.init();

  // await Firebase.initializeApp();
  // await LocalNotificationHandler.initializeNotifications();

  AppFlavorsHelper.instance;

  EasyLocalization.logger.enableLevels = [];

  runApp(
    EasyLocalization(
      supportedLocales: L10n.all,
      path: 'assets/l10n',
      fallbackLocale: L10n.langEn,
      startLocale: CacheManager.instance.getSavedLocale(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AppRouter _appRouter = locator<AppRouter>();

  @override
  Widget build(BuildContext context) {
    locator<ResponsiveUiConfig>().initialize(context);
    return MaterialApp.router(
      title: '',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme,
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
