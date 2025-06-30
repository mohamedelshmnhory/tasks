import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/entitties/based_api_result/error_result_model.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../../application/core/utils/constants/app_constants.dart';
import '../../../application/core/utils/helpers/custom_exceptions/custom_connection_exception.dart';
import '../../entities/project.dart';
import '../../entities/task.dart';
import '../../entities/user.dart';
import '../../network/dio_strategy_helper/concrete_strategies/get_request_strategy.dart';
import '../../network/dio_strategy_helper/concrete_strategies/post_request_strategy.dart';
import '../../network/dio_strategy_helper/concrete_strategies/put_request_strategy.dart';
import '../../network/dio_strategy_helper/concrete_strategies/delete_request_strategy.dart';
import '../../network/dio_strategy_helper/dio_request_context.dart';
import 'project_remote_datasource.dart';

@Injectable(as: ProjectRemoteDataSource)
class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  const ProjectRemoteDataSourceImpl(this._apiCallHelper);
  final DioRequestContext _apiCallHelper;

  @override
  Future<ApiResultModel<List<Project>?>> getProjects() async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: ProjectsEndpoint,
      );
      return result.when(
        success: (Response response) async {
          final projects = (response.data as List).map((e) => Project.fromJson(e)).toList();
          return ApiResultModel<List<Project>?>.success(data: projects);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<List<Project>?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<Project?>> getProjectById(int id) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: ProjectByIdEndpoint + id.toString(),
      );
      return result.when(
        success: (Response response) async {
          final project = Project.fromJson(response.data);
          return ApiResultModel<Project?>.success(data: project);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<Project?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<Project?>> createProject(Project project) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PostRequestStrategy>(),
        uri: ProjectsEndpoint,
        requestData: project.toJson(),
      );
      return result.when(
        success: (Response response) async {
          final created = Project.fromJson(response.data);
          return ApiResultModel<Project?>.success(data: created);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<Project?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<void>> updateProject(int id, Project project) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PutRequestStrategy>(),
        uri: ProjectByIdEndpoint + id.toString(),
        requestData: project.toJson(),
      );
      return result.when(
        success: (Response response) async {
          return ApiResultModel<void>.success(data: null);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<void>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<void>> deleteProject(int id) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<DeleteRequestStrategy>(),
        uri: ProjectByIdEndpoint + id.toString(),
      );
      return result.when(
        success: (Response response) async {
          return ApiResultModel<void>.success(data: null);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<void>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<List<Task>?>> getProjectTasks(int projectId) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: ProjectTasksEndpoint + projectId.toString() + '/tasks',
      );
      return result.when(
        success: (Response response) async {
          final tasks = (response.data as List).map((e) => Task.fromJson(e)).toList();
          return ApiResultModel<List<Task>?>.success(data: tasks);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<List<Task>?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<Task?>> createProjectTask(int projectId, Task task) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PostRequestStrategy>(),
        uri: ProjectTasksEndpoint + projectId.toString() + '/tasks',
        requestData: task.toJson(),
      );
      return result.when(
        success: (Response response) async {
          final created = Task.fromJson(response.data);
          return ApiResultModel<Task?>.success(data: created);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<Task?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<List<User>?>> getAllUsers() async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: UsersEndpoint,
      );
      return result.when(
        success: (Response response) async {
          final users = (response.data as List).map((e) => User.fromJson(e)).toList();
          return ApiResultModel<List<User>?>.success(data: users);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<List<User>?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<List<User>?>> getProjectMembers(int projectId) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: ProjectMembersEndpoint + projectId.toString() + '/members',
      );
      return result.when(
        success: (Response response) async {
          final members = (response.data as List).map((e) => User.fromJson(e)).toList();
          return ApiResultModel<List<User>?>.success(data: members);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<List<User>?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<void>> addProjectMember(int projectId, int userId) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PostRequestStrategy>(),
        uri: ProjectMembersEndpoint + projectId.toString() + '/members' + '?userId=' + userId.toString(),
        requestData: {'userId': userId},
      );
      return result.when(
        success: (Response response) async {
          return ApiResultModel<void>.success(data: null);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<void>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<void>> removeProjectMember(int projectId, int userId) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<DeleteRequestStrategy>(),
        uri: ProjectMembersEndpoint + projectId.toString() + '/members/' + userId.toString(),
      );
      return result.when(
        success: (Response response) async {
          return ApiResultModel<void>.success(data: null);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<void>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }
}
