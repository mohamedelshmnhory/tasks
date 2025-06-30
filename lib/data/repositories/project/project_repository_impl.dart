import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../entities/project.dart';
import '../../entities/task.dart';
import '../../entities/user.dart';
import '../../datasources/project_remote_datasource/project_remote_datasource.dart';
import 'project_repository.dart';

@Injectable(as: ProjectRepository)
class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl({required this.remoteDataSource});
  final ProjectRemoteDataSource remoteDataSource;

  @override
  Future<ApiResultModel<List<Project>?>> getProjects() {
    return remoteDataSource.getProjects();
  }

  @override
  Future<ApiResultModel<Project?>> getProjectById(int id) {
    return remoteDataSource.getProjectById(id);
  }

  @override
  Future<ApiResultModel<Project?>> createProject(Project project) {
    return remoteDataSource.createProject(project);
  }

  @override
  Future<ApiResultModel<void>> updateProject(int id, Project project) {
    return remoteDataSource.updateProject(id, project);
  }

  @override
  Future<ApiResultModel<void>> deleteProject(int id) {
    return remoteDataSource.deleteProject(id);
  }

  @override
  Future<ApiResultModel<List<Task>?>> getProjectTasks(int projectId) {
    return remoteDataSource.getProjectTasks(projectId);
  }

  @override
  Future<ApiResultModel<Task?>> createProjectTask(int projectId, Task task) {
    return remoteDataSource.createProjectTask(projectId, task);
  }

  @override
  Future<ApiResultModel<List<User>?>> getAllUsers() {
    return remoteDataSource.getAllUsers();
  }

  @override
  Future<ApiResultModel<List<User>?>> getProjectMembers(int projectId) {
    return remoteDataSource.getProjectMembers(projectId);
  }

  @override
  Future<ApiResultModel<void>> addProjectMember(int projectId, int userId) {
    return remoteDataSource.addProjectMember(projectId, userId);
  }

  @override
  Future<ApiResultModel<void>> removeProjectMember(int projectId, int userId) {
    return remoteDataSource.removeProjectMember(projectId, userId);
  }
} 