import 'package:tasks/domain/models/user.dart';
import 'package:injectable/injectable.dart';

import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/repositories/user/user_repository.dart';

@injectable
class GetProfileUseCase implements BaseParamsUseCase<User?, NoParams> {
  const GetProfileUseCase(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<ApiResultModel<User?>> call(NoParams params) {
    return _userRepository.getProfileData();
  }
}
