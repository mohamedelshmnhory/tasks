import 'package:injectable/injectable.dart';

import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/request_entities/auth/logout/logout_request.dart';
import '../../../data/repositories/user/user_repository.dart';

@injectable
class LogoutUseCase implements BaseParamsUseCase<String?, LogoutRequest> {
  LogoutUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<ApiResultModel<String?>> call(LogoutRequest? params) {
    return _userRepository.logout(model: params);
  }
}
