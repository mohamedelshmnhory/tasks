import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/task.dart';
import '../../../data/repositories/project/project_repository.dart';

class GetProjectTasksParams {
  final int projectId;
  GetProjectTasksParams(this.projectId);
}

@injectable
class GetProjectTasksUseCase implements BaseParamsUseCase<List<Task>?, GetProjectTasksParams> {
  const GetProjectTasksUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<List<Task>?>> call(GetProjectTasksParams params) {
    return _projectRepository.getProjectTasks(params.projectId);
  }
} 