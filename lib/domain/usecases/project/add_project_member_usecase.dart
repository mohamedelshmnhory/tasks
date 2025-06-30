import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/repositories/project/project_repository.dart';

class AddProjectMemberParams {
  final int projectId;
  final int userId;
  AddProjectMemberParams(this.projectId, this.userId);
}

@injectable
class AddProjectMemberUseCase implements BaseParamsUseCase<void, AddProjectMemberParams> {
  const AddProjectMemberUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<void>> call(AddProjectMemberParams params) {
    return _projectRepository.addProjectMember(params.projectId, params.userId);
  }
} 