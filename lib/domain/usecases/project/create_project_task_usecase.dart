import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/task.dart';
import '../../../data/repositories/project/project_repository.dart';

class CreateProjectTaskParams {
  final int projectId;
  final Task task;
  CreateProjectTaskParams(this.projectId, this.task);
}

@injectable
class CreateProjectTaskUseCase implements BaseParamsUseCase<Task?, CreateProjectTaskParams> {
  const CreateProjectTaskUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<Task?>> call(CreateProjectTaskParams params) {
    return _projectRepository.createProjectTask(params.projectId, params.task);
  }
} 