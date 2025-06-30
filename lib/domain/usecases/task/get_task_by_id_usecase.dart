import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/task.dart';
import '../../../data/repositories/task/task_repository.dart';

class GetTaskByIdParams {
  final int id;
  GetTaskByIdParams(this.id);
}

@injectable
class GetTaskByIdUseCase implements BaseParamsUseCase<Task?, GetTaskByIdParams> {
  const GetTaskByIdUseCase(this._taskRepository);
  final TaskRepository _taskRepository;

  @override
  Future<ApiResultModel<Task?>> call(GetTaskByIdParams params) {
    return _taskRepository.getTaskById(params.id);
  }
} 