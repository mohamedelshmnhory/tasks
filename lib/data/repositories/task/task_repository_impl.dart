import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../entities/task.dart';
import '../../datasources/task_remote_datasource/task_remote_datasource.dart';
import 'task_repository.dart';

@Injectable(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl({required this.remoteDataSource});
  final TaskRemoteDataSource remoteDataSource;

  @override
  Future<ApiResultModel<Task?>> getTaskById(int id) {
    return remoteDataSource.getTaskById(id);
  }

  @override
  Future<ApiResultModel<void>> updateTask(int id, Task task) {
    return remoteDataSource.updateTask(id, task);
  }

  @override
  Future<ApiResultModel<void>> deleteTask(int id) {
    return remoteDataSource.deleteTask(id);
  }
} 