import 'package:equatable/equatable.dart';
import '../../../../data/entities/project.dart';
import '../../../../data/entities/task.dart';
import '../../../../domain/models/user.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();
}

class ProjectsInitial extends ProjectsState {
  @override
  List<Object?> get props => [];
}

class ProjectsLoading extends ProjectsState {
  @override
  List<Object?> get props => [];
}

class ProjectDetailsLoading extends ProjectsState {
  @override
  List<Object?> get props => [];
}

class ProjectAdded extends ProjectsState {
  @override
  List<Object?> get props => [];
}

class ProjectsLoaded extends ProjectsState {
  final List<Project> projects;
  const ProjectsLoaded(this.projects);
  @override
  List<Object?> get props => [projects];
}

class ProjectDetailsLoaded extends ProjectsState {
  final Project project;
  final List<Task> tasks;
  const ProjectDetailsLoaded(this.project, this.tasks);
  @override
  List<Object?> get props => [project, tasks];
}

class AllUsersLoaded extends ProjectsState {
  final List<User> users;
  const AllUsersLoaded(this.users);
  @override
  List<Object?> get props => [users];
}

class ProjectsError extends ProjectsState {
  final String message;
  const ProjectsError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProjectOperationSuccess extends ProjectsState {
  final String message;
  const ProjectOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ProjectOperationFailure extends ProjectsState {
  final String message;
  const ProjectOperationFailure(this.message);
  @override
  List<Object?> get props => [message];
}
