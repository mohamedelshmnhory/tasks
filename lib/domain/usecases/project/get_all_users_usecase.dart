import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/user.dart';
import '../../../data/repositories/project/project_repository.dart';

@injectable
class GetAllUsersUseCase implements BaseParamsUseCase<List<User>?, NoParams> {
  const GetAllUsersUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<List<User>?>> call(NoParams params) {
    return _projectRepository.getAllUsers();
  }
} 