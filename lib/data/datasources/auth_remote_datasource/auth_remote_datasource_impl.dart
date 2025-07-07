import 'package:dio/dio.dart';
import 'package:tasks/domain/models/user.dart';
import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/entitties/based_api_result/error_result_model.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../../application/core/utils/constants/app_constants.dart';
import '../../../application/core/utils/helpers/custom_exceptions/custom_connection_exception.dart';
import '../../entities/request_entities/auth/login/login_request.dart';
import '../../entities/request_entities/auth/logout/logout_request.dart';
import '../../entities/response_entities/login/login_response.dart';
import '../../network/dio_strategy_helper/concrete_strategies/get_request_strategy.dart';
import '../../network/dio_strategy_helper/concrete_strategies/post_request_strategy.dart';
import '../../network/dio_strategy_helper/dio_request_context.dart';
import 'auth_remote_datasource.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._apiCallHelper);
  final DioRequestContext _apiCallHelper;

  @override
  Future<ApiResultModel<LoginResponse?>> doLogin({LoginRequest? request}) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PostRequestStrategy>(),
        uri: LoginEndpoint,
        requestData: request?.toJson(),
      );
      return result.when(
        success: (Response response) async {
          final user = User.fromJson(response.data['user']);
          final token = response.data['token'];
          // You handle token storage elsewhere
          return ApiResultModel<LoginResponse?>.success(data: LoginResponse.fromJson(response.data));
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<LoginResponse?>.failure(errorResultEntity: errorModel);
        },
      );
    } catch (e) {
      // Handle error as per your pattern
      return ApiResultModel<LoginResponse?>.failure(errorResultEntity: ErrorResultModel(message: e.toString()));
    }
  }

  @override
  Future<ApiResultModel<String?>> logout({LogoutRequest? model}) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PostRequestStrategy>(),
        uri: 'Logout',
      );
      return result.when(
        success: (Response response) async {
          return ApiResultModel<String?>.success(data: response.data["data"]);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<String?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<User?>> getProfileData({String? userId}) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<GetRequestStrategy>(),
        uri: ProfileEndpoint,
      );
      return result.when(
        success: (Response response) async {
          var result = User.fromJson(response.data);
          return ApiResultModel<User?>.success(data: result);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<User?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<LoginResponse?>> register({LoginRequest? requestModel}) async {
    try {
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PostRequestStrategy>(),
        uri: RegisterEndpoint,
        requestData: requestModel?.toJson(),
      );
      return result.when(
        success: (Response response) async {
          var result = LoginResponse.fromJson(response.data);
          return ApiResultModel<LoginResponse?>.success(data: result);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<LoginResponse?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }

  @override
  Future<ApiResultModel<User?>> updateProfile({LoginRequest? model}) async {
    try {
      final formData = FormData.fromMap(model!.toJson());
      if (model.image != null) {
        formData.files.add(MapEntry('avatar', MultipartFile.fromFileSync(model.image!.path)));
      }
      final ApiResultModel<Response> result = await _apiCallHelper.makeRequest(
        dioRequestStrategy: locator<PostRequestStrategy>(),
        uri: ProfileEndpoint,
        formData: formData,
      );
      return result.when(
        success: (Response response) async {
          var result = User.fromJson(response.data['data']);
          return ApiResultModel<User?>.success(data: result);
        },
        failure: (ErrorResultModel errorModel) {
          return ApiResultModel<User?>.failure(errorResultEntity: errorModel);
        },
      );
    } on CustomConnectionException catch (exception) {
      throw CustomConnectionException(exceptionMessage: exception.exceptionMessage, exceptionCode: exception.exceptionCode);
    }
  }
}
