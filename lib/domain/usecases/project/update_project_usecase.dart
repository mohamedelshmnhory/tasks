import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/project.dart';
import '../../../data/repositories/project/project_repository.dart';

class UpdateProjectParams {
  final int id;
  final Project project;
  UpdateProjectParams(this.id, this.project);
}

@injectable
class UpdateProjectUseCase implements BaseParamsUseCase<void, UpdateProjectParams> {
  const UpdateProjectUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<void>> call(UpdateProjectParams params) {
    return _projectRepository.updateProject(params.id, params.project);
  }
} 