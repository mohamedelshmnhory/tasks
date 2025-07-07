import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../entities/task.dart';
import '../../entities/comment.dart';

abstract class TaskRepository {
  Future<ApiResultModel<Task?>> getTaskById(int id);
  Future<ApiResultModel<Task>> updateTask(int id, Task task);
  Future<ApiResultModel<void>> deleteTask(int id);
  Future<ApiResultModel<Comment>> addComment(int taskId, Comment comment);
  Future<ApiResultModel<void>> deleteComment(int taskId, int commentId);
  Future<ApiResultModel<List<Comment>?>> getTaskComments(int taskId);
  Future<ApiResultModel<List<Task>?>> getMyTasks();
  Future<ApiResultModel<List<Attachment>?>> getTaskAttachments(int taskId);
  Future<ApiResultModel<Attachment?>> uploadTaskAttachment(int taskId, dynamic file);
  Future<ApiResultModel<dynamic>> downloadTaskAttachment(int taskId, int attachmentId);
} 