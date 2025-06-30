import 'package:tasks/data/entities/request_entities/auth/logout/logout_request.dart';
import 'package:injectable/injectable.dart';

import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/entitties/based_api_result/error_result_model.dart';
import '../../../domain/models/user.dart';
import '../../entities/request_entities/auth/login/login_request.dart';
import '../../entities/response_entities/login/login_response.dart';
import 'user_repository.dart';
import '../../datasources/auth_remote_datasource/auth_remote_datasource.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl({required this.remoteDataSource});
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<ApiResultModel<User?>> doLogin({LoginRequest? request}) async {
    final ApiResultModel<LoginResponse?> result = await remoteDataSource.doLogin(request: request);
    return result.when(
      success: (LoginResponse? loginResponse) async {
        return ApiResultModel<User>.success(data: loginResponse!.mapToDomain());
      },
      failure: (ErrorResultModel errorResultModel) {
        return ApiResultModel<User>.failure(errorResultEntity: errorResultModel);
      },
    );
  }

  @override
  Future<ApiResultModel<String?>> logout({LogoutRequest? model}) {
    return remoteDataSource.logout(model: model);
  }

  @override
  Future<ApiResultModel<User?>> getProfileData({String? userId}) {
    return remoteDataSource.getProfileData(userId: userId);
  }

  @override
  Future<ApiResultModel<LoginResponse?>> requestOTP({LoginRequest? requestModel}) {
    return remoteDataSource.register(requestModel: requestModel);
  }

  @override
  Future<ApiResultModel<User?>> updateProfile({LoginRequest? model}) {
    return remoteDataSource.updateProfile(model: model);
  }

  @override
  Future<ApiResultModel<User?>> register({LoginRequest? request}) async {
    final ApiResultModel<LoginResponse?> result = await remoteDataSource.register(requestModel: request);
    return result.when(
      success: (LoginResponse? loginResponse) async {
        return ApiResultModel<User>.success(data: loginResponse!.mapToDomain());
      },
      failure: (ErrorResultModel errorResultModel) {
        return ApiResultModel<User>.failure(errorResultEntity: errorResultModel);
      },
    );
  }
}
