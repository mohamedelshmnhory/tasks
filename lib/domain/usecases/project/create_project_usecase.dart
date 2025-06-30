import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/project.dart';
import '../../../data/repositories/project/project_repository.dart';

class CreateProjectParams {
  final Project project;
  CreateProjectParams(this.project);
}

@injectable
class CreateProjectUseCase implements BaseParamsUseCase<Project?, CreateProjectParams> {
  const CreateProjectUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<Project?>> call(CreateProjectParams params) {
    return _projectRepository.createProject(params.project);
  }
} 