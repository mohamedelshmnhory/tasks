import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/repositories/project/project_repository.dart';

class RemoveProjectMemberParams {
  final int projectId;
  final int userId;
  RemoveProjectMemberParams(this.projectId, this.userId);
}

@injectable
class RemoveProjectMemberUseCase implements BaseParamsUseCase<void, RemoveProjectMemberParams> {
  const RemoveProjectMemberUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<void>> call(RemoveProjectMemberParams params) {
    return _projectRepository.removeProjectMember(params.projectId, params.userId);
  }
} 