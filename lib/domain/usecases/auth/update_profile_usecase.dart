import 'package:injectable/injectable.dart';

import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/request_entities/auth/login/login_request.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../models/user.dart';

@injectable
class UpdateProfileUseCase implements BaseParamsUseCase<User?, LoginRequest?> {
  const UpdateProfileUseCase(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<ApiResultModel<User?>> call(LoginRequest? params) {
    return _userRepository.updateProfile(model: params);
  }
}
