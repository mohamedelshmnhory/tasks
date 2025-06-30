import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:tasks/application/config/design_system/app_colors.dart';
import 'package:tasks/application/config/design_system/app_style.dart';
import 'package:tasks/data/entities/task.dart';
import 'package:tasks/data/entities/task_status.dart';
import 'package:tasks/data/entities/user.dart';
import 'package:tasks/presentaion/widgets/app_size_boxes.dart';
import 'package:tasks/presentaion/widgets/custom_text.dart';
import 'package:tasks/presentaion/widgets/custom_toolbar.dart';
import 'package:tasks/presentaion/widgets/custom_elevated_button.dart';

import '../../widgets/scaffold_pading.dart';

@RoutePage()
class TaskDetailsPage extends StatefulWidget {
  final Task task;
  const TaskDetailsPage({super.key, required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [
    // Example comments
    'Looks good!',
    'Please update the description.',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
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


  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return AppColors.primaryOrange;
      case TaskStatus.inProgress:
        return AppColors.primaryYellow;
      case TaskStatus.done:
        return AppColors.primaryColor;
    }
  }


  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _comments.add(text);
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return Scaffold(
      appBar: CustomAppBar(title: 'Task Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            CustomText(task.title, style: AppStyle.bold22),
            8.heightBox(),
            // Status
            Row(
              children: [
                Container(
                  padding: symmetricPadding(6, 12),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatusColor(task.status)),
                  ),
                  child: CustomText(
                    _getStatusText(task.status),
                    style: AppStyle.meduim12.copyWith(color: _getStatusColor(task.status), fontWeight: FontWeight.bold),
                  ),
                ),
                16.widthBox(),
                Icon(Icons.person, size: 18, color: AppColors.primaryColor),
                4.widthBox(),
                CustomText(task.assignedUser?.fullName ?? task.assignedUser?.userName ?? 'Unassigned', style: AppStyle.meduim14),
              ],
            ),
            16.heightBox(),
            // Description
            CustomText('Description', style: AppStyle.bold16),
            4.heightBox(),
            CustomText(task.description ?? 'No description', style: AppStyle.meduim14),
            16.heightBox(),
            // Attachments
            CustomText('Attachments', style: AppStyle.bold16),
            4.heightBox(),
            Container(
              height: 80,
              decoration: BoxDecoration(color: AppColors.primaryLiteGrey, borderRadius: BorderRadius.circular(12)),
              child: Center(child: CustomText('No attachments', style: AppStyle.meduim14)),
            ),
            16.heightBox(),
            // Comments
            CustomText('Comments', style: AppStyle.bold16),
            8.heightBox(),
            ..._comments.map(
              (c) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: CustomText(c, style: AppStyle.meduim14),
                ),
              ),
            ),
            16.heightBox(),
            // Add comment
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderGrey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                8.widthBox(),
                Expanded(
                  flex: 1,
                  child: CustomElevatedButton(title: '>', onPressed: _addComment, filled: true, color: AppColors.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
