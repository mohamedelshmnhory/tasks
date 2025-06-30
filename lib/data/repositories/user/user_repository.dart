import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../domain/models/user.dart';
import '../../entities/request_entities/auth/login/login_request.dart';
import '../../entities/request_entities/auth/logout/logout_request.dart';
import '../../entities/response_entities/login/login_response.dart';

abstract class UserRepository {
  Future<ApiResultModel<User?>> doLogin({LoginRequest? request});
  Future<ApiResultModel<User?>> register({LoginRequest? request});
  Future<ApiResultModel<String?>> logout({LogoutRequest? model});
  Future<ApiResultModel<LoginResponse?>> requestOTP({LoginRequest? requestModel});
  Future<ApiResultModel<User?>> getProfileData({String? userId});
  Future<ApiResultModel<User?>> updateProfile({LoginRequest? model});
}
