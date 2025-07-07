import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/task.dart';
import '../../../data/repositories/task/task_repository.dart';

@injectable
class GetMyTasksUseCase implements BaseParamsUseCase<List<Task>?, void> {
  const GetMyTasksUseCase(this._taskRepository);
  final TaskRepository _taskRepository;

  @override
  Future<ApiResultModel<List<Task>?>> call(void params) {
    return _taskRepository.getMyTasks();
  }
} 