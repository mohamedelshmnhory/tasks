import 'package:equatable/equatable.dart';
import 'package:tasks/data/entities/task.dart';
import 'package:tasks/domain/models/user.dart';
import 'dart:io';

import '../../../../data/entities/comment.dart';

abstract class TasksState extends Equatable {
  const TasksState();
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TasksState {}

class TaskLoading extends TasksState {}

class TaskLoaded extends TasksState {
  final Task task;
  final List<Comment> comments;
  final List<File> attachments;
  final List<User> users;
  const TaskLoaded({required this.task, required this.comments, required this.attachments, required this.users});
  @override
  List<Object?> get props => [task, comments, attachments, users];
}

class TaskUpdating extends TasksState {}

class TaskUpdateSuccess extends TasksState {}

class TaskUpdateFailure extends TasksState {
  final String error;
  const TaskUpdateFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class TaskAttachmentDownloaded extends TasksState {
  final dynamic file;
  final int attachmentId;
  const TaskAttachmentDownloaded(this.file, this.attachmentId);
  @override
  List<Object?> get props => [file];
}

class MyTasksLoaded extends TasksState {
  final List<Task> tasks;
  const MyTasksLoaded(this.tasks);
  @override
  List<Object?> get props => [tasks];
}

class TaskAttachmentsLoaded extends TasksState {
  final List<Attachment> attachments;
  const TaskAttachmentsLoaded(this.attachments);
  @override
  List<Object?> get props => [attachments];
} 