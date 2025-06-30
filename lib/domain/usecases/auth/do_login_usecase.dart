import 'package:injectable/injectable.dart';

import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/request_entities/auth/login/login_request.dart';
import '../../../data/entities/response_entities/login/login_response.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../models/user.dart';

@injectable
class DoLoginUseCase implements BaseParamsUseCase<User?, LoginRequest?> {
  const DoLoginUseCase(this._repository);
  final UserRepository _repository;

  @override
  Future<ApiResultModel<User?>> call(LoginRequest? params) {
    return _repository.doLogin(request: params);
  }
}

@injectable
class RegisterUseCase implements BaseParamsUseCase<User?, LoginRequest> {
  const RegisterUseCase(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<ApiResultModel<User?>> call(LoginRequest params) {
    return _userRepository.register(request: params);
  }
}

@injectable
class RequestOTPUseCase implements BaseParamsUseCase<LoginResponse?, LoginRequest?> {
  const RequestOTPUseCase(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<ApiResultModel<LoginResponse?>> call(LoginRequest? params) {
    return _userRepository.requestOTP(requestModel: params);
  }
}