// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tasks/application/core/di/app_component/dio_module.dart'
    as _i732;
import 'package:tasks/application/core/utils/auto_router_setup/app_router.dart'
    as _i251;
import 'package:tasks/application/core/utils/helpers/app_configurations_helper/app_configurations_helper.dart'
    as _i826;
import 'package:tasks/application/core/utils/helpers/connectivity_helper/connectivity_checker_helper.dart'
    as _i873;
import 'package:tasks/application/core/utils/helpers/responsive_ui_helper/responsive_config.dart'
    as _i149;
import 'package:tasks/data/datasources/auth_remote_datasource/auth_remote_datasource.dart'
    as _i744;
import 'package:tasks/data/datasources/auth_remote_datasource/auth_remote_datasource_impl.dart'
    as _i708;
import 'package:tasks/data/datasources/project_remote_datasource/project_remote_datasource.dart'
    as _i899;
import 'package:tasks/data/datasources/project_remote_datasource/project_remote_datasource_impl.dart'
    as _i58;
import 'package:tasks/data/datasources/task_remote_datasource/task_remote_datasource.dart'
    as _i653;
import 'package:tasks/data/datasources/task_remote_datasource/task_remote_datasource_impl.dart'
    as _i511;
import 'package:tasks/data/network/dio_strategy_helper/concrete_strategies/delete_request_strategy.dart'
    as _i840;
import 'package:tasks/data/network/dio_strategy_helper/concrete_strategies/get_request_strategy.dart'
    as _i549;
import 'package:tasks/data/network/dio_strategy_helper/concrete_strategies/post_request_strategy.dart'
    as _i524;
import 'package:tasks/data/network/dio_strategy_helper/concrete_strategies/put_request_strategy.dart'
    as _i462;
import 'package:tasks/data/network/dio_strategy_helper/dio_request_context.dart'
    as _i288;
import 'package:tasks/data/repositories/project/project_repository.dart'
    as _i119;
import 'package:tasks/data/repositories/project/project_repository_impl.dart'
    as _i79;
import 'package:tasks/data/repositories/task/task_repository.dart' as _i351;
import 'package:tasks/data/repositories/task/task_repository_impl.dart'
    as _i381;
import 'package:tasks/data/repositories/user/user_repository.dart' as _i970;
import 'package:tasks/data/repositories/user/user_repository_impl.dart'
    as _i437;
import 'package:tasks/domain/usecases/auth/do_login_usecase.dart' as _i1028;
import 'package:tasks/domain/usecases/auth/get_profile_usecase.dart' as _i576;
import 'package:tasks/domain/usecases/auth/logout_usecase.dart' as _i207;
import 'package:tasks/domain/usecases/auth/update_profile_usecase.dart'
    as _i476;
import 'package:tasks/domain/usecases/project/add_project_member_usecase.dart'
    as _i895;
import 'package:tasks/domain/usecases/project/create_project_task_usecase.dart'
    as _i601;
import 'package:tasks/domain/usecases/project/create_project_usecase.dart'
    as _i756;
import 'package:tasks/domain/usecases/project/delete_project_usecase.dart'
    as _i834;
import 'package:tasks/domain/usecases/project/get_all_users_usecase.dart'
    as _i73;
import 'package:tasks/domain/usecases/project/get_project_by_id_usecase.dart'
    as _i388;
import 'package:tasks/domain/usecases/project/get_project_tasks_usecase.dart'
    as _i454;
import 'package:tasks/domain/usecases/project/get_projects_usecase.dart'
    as _i703;
import 'package:tasks/domain/usecases/project/remove_project_member_usecase.dart'
    as _i834;
import 'package:tasks/domain/usecases/project/update_project_usecase.dart'
    as _i118;
import 'package:tasks/domain/usecases/task/delete_task_usecase.dart' as _i711;
import 'package:tasks/domain/usecases/task/get_task_by_id_usecase.dart'
    as _i336;
import 'package:tasks/domain/usecases/task/update_task_usecase.dart' as _i786;
import 'package:tasks/presentaion/pages/auth/bloc/authentication_bloc.dart'
    as _i9;
import 'package:tasks/presentaion/pages/projects/bloc/projects_bloc.dart'
    as _i465;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioModule = _$DioModule();
    gh.factory<_i873.ConnectivityCheckerHelper>(
        () => _i873.ConnectivityCheckerHelper());
    gh.singleton<_i361.Dio>(() => dioModule.dio);
    gh.singleton<_i251.AppRouter>(() => _i251.AppRouter());
    gh.singleton<_i149.ResponsiveUiConfig>(() => _i149.ResponsiveUiConfig());
    gh.singleton<_i826.AppConfigurations>(() => _i826.AppConfigurations());
    gh.factory<_i288.DioRequestContext>(
        () => _i288.DioRequestContext(gh<_i873.ConnectivityCheckerHelper>()));
    gh.factory<_i744.AuthRemoteDataSource>(
        () => _i708.AuthRemoteDataSourceImpl(gh<_i288.DioRequestContext>()));
    gh.factory<_i653.TaskRemoteDataSource>(
        () => _i511.TaskRemoteDataSourceImpl(gh<_i288.DioRequestContext>()));
    gh.factory<_i899.ProjectRemoteDataSource>(
        () => _i58.ProjectRemoteDataSourceImpl(gh<_i288.DioRequestContext>()));
    gh.singleton<_i361.Interceptor>(
      () => dioModule.loggerInterceptor,
      instanceName: 'LoggerInterceptor',
    );
    gh.lazySingleton<_i462.PutRequestStrategy>(
        () => _i462.PutRequestStrategy(gh<_i361.Dio>()));
    gh.lazySingleton<_i524.PostRequestStrategy>(
        () => _i524.PostRequestStrategy(gh<_i361.Dio>()));
    gh.lazySingleton<_i549.GetRequestStrategy>(
        () => _i549.GetRequestStrategy(gh<_i361.Dio>()));
    gh.lazySingleton<_i840.DeleteRequestStrategy>(
        () => _i840.DeleteRequestStrategy(gh<_i361.Dio>()));
    gh.factory<_i119.ProjectRepository>(() => _i79.ProjectRepositoryImpl(
        remoteDataSource: gh<_i899.ProjectRemoteDataSource>()));
    gh.factory<_i351.TaskRepository>(() => _i381.TaskRepositoryImpl(
        remoteDataSource: gh<_i653.TaskRemoteDataSource>()));
    gh.factory<_i388.GetProjectByIdUseCase>(
        () => _i388.GetProjectByIdUseCase(gh<_i119.ProjectRepository>()));
    gh.factory<_i703.GetProjectsUseCase>(
        () => _i703.GetProjectsUseCase(gh<_i119.ProjectRepository>()));
    gh.factory<_i454.GetProjectTasksUseCase>(
        () => _i454.GetProjectTasksUseCase(gh<_i119.ProjectRepository>()));
    gh.factory<_i834.DeleteProjectUseCase>(
        () => _i834.DeleteProjectUseCase(gh<_i119.ProjectRepository>()));
    gh.factory<_i756.CreateProjectUseCase>(
        () => _i756.CreateProjectUseCase(gh<_i119.ProjectRepository>()));
    gh.factory<_i118.UpdateProjectUseCase>(
        () => _i118.UpdateProjectUseCase(gh<_i119.ProjectRepository>()));
    gh.factory<_i601.CreateProjectTaskUseCase>(
        () => _i601.CreateProjectTaskUseCase(gh<_i119.ProjectRepository>()));
    gh.factory<_i834.RemoveProjectMemberUseCase>(
        () => _i834.RemoveProjectMemberUseCase(gh<_i119.ProjectRepository>()));
    gh.factory<_i895.AddProjectMemberUseCase>(
        () => _i895.AddProjectMemberUseCase(gh<_i119.ProjectRepository>()));
    gh.factory<_i73.GetAllUsersUseCase>(
        () => _i73.GetAllUsersUseCase(gh<_i119.ProjectRepository>()));
    gh.factory<_i970.UserRepository>(() => _i437.UserRepositoryImpl(
        remoteDataSource: gh<_i744.AuthRemoteDataSource>()));
    gh.factory<_i1028.DoLoginUseCase>(
        () => _i1028.DoLoginUseCase(gh<_i970.UserRepository>()));
    gh.factory<_i786.UpdateTaskUseCase>(
        () => _i786.UpdateTaskUseCase(gh<_i351.TaskRepository>()));
    gh.factory<_i711.DeleteTaskUseCase>(
        () => _i711.DeleteTaskUseCase(gh<_i351.TaskRepository>()));
    gh.factory<_i336.GetTaskByIdUseCase>(
        () => _i336.GetTaskByIdUseCase(gh<_i351.TaskRepository>()));
    gh.factory<_i476.UpdateProfileUseCase>(
        () => _i476.UpdateProfileUseCase(gh<_i970.UserRepository>()));
    gh.factory<_i207.LogoutUseCase>(
        () => _i207.LogoutUseCase(gh<_i970.UserRepository>()));
    gh.factory<_i576.GetProfileUseCase>(
        () => _i576.GetProfileUseCase(gh<_i970.UserRepository>()));
    gh.factory<_i1028.RegisterUseCase>(
        () => _i1028.RegisterUseCase(gh<_i970.UserRepository>()));
    gh.factory<_i1028.RequestOTPUseCase>(
        () => _i1028.RequestOTPUseCase(gh<_i970.UserRepository>()));
    gh.factory<_i465.ProjectsBloc>(() => _i465.ProjectsBloc(
          gh<_i703.GetProjectsUseCase>(),
          gh<_i756.CreateProjectUseCase>(),
          gh<_i118.UpdateProjectUseCase>(),
          gh<_i834.DeleteProjectUseCase>(),
          gh<_i454.GetProjectTasksUseCase>(),
          gh<_i601.CreateProjectTaskUseCase>(),
          gh<_i388.GetProjectByIdUseCase>(),
          gh<_i73.GetAllUsersUseCase>(),
          gh<_i895.AddProjectMemberUseCase>(),
          gh<_i834.RemoveProjectMemberUseCase>(),
        ));
    gh.singleton<_i9.AuthenticationBloc>(() => _i9.AuthenticationBloc(
          gh<_i1028.DoLoginUseCase>(),
          gh<_i207.LogoutUseCase>(),
          gh<_i1028.RequestOTPUseCase>(),
          gh<_i476.UpdateProfileUseCase>(),
          gh<_i576.GetProfileUseCase>(),
          gh<_i1028.RegisterUseCase>(),
        ));
    return this;
  }
}

class _$DioModule extends _i732.DioModule {}
