import 'package:equatable/equatable.dart';
import 'package:tasks/data/entities/task.dart';
import 'package:tasks/data/entities/task_status.dart';
import 'package:tasks/domain/models/user.dart';
import 'dart:io';

abstract class TasksEvent extends Equatable {
  const TasksEvent();
  @override
  List<Object?> get props => [];
}

class LoadTaskDetails extends TasksEvent {
  final int taskId;
  const LoadTaskDetails(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class UpdateTaskStatus extends TasksEvent {
  final TaskStatus status;
  const UpdateTaskStatus(this.status);
  @override
  List<Object?> get props => [status];
}

class UpdateTaskAssignedUser extends TasksEvent {
  final User? user;
  const UpdateTaskAssignedUser(this.user);
  @override
  List<Object?> get props => [user];
}

class UpdateTaskDescription extends TasksEvent {
  final String description;
  const UpdateTaskDescription(this.description);
  @override
  List<Object?> get props => [description];
}

class AddTaskComment extends TasksEvent {
  final String comment;
  const AddTaskComment(this.comment);
  @override
  List<Object?> get props => [comment];
}

class DeleteTaskComment extends TasksEvent {
  final int? commentIndex;
  final int? taskId;
  final int? commentId;
  const DeleteTaskComment({this.commentIndex, this.taskId, this.commentId});
  @override
  List<Object?> get props => [commentIndex, taskId, commentId];
}

class LoadTaskComments extends TasksEvent {
  final int taskId;
  const LoadTaskComments(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class AddTaskAttachment extends TasksEvent {
  final File file;
  const AddTaskAttachment(this.file);
  @override
  List<Object?> get props => [file];
}

class RemoveTaskAttachment extends TasksEvent {
  final int attachmentIndex;
  const RemoveTaskAttachment(this.attachmentIndex);
  @override
  List<Object?> get props => [attachmentIndex];
}

class SubmitTaskUpdates extends TasksEvent {
  const SubmitTaskUpdates();
}

class LoadMyTasks extends TasksEvent {
  const LoadMyTasks();
}

class LoadProjectMembers extends TasksEvent {
  final int projectId;
  const LoadProjectMembers(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class LoadTaskAttachments extends TasksEvent {
  final int taskId;
  const LoadTaskAttachments(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class UploadTaskAttachment extends TasksEvent {
  final int taskId;
  final dynamic file;
  const UploadTaskAttachment(this.taskId, this.file);
  @override
  List<Object?> get props => [taskId, file];
}

class DownloadTaskAttachment extends TasksEvent {
  final int taskId;
  final int attachmentId;
  const DownloadTaskAttachment(this.taskId, this.attachmentId);
  @override
  List<Object?> get props => [taskId, attachmentId];
} 