import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../models/user.dart';
import '../../../data/repositories/project/project_repository.dart';

class GetProjectMembersParams {
  final int projectId;
  GetProjectMembersParams(this.projectId);
}

@injectable
class GetProjectMembersUseCase implements BaseParamsUseCase<List<User>?, GetProjectMembersParams> {
  const GetProjectMembersUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<List<User>?>> call(GetProjectMembersParams params) {
    return _projectRepository.getProjectMembers(params.projectId);
  }
} 