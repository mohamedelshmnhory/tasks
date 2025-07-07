import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tasks/domain/usecases/project/get_project_tasks_usecase.dart';
import 'package:tasks/domain/usecases/project/create_project_task_usecase.dart';
import 'package:tasks/domain/usecases/project/get_project_by_id_usecase.dart';
import 'package:tasks/domain/usecases/project/update_project_usecase.dart';
import 'package:tasks/domain/usecases/project/get_all_users_usecase.dart';
import 'package:tasks/domain/usecases/project/add_project_member_usecase.dart';
import 'package:tasks/domain/usecases/project/remove_project_member_usecase.dart';
import '../../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../../domain/usecases/project/create_project_usecase.dart';
import '../../../../domain/usecases/project/delete_project_usecase.dart';
import '../../../../domain/usecases/project/get_projects_usecase.dart';
import '../../../../application/core/commundomain/entitties/based_api_result/error_result_model.dart';
import '../../../../data/entities/project.dart';
import '../../../../data/entities/task.dart';
import '../../../../domain/models/user.dart';
import 'projects_event.dart';
import 'projects_state.dart';

@injectable
class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjectsUseCase getProjectsUseCase;
  final CreateProjectUseCase addProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;
  final GetProjectTasksUseCase getProjectTasksUseCase;
  final CreateProjectTaskUseCase createProjectTaskUseCase;
  final GetProjectByIdUseCase getProjectByIdUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;
  final AddProjectMemberUseCase addProjectMemberUseCase;
  final RemoveProjectMemberUseCase removeProjectMemberUseCase;

  ProjectsBloc(
    this.getProjectsUseCase,
    this.addProjectUseCase,
    this.updateProjectUseCase,
    this.deleteProjectUseCase,
    this.getProjectTasksUseCase,
    this.createProjectTaskUseCase,
    this.getProjectByIdUseCase,
    this.getAllUsersUseCase,
    this.addProjectMemberUseCase,
    this.removeProjectMemberUseCase,
  ) : super(ProjectsInitial()) {
    on<FetchProjects>(_onFetchProjects);
    on<AddProject>(_onAddProject);
    on<FetchProjectDetails>(_onFetchProjectDetails);
    on<AddProjectTask>(_onAddProjectTask);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
    on<FetchAllUsers>(_onFetchAllUsers);
    on<AddProjectMember>(_onAddProjectMember);
    on<RemoveProjectMember>(_onRemoveProjectMember);
  }
  
  List<Project> projects = [];
  Project? currentProject;
  List<Task> currentProjectTasks = [];
  List<User> allUsers = [];

  Future<void> _onFetchProjects(FetchProjects event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
    final result = await getProjectsUseCase(NoParams());
    result.when(
      success: (List<Project>? projects) {
        this.projects = projects ?? [];
        emit(ProjectsLoaded(projects ?? []));
      },
      failure: (ErrorResultModel error) {
        emit(ProjectsError(error.message ?? 'حدث خطأ أثناء جلب المشاريع'));
      },
    );
  }

  Future<void> _onAddProject(AddProject event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
    final result = await addProjectUseCase(CreateProjectParams(event.project));
    result.when(
      success: (Project? project) {
        projects.add(project!);
        emit(ProjectAdded());
      },
      failure: (ErrorResultModel error) {
        emit(ProjectsError(error.message ?? 'حدث خطاء اثناء اضافة المشروع'));
      },
    );
  }

  Future<void> _onFetchProjectDetails(FetchProjectDetails event, Emitter<ProjectsState> emit) async {
    emit(ProjectDetailsLoading());
    
    try {
      // Load project details
      final projectResult = await getProjectByIdUseCase(GetProjectByIdParams(event.projectId));
      
      projectResult.when(
        success: (Project? project) {
          if (project != null) {
            currentProject = project;
            currentProjectTasks = project.tasks ?? [];
            emit(ProjectDetailsLoaded(project, currentProjectTasks));
          } else {
            emit(ProjectsError('Project not found'));
          }
        },
        failure: (ErrorResultModel error) {
          emit(ProjectsError(error.message ?? 'Failed to load project'));
        },
      );

      // Load project tasks
      final tasksResult = await getProjectTasksUseCase(GetProjectTasksParams(event.projectId));
      
      tasksResult.when(
        success: (List<Task>? tasks) {
          if (tasks != null) {
            currentProjectTasks = tasks;
            if (currentProject != null) {
              emit(ProjectDetailsLoaded(currentProject!, currentProjectTasks));
            }
          }
        },
        failure: (ErrorResultModel error) {
          // Don't override project loading error if it exists
          if (currentProject == null) {
            emit(ProjectsError(error.message ?? 'Failed to load tasks'));
          }
        },
      );
    } catch (e) {
      emit(ProjectsError('An unexpected error occurred'));
    }
  }

  Future<void> _onAddProjectTask(AddProjectTask event, Emitter<ProjectsState> emit) async {
    emit(ProjectDetailsLoading());
    final result = await createProjectTaskUseCase(CreateProjectTaskParams(event.projectId, event.task));
    result.when(
      success: (Task? task) {
        if (task != null) {
          currentProjectTasks.add(task);
          if (currentProject != null) {
            emit(ProjectDetailsLoaded(currentProject!, currentProjectTasks));
          }
          emit(ProjectOperationSuccess('Task added successfully'));
        }
      },
      failure: (ErrorResultModel error) {
        emit(ProjectOperationFailure(error.message ?? 'Failed to add task'));
      },
    );
  }

  Future<void> _onUpdateProject(UpdateProject event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
    final result = await updateProjectUseCase(UpdateProjectParams(event.project.id!, event.project));
    result.when(
      success: (_) {
        final index = projects.indexWhere((p) => p.id == event.project.id);
        if (index != -1) {
          projects[index] = event.project;
        }
        emit(ProjectOperationSuccess('Project updated successfully'));
      },
      failure: (ErrorResultModel error) {
        emit(ProjectOperationFailure(error.message ?? 'Failed to update project'));
      },
    );
  }

  Future<void> _onDeleteProject(DeleteProject event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
    final result = await deleteProjectUseCase(DeleteProjectParams(event.projectId));
    result.when(
      success: (_) {
        projects.removeWhere((p) => p.id == event.projectId);
        emit(ProjectOperationSuccess('Project deleted successfully'));
      },
      failure: (ErrorResultModel error) {
        emit(ProjectOperationFailure(error.message ?? 'Failed to delete project'));
      },
    );
  }

  Future<void> _onFetchAllUsers(FetchAllUsers event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
    final result = await getAllUsersUseCase(NoParams());
    result.when(
      success: (List<User>? users) {
        allUsers = users ?? [];
        emit(AllUsersLoaded(users ?? []));
      },
      failure: (ErrorResultModel error) {
        emit(ProjectsError(error.message ?? 'Failed to load users'));
      },
    );
  }

  Future<void> _onAddProjectMember(AddProjectMember event, Emitter<ProjectsState> emit) async {
    emit(ProjectDetailsLoading());
    final result = await addProjectMemberUseCase(AddProjectMemberParams(event.projectId, event.userId));
    result.when(
      success: (_) {
        // Refresh project details to get updated member list
        add(FetchProjectDetails(event.projectId));
        emit(ProjectOperationSuccess('Member added successfully'));
      },
      failure: (ErrorResultModel error) {
        emit(ProjectOperationFailure(error.message ?? 'Failed to add member'));
      },
    );
  }

  Future<void> _onRemoveProjectMember(RemoveProjectMember event, Emitter<ProjectsState> emit) async {
    emit(ProjectDetailsLoading());
    final result = await removeProjectMemberUseCase(RemoveProjectMemberParams(event.projectId, event.userId));
    result.when(
      success: (_) {
        // Refresh project details to get updated member list
        add(FetchProjectDetails(event.projectId));
        emit(ProjectOperationSuccess('Member removed successfully'));
      },
      failure: (ErrorResultModel error) {
        emit(ProjectOperationFailure(error.message ?? 'Failed to remove member'));
      },
    );
  }
}
