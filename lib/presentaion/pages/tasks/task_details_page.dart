import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasks/application/config/design_system/app_colors.dart';
import 'package:tasks/application/config/design_system/app_style.dart';
import 'package:tasks/application/core/di/app_component/app_component.dart';
import 'package:tasks/data/entities/task.dart';
import 'package:tasks/data/entities/task_status.dart';
import 'package:tasks/domain/models/user.dart';
import 'package:tasks/presentaion/widgets/app_size_boxes.dart';
import 'package:tasks/presentaion/widgets/custom_text.dart';
import 'package:tasks/presentaion/widgets/custom_toolbar.dart';
import 'package:file_picker/file_picker.dart';

import '../../../application/core/basecomponents/base_view_model_view.dart';
import '../../../application/core/utils/download_file.dart';
import '../../widgets/custom_loading_widget.dart';
import '../tasks/bloc/tasks_bloc.dart';
import '../tasks/bloc/tasks_event.dart';
import '../tasks/bloc/tasks_state.dart';

@RoutePage()
class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final List<User> users;
  const TaskDetailsPage({super.key, required this.task, required this.users});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final tasksBloc = locator<TasksBloc>();
  late TextEditingController _descriptionController;
  late TextEditingController _commentController;
  TaskStatus? _selectedStatus;
  User? _selectedUser;
  List<Attachment> _attachments = [];

  // Download progress state
  double? _downloadProgress;
  int? _downloadingAttachmentIndex;

  @override
  void initState() {
    super.initState();
    tasksBloc.add(LoadTaskDetails(widget.task.id!));
    if (widget.users.isEmpty) {
      tasksBloc.add(LoadProjectMembers(widget.task.projectId));
    } else {
      tasksBloc.allUsers = widget.users;
    }
    _descriptionController = TextEditingController(text: widget.task.description);
    _commentController = TextEditingController();
    _selectedStatus = widget.task.status;
    _selectedUser = widget.task.assignedUser;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBlocConsumer<TasksBloc, TasksState>(
      bloc: tasksBloc,
      listener: (context, state) async {
        if (state is TaskUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task updated successfully!')));
        } else if (state is TaskUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update task: \\${state.error}')));
        } else if (state is TaskLoaded) {
          _selectedStatus = state.task.status;
          _selectedUser = state.task.assignedUser;
          _descriptionController.text = state.task.description ?? '';
          if (state.users.isNotEmpty) {
            setState(() {});
          }
        } else if (state is TaskAttachmentsLoaded) {
          setState(() {
            _attachments = state.attachments;
          });
        }
      },
      buildWhen: (previous, current) => current is TaskLoaded,
      builder: (context, state) {
        if (state is TaskLoading || state is TaskInitial) {
          return const LoadingWidget();
        }
        if (state is TaskLoaded) {
          final task = state.task;
          final comments = state.comments;
          final users = state.users;
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Task Details',
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    tasksBloc.add(SubmitTaskUpdates());
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Task Title
                  CustomText(task.title, style: AppStyle.bold22),
                  8.heightBox(),
                  // Status & Assigned To
                  Row(
                    children: [
                      DropdownButton<TaskStatus>(
                        value: _selectedStatus,
                        items: TaskStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: CustomText(_getStatusText(status), style: AppStyle.meduim12),
                          );
                        }).toList(),
                        onChanged: (status) {
                          setState(() => _selectedStatus = status);
                          tasksBloc.add(UpdateTaskStatus(status!));
                        },
                      ),
                      16.widthBox(),
                      Icon(Icons.person, size: 18, color: AppColors.primaryColor),
                      4.widthBox(),
                      DropdownButton<User?>(
                        value: _selectedUser,
                        items: users.map((user) {
                          return DropdownMenuItem(
                            value: user,
                            child: CustomText(user.fullName ?? user.userName, style: AppStyle.meduim14),
                          );
                        }).toList(),
                        onChanged: (user) {
                          setState(() => _selectedUser = user);
                          tasksBloc.add(UpdateTaskAssignedUser(user));
                        },
                      ),
                    ],
                  ),
                  16.heightBox(),
                  // Description
                  CustomText('Description', style: AppStyle.bold16),
                  4.heightBox(),
                  TextField(
                    controller: _descriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (desc) {
                      tasksBloc.add(UpdateTaskDescription(desc));
                    },
                  ),
                  16.heightBox(),
                  // Attachments (UI only)
                  CustomText('Attachments', style: AppStyle.bold16),
                  4.heightBox(),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.upload_file, color: Colors.white),
                        label: Text('Upload Attachment', style: AppStyle.meduim14.copyWith(color: Colors.white)),
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles();
                          if (result != null && result.files.single.path != null) {
                            tasksBloc.add(UploadTaskAttachment(widget.task.id!, result.files.single));
                          }
                        },
                      ),
                    ],
                  ),
                  10.heightBox(),
                  _attachments.isEmpty
                      ? Container(
                          height: 80,
                          decoration: BoxDecoration(color: AppColors.primaryLiteGrey, borderRadius: BorderRadius.circular(12)),
                          child: Center(child: CustomText('No attachments', style: AppStyle.meduim14)),
                        )
                      : SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _attachments.length,
                            itemBuilder: (context, index) {
                              final attachment = _attachments[index];
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    width: 300,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: ListTile(
                                        leading: const Icon(Icons.attach_file),
                                        title: Text(attachment.fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
                                        subtitle: Text(
                                          DateFormat('yyyy-MM-dd, hh:mm a').format(attachment.uploadedAt),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: _downloadingAttachmentIndex == index && _downloadProgress != null
                                            ? SizedBox(
                                                width: 60,
                                                child: LinearProgressIndicator(value: _downloadProgress, color: Colors.green),
                                              )
                                            : GestureDetector(
                                                child: const Icon(Icons.download, size: 20),
                                                onTap: () async {
                                                  setState(() {
                                                    _downloadingAttachmentIndex = index;
                                                    _downloadProgress = 0.0;
                                                  });
                                                  try {
                                                    await downloadFile(
                                                      // Use the real URL if available, fallback to the sample
                                                      // 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                                                      attachment.url ??
                                                          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                                                      attachment.fileName,
                                                      onProgress: (progress) {
                                                        setState(() {
                                                          _downloadProgress = progress;
                                                        });
                                                      },
                                                    );
                                                  } finally {
                                                    setState(() {
                                                      _downloadingAttachmentIndex = null;
                                                      _downloadProgress = null;
                                                    });
                                                  }
                                                },
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                  16.heightBox(),
                  // Comments (UI only)
                  CustomText('Comments', style: AppStyle.bold16),
                  8.heightBox(),
                  // Add comment
                  TextField(
                    controller: _commentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderGrey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: AppColors.primaryColor),
                        onPressed: () {
                          if (_commentController.text.trim().isNotEmpty) {
                            tasksBloc.add(AddTaskComment(_commentController.text.trim()));
                            _commentController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  8.heightBox(),
                  ...comments.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Comment'),
                              content: const Text('Are you sure you want to delete this comment?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    tasksBloc.add(
                                      DeleteTaskComment(commentIndex: entry.key, taskId: task.id, commentId: entry.value.id),
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryWhite,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomText(entry.value.text, style: AppStyle.meduim14),
                              4.heightBox(),
                              CustomText(
                                DateFormat('yyyy-MM-dd, hh:mm a').format(entry.value.createdAt ?? DateTime.now()),
                                style: AppStyle.meduim12.copyWith(color: AppColors.primaryDarkGrey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  24.heightBox(),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('Something went wrong')),
        );
      },
    );
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }
}
