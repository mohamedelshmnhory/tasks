// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AddProjectRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddProjectPage(),
      );
    },
    EmployeesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EmployeesPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    PinCodeVerificationRoute.name: (routeData) {
      final args = routeData.argsAs<PinCodeVerificationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PinCodeVerificationPage(
          key: args.key,
          phoneNumber: args.phoneNumber,
          countryCode: args.countryCode,
          phoneCountry: args.phoneCountry,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePage(),
      );
    },
    ProjectDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<ProjectDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProjectDetailsPage(
          key: args.key,
          projectId: args.projectId,
        ),
      );
    },
    ProjectsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectsPage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    TaskDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<TaskDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TaskDetailsPage(
          key: args.key,
          task: args.task,
          users: args.users,
        ),
      );
    },
    TasksRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TasksPage(),
      );
    },
  };
}

/// generated route for
/// [AddProjectPage]
class AddProjectRoute extends PageRouteInfo<void> {
  const AddProjectRoute({List<PageRouteInfo>? children})
      : super(
          AddProjectRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddProjectRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EmployeesPage]
class EmployeesRoute extends PageRouteInfo<void> {
  const EmployeesRoute({List<PageRouteInfo>? children})
      : super(
          EmployeesRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmployeesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PinCodeVerificationPage]
class PinCodeVerificationRoute
    extends PageRouteInfo<PinCodeVerificationRouteArgs> {
  PinCodeVerificationRoute({
    Key? key,
    required String phoneNumber,
    required String countryCode,
    required String phoneCountry,
    List<PageRouteInfo>? children,
  }) : super(
          PinCodeVerificationRoute.name,
          args: PinCodeVerificationRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
            countryCode: countryCode,
            phoneCountry: phoneCountry,
          ),
          initialChildren: children,
        );

  static const String name = 'PinCodeVerificationRoute';

  static const PageInfo<PinCodeVerificationRouteArgs> page =
      PageInfo<PinCodeVerificationRouteArgs>(name);
}

class PinCodeVerificationRouteArgs {
  const PinCodeVerificationRouteArgs({
    this.key,
    required this.phoneNumber,
    required this.countryCode,
    required this.phoneCountry,
  });

  final Key? key;

  final String phoneNumber;

  final String countryCode;

  final String phoneCountry;

  @override
  String toString() {
    return 'PinCodeVerificationRouteArgs{key: $key, phoneNumber: $phoneNumber, countryCode: $countryCode, phoneCountry: $phoneCountry}';
  }
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectDetailsPage]
class ProjectDetailsRoute extends PageRouteInfo<ProjectDetailsRouteArgs> {
  ProjectDetailsRoute({
    Key? key,
    required int projectId,
    List<PageRouteInfo>? children,
  }) : super(
          ProjectDetailsRoute.name,
          args: ProjectDetailsRouteArgs(
            key: key,
            projectId: projectId,
          ),
          initialChildren: children,
        );

  static const String name = 'ProjectDetailsRoute';

  static const PageInfo<ProjectDetailsRouteArgs> page =
      PageInfo<ProjectDetailsRouteArgs>(name);
}

class ProjectDetailsRouteArgs {
  const ProjectDetailsRouteArgs({
    this.key,
    required this.projectId,
  });

  final Key? key;

  final int projectId;

  @override
  String toString() {
    return 'ProjectDetailsRouteArgs{key: $key, projectId: $projectId}';
  }
}

/// generated route for
/// [ProjectsPage]
class ProjectsRoute extends PageRouteInfo<void> {
  const ProjectsRoute({List<PageRouteInfo>? children})
      : super(
          ProjectsRoute.name,
          initialChildren: children,
        );

  static const String name = 'projects';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TaskDetailsPage]
class TaskDetailsRoute extends PageRouteInfo<TaskDetailsRouteArgs> {
  TaskDetailsRoute({
    Key? key,
    required Task task,
    required List<User> users,
    List<PageRouteInfo>? children,
  }) : super(
          TaskDetailsRoute.name,
          args: TaskDetailsRouteArgs(
            key: key,
            task: task,
            users: users,
          ),
          initialChildren: children,
        );

  static const String name = 'TaskDetailsRoute';

  static const PageInfo<TaskDetailsRouteArgs> page =
      PageInfo<TaskDetailsRouteArgs>(name);
}

class TaskDetailsRouteArgs {
  const TaskDetailsRouteArgs({
    this.key,
    required this.task,
    required this.users,
  });

  final Key? key;

  final Task task;

  final List<User> users;

  @override
  String toString() {
    return 'TaskDetailsRouteArgs{key: $key, task: $task, users: $users}';
  }
}

/// generated route for
/// [TasksPage]
class TasksRoute extends PageRouteInfo<void> {
  const TasksRoute({List<PageRouteInfo>? children})
      : super(
          TasksRoute.name,
          initialChildren: children,
        );

  static const String name = 'TasksRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
