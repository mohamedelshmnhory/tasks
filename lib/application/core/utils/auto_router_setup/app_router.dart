import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/entities/task.dart';
import '../../../../domain/models/user.dart';
import '../../../../presentaion/pages/auth/login_page.dart';
import '../../../../presentaion/pages/auth/pin_code_page.dart';
import '../../../../presentaion/pages/auth/register_page.dart';
import '../../../../presentaion/pages/employees/employees_page.dart';
import '../../../../presentaion/pages/profile/profile_page.dart';
import '../../../../presentaion/pages/projects/add_project_page.dart';
import '../../../../presentaion/pages/projects/project_details_page.dart';
import '../../../../presentaion/pages/projects/projects_page.dart';
import '../../../../presentaion/pages/splash/splash_screen.dart';
import '../../../../presentaion/pages/tasks/task_details_page.dart';
import '../../../../presentaion/pages/tasks/tasks_page.dart';
part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: PinCodeVerificationRoute.page),
        AutoRoute(page: TasksRoute.page),
        AutoRoute(page: TaskDetailsRoute.page),
        AutoRoute(page: ProjectsRoute.page),
        AutoRoute(page: AddProjectRoute.page),
        AutoRoute(page: ProjectDetailsRoute.page),
        AutoRoute(page: EmployeesRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ];
}
