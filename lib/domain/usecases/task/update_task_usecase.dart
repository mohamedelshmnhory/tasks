import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/task.dart';
import '../../../data/repositories/task/task_repository.dart';

class UpdateTaskParams {
  final int id;
  final Task task;
  UpdateTaskParams(this.id, this.task);
}

@injectable
class UpdateTaskUseCase implements BaseParamsUseCase<void, UpdateTaskParams> {
  const UpdateTaskUseCase(this._taskRepository);
  final TaskRepository _taskRepository;

  @override
  Future<ApiResultModel<void>> call(UpdateTaskParams params) {
    return _taskRepository.updateTask(params.id, params.task);
  }
} 