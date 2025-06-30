import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../entities/task.dart';

abstract class TaskRepository {
  Future<ApiResultModel<Task?>> getTaskById(int id);
  Future<ApiResultModel<void>> updateTask(int id, Task task);
  Future<ApiResultModel<void>> deleteTask(int id);
} 