import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../entities/task.dart';
import '../../entities/comment.dart';
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
  Future<ApiResultModel<Task>> updateTask(int id, Task task) {
    return remoteDataSource.updateTask(id, task);
  }

  @override
  Future<ApiResultModel<void>> deleteTask(int id) {
    return remoteDataSource.deleteTask(id);
  }

  @override
  Future<ApiResultModel<Comment>> addComment(int taskId, Comment comment) {
    return remoteDataSource.addComment(taskId, comment);
  }

  @override
  Future<ApiResultModel<void>> deleteComment(int taskId, int commentId) {
    return remoteDataSource.deleteComment(taskId, commentId);
  }

  @override
  Future<ApiResultModel<List<Comment>?>> getTaskComments(int taskId) {
    return remoteDataSource.getTaskComments(taskId);
  }

  @override
  Future<ApiResultModel<List<Task>?>> getMyTasks() {
    return remoteDataSource.getMyTasks();
  }

  @override
  Future<ApiResultModel<List<Attachment>?>> getTaskAttachments(int taskId) {
    return remoteDataSource.getTaskAttachments(taskId);
  }

  @override
  Future<ApiResultModel<Attachment?>> uploadTaskAttachment(int taskId, dynamic file) {
    return remoteDataSource.uploadTaskAttachment(taskId, file);
  }

  @override
  Future<ApiResultModel<dynamic>> downloadTaskAttachment(int taskId, int attachmentId) {
    return remoteDataSource.downloadTaskAttachment(taskId, attachmentId);
  }
} 