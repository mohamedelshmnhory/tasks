import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/repositories/task/task_repository.dart';

class DeleteTaskParams {
  final int id;
  DeleteTaskParams(this.id);
}

@injectable
class DeleteTaskUseCase implements BaseParamsUseCase<void, DeleteTaskParams> {
  const DeleteTaskUseCase(this._taskRepository);
  final TaskRepository _taskRepository;

  @override
  Future<ApiResultModel<void>> call(DeleteTaskParams params) {
    return _taskRepository.deleteTask(params.id);
  }
} 