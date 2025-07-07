import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/entitties/based_api_result/error_result_model.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../../application/core/utils/constants/app_constants.dart';
import '../../../application/core/utils/helpers/custom_exceptions/custom_connection_exception.dart';
import '../../entities/comment.dart';
import '../../entities/task.dart';
import '../../network/dio_strategy_helper/concrete_strategies/get_request_strategy.dart';
import '../../network/dio_strategy_helper/concrete_strategies/put_request_strategy.dart';
import '../../network/dio_strategy_helper/concrete_strategies/delete_request_strategy.dart';
import '../../network/dio_strategy_helper/concrete_strategies/post_request_strategy.dart';
import '../../network/dio_strategy_helper/dio_request_context.dart';
import 'task_remote_datasource.dart';

@Injectable(as: TaskRemoteDataSource)
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  const TaskRemoteDataSourceImpl(this._apiCallHelper);
  final DioRequestContext _apiCallHelper;

  @override
  Future<ApiResultModel<Task?>> getTaskById(int id) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: TaskByIdEndpoint + id.toString(),
      );
      return result.when(
        success: (Response response) async {
          final task = Task.fromJson(response.data);
          return ApiResultModel<Task?>.success(data: task);
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
  Future<ApiResultModel<Task>> updateTask(int id, Task task) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PutRequestStrategy>(),
        uri: TaskByIdEndpoint + id.toString(),
        requestData: task.toJson(),
      );
      return result.when(
        success: (Response response) async {
          final task = Task.fromJson(response.data);
          return ApiResultModel<Task>.success(data: task);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<Task>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<void>> deleteTask(int id) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<DeleteRequestStrategy>(),
        uri: TaskByIdEndpoint + id.toString(),
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
  Future<ApiResultModel<Comment>> addComment(int taskId, Comment comment) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PostRequestStrategy>(),
        uri: TaskByIdEndpoint + taskId.toString() + '/comments',
        requestData: comment.toJson(),
      );
      return result.when(
        success: (Response response) async {
          final comment = Comment.fromJson(response.data);
          return ApiResultModel<Comment>.success(data: comment);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<Comment>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<void>> deleteComment(int taskId, int commentId) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<DeleteRequestStrategy>(),
        uri: TaskByIdEndpoint + taskId.toString() + '/comments/' + commentId.toString(),
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
  Future<ApiResultModel<List<Comment>?>> getTaskComments(int taskId) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: TaskByIdEndpoint + taskId.toString() + '/comments',
      );
      return result.when(
        success: (Response response) async {
          final comments = (response.data as List).map((e) => Comment.fromJson(e)).toList();
          return ApiResultModel<List<Comment>?>.success(data: comments);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<List<Comment>?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<List<Task>?>> getMyTasks() async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: '/my-tasks',
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
  Future<ApiResultModel<List<Attachment>?>> getTaskAttachments(int taskId) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: '/tasks/{taskId}/attachments'.replaceFirst('{taskId}', taskId.toString()),
      );
      return result.when(
        success: (Response response) async {
          final attachments = (response.data as List).map((e) => Attachment.fromJson(e)).toList();
          return ApiResultModel<List<Attachment>?>.success(data: attachments);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<List<Attachment>?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<Attachment?>> uploadTaskAttachment(int taskId, dynamic file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PostRequestStrategy>(),
        uri: '/tasks/{taskId}/attachments'.replaceFirst('{taskId}', taskId.toString()),
        formData: formData,
      );
      return result.when(
        success: (Response response) async {
          final attachment = Attachment.fromJson(response.data);
          return ApiResultModel<Attachment?>.success(data: attachment);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<Attachment?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<dynamic>> downloadTaskAttachment(int taskId, int attachmentId) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: '/api/attachments/{attachmentId}/download'
            .replaceFirst('{taskId}', taskId.toString())
            .replaceFirst('{attachmentId}', attachmentId.toString()),
       // isBytesResponse: true,
      );
      return result.when(
        success: (Response response) async {
          return ApiResultModel<dynamic>.success(data: response.data);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<dynamic>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }
}
