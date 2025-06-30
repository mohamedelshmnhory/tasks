import 'package:equatable/equatable.dart';
import '../../../../data/entities/project.dart';
import '../../../../data/entities/task.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();
}

class FetchProjects extends ProjectsEvent {
  const FetchProjects();
  @override
  List<Object?> get props => [];
}

class AddProject extends ProjectsEvent {
  final Project project;
  const AddProject(this.project);
  @override
  List<Object?> get props => [project];
}

class UpdateProject extends ProjectsEvent {
  final Project project;
  const UpdateProject(this.project);
  @override
  List<Object?> get props => [project];
}

class DeleteProject extends ProjectsEvent {
  final int projectId;
  const DeleteProject(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class RefreshProjects extends ProjectsEvent {
  const RefreshProjects();
  @override
  List<Object?> get props => [];
}

class FetchProjectDetails extends ProjectsEvent {
  final int projectId;
  const FetchProjectDetails(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class AddProjectTask extends ProjectsEvent {
  final int projectId;
  final Task task;
  const AddProjectTask(this.projectId, this.task);
  @override
  List<Object?> get props => [projectId, task];
}

class FetchAllUsers extends ProjectsEvent {
  const FetchAllUsers();
  @override
  List<Object?> get props => [];
}

class AddProjectMember extends ProjectsEvent {
  final int projectId;
  final int userId;
  const AddProjectMember(this.projectId, this.userId);
  @override
  List<Object?> get props => [projectId, userId];
}

class RemoveProjectMember extends ProjectsEvent {
  final int projectId;
  final int userId;
  const RemoveProjectMember(this.projectId, this.userId);
  @override
  List<Object?> get props => [projectId, userId];
} 