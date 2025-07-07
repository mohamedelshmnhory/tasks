import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../../application/core/commundomain/entitties/based_api_result/error_result_model.dart';
import '../../../../data/entities/comment.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';
import 'package:tasks/data/entities/task.dart';
import 'package:tasks/domain/models/user.dart';
import 'package:tasks/data/repositories/task/task_repository.dart';
import 'dart:io';
import 'package:tasks/domain/usecases/task/get_my_tasks_usecase.dart';
import 'package:tasks/domain/usecases/project/get_project_members_usecase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

@injectable
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository taskRepository;
  final GetMyTasksUseCase getMyTasksUseCase;
  final GetProjectMembersUseCase getProjectMembersUseCase;

  TasksBloc({required this.taskRepository, required this.getMyTasksUseCase, required this.getProjectMembersUseCase}) : super(TaskInitial()) {
    on<LoadTaskDetails>(_onLoadTaskDetails);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
    on<UpdateTaskAssignedUser>(_onUpdateTaskAssignedUser);
    on<UpdateTaskDescription>(_onUpdateTaskDescription);
    on<AddTaskComment>(_onAddTaskComment);
    on<DeleteTaskComment>(_onDeleteTaskComment);
    on<AddTaskAttachment>(_onAddTaskAttachment);
    on<RemoveTaskAttachment>(_onRemoveTaskAttachment);
    on<SubmitTaskUpdates>(_onSubmitTaskUpdates);
    on<LoadTaskComments>(_onLoadTaskComments);
    on<LoadMyTasks>(_onLoadMyTasks);
    on<LoadProjectMembers>(_onLoadProjectMembers);
    on<LoadTaskAttachments>(_onLoadTaskAttachments);
    on<UploadTaskAttachment>(_onUploadTaskAttachment);
    on<DownloadTaskAttachment>(_onDownloadTaskAttachment);
  }

  List<User> allUsers = [];
  Task? _task;
  List<Comment> _comments = [];
  List<File> _attachments = [];
  User? _assignedUser;
  String? _description;

  void _onLoadTaskDetails(LoadTaskDetails event, Emitter<TasksState> emit) async {
    emit(TaskLoading());

    final ApiResultModel<Task?> result = await taskRepository.getTaskById(event.taskId);
    result.when(
      success: (Task? task) {
        _task = task;
        _comments = List<Comment>.from(task?.comments ?? []);
        _attachments = [];
        _assignedUser = task?.assignedUser;
        _description = task?.description;
        add(LoadTaskComments(task!.id!));
        add(LoadTaskAttachments(task.id!));
        emit(TaskLoaded(task: task, comments: _comments, attachments: _attachments, users: allUsers));
      },
      failure: (ErrorResultModel error) {
        emit(TaskUpdateFailure(error.message.toString()));
      },
    );
  }

  void _onUpdateTaskStatus(UpdateTaskStatus event, Emitter<TasksState> emit) {
    if (_task != null) {
      _task = _task!.copyWith(status: event.status);
      emit(TaskLoaded(task: _task!, comments: _comments, attachments: _attachments, users: allUsers));
    }
  }

  void _onUpdateTaskAssignedUser(UpdateTaskAssignedUser event, Emitter<TasksState> emit) {
    _assignedUser = event.user;
    if (_task != null) {
      _task = _task!.copyWith(assignedUser: event.user);
      emit(TaskLoaded(task: _task!, comments: _comments, attachments: _attachments, users: allUsers));
    }
  }

  void _onUpdateTaskDescription(UpdateTaskDescription event, Emitter<TasksState> emit) {
    _description = event.description;
    if (_task != null) {
      _task = _task!.copyWith(description: event.description);
      emit(TaskLoaded(task: _task!, comments: _comments, attachments: _attachments, users: allUsers));
    }
  }

  void _onAddTaskComment(AddTaskComment event, Emitter<TasksState> emit) async {
    if (_task == null) return;
    emit(TaskUpdating());
    final comment = Comment(text: event.comment);
    final result = await taskRepository.addComment(_task!.id!, comment);
    result.when(
      success: (Comment newComment) {
        _comments.add(newComment);
        emit(TaskLoaded(task: _task!, comments: _comments, attachments: _attachments, users: allUsers));
      },
      failure: (ErrorResultModel error) {
        emit(TaskUpdateFailure(error.message.toString()));
      },
    );
  }

  void _onDeleteTaskComment(DeleteTaskComment event, Emitter<TasksState> emit) async {
    if (event.taskId != null && event.commentId != null) {
      emit(TaskUpdating());
      final result = await taskRepository.deleteComment(event.taskId!, event.commentId!);
      result.when(
        success: (_) {
          add(LoadTaskComments(event.taskId!));
        },
        failure: (ErrorResultModel error) {
          emit(TaskUpdateFailure(error.message.toString()));
        },
      );
    } else if (event.commentIndex != null && event.commentIndex! >= 0 && event.commentIndex! < _comments.length) {
      _comments.removeAt(event.commentIndex!);
      emit(TaskLoaded(task: _task!, comments: _comments, attachments: _attachments, users: allUsers));
    }
  }

  void _onAddTaskAttachment(AddTaskAttachment event, Emitter<TasksState> emit) {
    _attachments.add(event.file);
    emit(TaskLoaded(task: _task!, comments: _comments, attachments: _attachments, users: allUsers));
  }

  void _onRemoveTaskAttachment(RemoveTaskAttachment event, Emitter<TasksState> emit) {
    if (event.attachmentIndex >= 0 && event.attachmentIndex < _attachments.length) {
      _attachments.removeAt(event.attachmentIndex);
      emit(TaskLoaded(task: _task!, comments: _comments, attachments: _attachments, users: allUsers));
    }
  }

  void _onSubmitTaskUpdates(SubmitTaskUpdates event, Emitter<TasksState> emit) async {
    if (_task == null) return;
    emit(TaskUpdating());

    final ApiResultModel<Task> result = await taskRepository.updateTask(
      _task!.id!,
      _task!.copyWith(
        description: _description,
        assignedUserId: _assignedUser?.id,
        comments: _comments,
        // attachments: _attachments, // handle attachments if supported by backend
      ),
    );
    result.when(
      success: (Task task) {
        _task = task;
        _comments = task.comments;
        _attachments = [];
        _assignedUser = task.assignedUser;
        _description = task.description;
        add(LoadTaskDetails(task.id!));
        emit(TaskUpdateSuccess());
        emit(TaskLoaded(task: task, comments: _comments, attachments: _attachments, users: allUsers));
      },
      failure: (ErrorResultModel error) {
        emit(TaskUpdateFailure(error.message.toString()));
      },
    );
  }

  void _onLoadTaskComments(LoadTaskComments event, Emitter<TasksState> emit) async {
    emit(TaskLoading());
    final result = await taskRepository.getTaskComments(event.taskId);
    result.when(
      success: (List<Comment>? comments) {
        _comments = comments ?? [];
        emit(TaskLoaded(task: _task!, comments: _comments, attachments: _attachments, users: allUsers));
      },
      failure: (ErrorResultModel error) {
        emit(TaskUpdateFailure(error.message.toString()));
      },
    );
  }

  void _onLoadMyTasks(LoadMyTasks event, Emitter<TasksState> emit) async {
    emit(TaskLoading());
    final result = await getMyTasksUseCase.call(null);
    result.when(
      success: (List<Task>? tasks) {
        emit(MyTasksLoaded(tasks ?? []));
      },
      failure: (ErrorResultModel error) {
        emit(TaskUpdateFailure(error.message.toString()));
      },
    );
  }

  void _onLoadProjectMembers(LoadProjectMembers event, Emitter<TasksState> emit) async {
    emit(TaskLoading());
    final result = await getProjectMembersUseCase.call(GetProjectMembersParams(event.projectId));
    result.when(
      success: (users) {
        allUsers = users ?? [];
        if (_task != null) {
          emit(TaskLoaded(task: _task!, comments: _comments, attachments: _attachments, users: allUsers));
        }
      },
      failure: (ErrorResultModel error) {
        emit(TaskUpdateFailure(error.message.toString()));
      },
    );
  }

  void _onLoadTaskAttachments(LoadTaskAttachments event, Emitter<TasksState> emit) async {
    emit(TaskLoading());
    final result = await taskRepository.getTaskAttachments(event.taskId);
    result.when(
      success: (attachments) {
        emit(TaskAttachmentsLoaded(attachments ?? []));
      },
      failure: (ErrorResultModel error) {
        emit(TaskUpdateFailure(error.message.toString()));
      },
    );
  }

  void _onUploadTaskAttachment(UploadTaskAttachment event, Emitter<TasksState> emit) async {
    emit(TaskLoading());
    final result = await taskRepository.uploadTaskAttachment(event.taskId, event.file);
    result.when(
      success: (attachment) {
        add(LoadTaskAttachments(event.taskId));
      },
      failure: (ErrorResultModel error) {
        emit(TaskUpdateFailure(error.message.toString()));
      },
    );
  }

  void _onDownloadTaskAttachment(DownloadTaskAttachment event, Emitter<TasksState> emit) async {
    emit(TaskLoading());
    final result = await taskRepository.downloadTaskAttachment(event.taskId, event.attachmentId);
    result.when(
      success: (data) async {
        try {
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/attachment_${event.attachmentId}';
          final file = File(filePath);
          List<int> bytes;
          if (data is String) {
            print(filePath);
            bytes = base64Decode(data);
            print(filePath);
          } else if (data is List<int>) {
            bytes = data;
          } else if (data is List) {
            bytes = List<int>.from(data);
          } else {
            throw Exception('Unknown data type for file download');
          }
          print(filePath);
          await file.writeAsBytes(bytes);
          print(filePath);
          await OpenFile.open(filePath);
        } catch (e) {
          print('Failed to open file: $e');
          if (!emit.isDone) emit(TaskUpdateFailure('Failed to open file: $e'));
        }
      },
      failure: (ErrorResultModel error) {
        if (!emit.isDone) emit(TaskUpdateFailure(error.message.toString()));
      },
    );
  }
}
