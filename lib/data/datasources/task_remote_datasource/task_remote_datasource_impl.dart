import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/entitties/based_api_result/error_result_model.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../../application/core/utils/constants/app_constants.dart';
import '../../../application/core/utils/helpers/custom_exceptions/custom_connection_exception.dart';
import '../../entities/task.dart';
import '../../network/dio_strategy_helper/concrete_strategies/get_request_strategy.dart';
import '../../network/dio_strategy_helper/concrete_strategies/put_request_strategy.dart';
import '../../network/dio_strategy_helper/concrete_strategies/delete_request_strategy.dart';
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
  Future<ApiResultModel<void>> updateTask(int id, Task task) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PutRequestStrategy>(),
        uri: TaskByIdEndpoint + id.toString(),
        requestData: task.toJson(),
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
}
