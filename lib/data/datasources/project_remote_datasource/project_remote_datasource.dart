import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../entities/project.dart';
import '../../entities/task.dart';
import '../../../domain/models/user.dart';

abstract class ProjectRemoteDataSource {
  Future<ApiResultModel<List<Project>?>> getProjects();
  Future<ApiResultModel<Project?>> getProjectById(int id);
  Future<ApiResultModel<Project?>> createProject(Project project);
  Future<ApiResultModel<void>> updateProject(int id, Project project);
  Future<ApiResultModel<void>> deleteProject(int id);

  // Tasks under a project
  Future<ApiResultModel<List<Task>?>> getProjectTasks(int projectId);
  Future<ApiResultModel<Task?>> createProjectTask(int projectId, Task task);

  // Users and members management
  Future<ApiResultModel<List<User>?>> getAllUsers();
  Future<ApiResultModel<List<User>?>> getProjectMembers(int projectId);
  Future<ApiResultModel<void>> addProjectMember(int projectId, int userId);
  Future<ApiResultModel<void>> removeProjectMember(int projectId, int userId);
} 