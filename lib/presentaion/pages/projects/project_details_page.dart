import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasks/application/core/di/app_component/app_component.dart';
import 'package:tasks/application/config/design_system/app_colors.dart';
import 'package:tasks/application/config/design_system/app_style.dart';
import 'package:tasks/data/entities/project.dart';
import 'package:tasks/data/entities/task.dart';
import 'package:tasks/data/entities/task_status.dart';
import 'package:tasks/domain/models/user.dart';
import 'package:tasks/presentaion/widgets/app_size_boxes.dart';
import 'package:tasks/presentaion/widgets/custom_empty_widget.dart';
import 'package:tasks/presentaion/widgets/custom_loading_widget.dart';
import 'package:tasks/presentaion/widgets/custom_scaffold.dart';
import 'package:tasks/presentaion/widgets/custom_text.dart';
import 'package:tasks/presentaion/widgets/custom_toolbar.dart';
import 'package:tasks/presentaion/widgets/drop_down_options.dart';
import 'package:tasks/presentaion/widgets/scaffold_pading.dart';
import 'package:tasks/presentaion/widgets/snackbar_utill.dart';

import '../../../application/core/basecomponents/base_view_model_view.dart';
import '../../../application/core/utils/auto_router_setup/app_router.dart';
import 'bloc/projects_bloc.dart';
import 'bloc/projects_event.dart';
import 'bloc/projects_state.dart';

@RoutePage()
class ProjectDetailsPage extends StatefulWidget {
  final int projectId;

  const ProjectDetailsPage({super.key, required this.projectId});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> with TickerProviderStateMixin {
  final projectsBloc = locator<ProjectsBloc>();
  late TabController _tabController;
  Project? _project;
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];

  // Filter states
  List<TaskStatus> _selectedStatuses = [];
  List<User> _selectedMembers = [];

  // Controllers for adding tasks
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  TaskStatus _selectedTaskStatus = TaskStatus.todo;
  User? _selectedTaskAssignee;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProjectDetails();
    _loadAllUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  void _loadProjectDetails() {
    projectsBloc.add(FetchProjectDetails(widget.projectId));
  }

  void _loadAllUsers() {
    projectsBloc.add(const FetchAllUsers());
  }

  void _applyFilters() {
    setState(() {
      _filteredTasks = _tasks.where((task) {
        bool statusMatch = _selectedStatuses.isEmpty || _selectedStatuses.contains(task.status);
        bool memberMatch =
            _selectedMembers.isEmpty ||
            (task.assignedUserId != null && _selectedMembers.any((member) => member.id == task.assignedUserId));
        return statusMatch && memberMatch;
      }).toList();
    });
  }

  void _showAddTaskDialog() {
    _taskTitleController.clear();
    _taskDescriptionController.clear();
    _selectedTaskStatus = TaskStatus.todo;
    _selectedTaskAssignee = null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomText('Add New Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskTitleController,
                decoration: const InputDecoration(labelText: 'Task Title', border: OutlineInputBorder()),
              ),
              16.heightBox(),
              TextField(
                controller: _taskDescriptionController,
                decoration: const InputDecoration(labelText: 'Description (Optional)', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              16.heightBox(),
              // Status dropdown
              GestureDetector(
                onTap: () {
                  final controller = TextEditingController(text: _getStatusText(_selectedTaskStatus));
                  showDropdownOptions<TaskStatus>(
                    context,
                    controller,
                    (status) => status != null ? _getStatusText(status) : '',
                    items: TaskStatus.values,
                    onChange: (status) {
                      setState(() {
                        _selectedTaskStatus = status;
                      });
                    },
                  );
                },
                child: Container(
                  padding: symmetricPadding(12, 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderGrey),
                    borderRadius: BorderRadius.circular(AppStyle.borderRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(_getStatusText(_selectedTaskStatus), style: AppStyle.meduim14),
                      Icon(Icons.keyboard_arrow_down, color: AppColors.primaryDarkGrey),
                    ],
                  ),
                ),
              ),
              16.heightBox(),
              // Assignee dropdown
              GestureDetector(
                onTap: () {
                  if (_project?.members?.isNotEmpty == true) {
                    final controller = TextEditingController(
                      text: _selectedTaskAssignee?.fullName ?? _selectedTaskAssignee?.userName ?? '',
                    );
                    showDropdownOptions<User>(
                      context,
                      controller,
                      (user) => user?.fullName ?? user?.userName ?? '',
                      items: _project!.members!,
                      onChange: (user) {
                        setState(() {
                          _selectedTaskAssignee = user;
                        });
                      },
                    );
                  }
                },
                child: Container(
                  padding: symmetricPadding(12, 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderGrey),
                    borderRadius: BorderRadius.circular(AppStyle.borderRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        _selectedTaskAssignee?.fullName ?? _selectedTaskAssignee?.userName ?? 'Unassigned',
                        style: AppStyle.meduim14,
                      ),
                      Icon(Icons.keyboard_arrow_down, color: AppColors.primaryDarkGrey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const CustomText('Cancel')),
          ElevatedButton(onPressed: _addTask, child: const CustomText('Add Task')),
        ],
      ),
    );
  }

  void _addTask() {
    if (_taskTitleController.text.trim().isEmpty) {
      context.showMessage(isError: true, 'Task title is required');
      return;
    }

    final task = Task(
      title: _taskTitleController.text.trim(),
      description: _taskDescriptionController.text.trim().isEmpty ? null : _taskDescriptionController.text.trim(),
      projectId: widget.projectId,
      assignedUserId: _selectedTaskAssignee?.id,
      status: _selectedTaskStatus,
    );

    projectsBloc.add(AddProjectTask(widget.projectId, task));
    Navigator.of(context).pop();
  }

  void _showAddMemberDialog() {
    // Get users who are not already members
    final availableUsers = projectsBloc.allUsers.where((user) {
      return !(_project?.members?.any((member) => member.id == user.id) ?? false);
    }).toList();

    if (availableUsers.isEmpty) {
      context.showMessage('No available users to add');
      return;
    }

    User? selectedUser;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomText('Add Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomText('Select a user to add to the project:'),
            16.heightBox(),
            GestureDetector(
              onTap: () {
                final controller = TextEditingController();
                showDropdownOptions<User>(
                  context,
                  controller,
                  (user) => user?.fullName ?? user?.userName ?? '',
                  items: availableUsers,
                  onChange: (user) {
                    selectedUser = user;
                  },
                );
              },
              child: Container(
                padding: symmetricPadding(12, 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderGrey),
                  borderRadius: BorderRadius.circular(AppStyle.borderRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(selectedUser?.fullName ?? selectedUser?.userName ?? 'Select User', style: AppStyle.meduim14),
                    Icon(Icons.keyboard_arrow_down, color: AppColors.primaryDarkGrey),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const CustomText('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (selectedUser != null) {
                projectsBloc.add(AddProjectMember(widget.projectId, selectedUser!.id!));
                Navigator.of(context).pop();
              } else {
                context.showMessage(isError: true, 'Please select a user');
              }
            },
            child: const CustomText('Add Member'),
          ),
        ],
      ),
    );
  }

  void _showRemoveMemberDialog(User member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomText('Remove Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              'Are you sure you want to remove ${member.fullName ?? member.userName} from this project?',
              textAlign: TextAlign.center,
            ),
            8.heightBox(),
            const CustomText(
              'This action cannot be undone.',
              style: TextStyle(color: AppColors.primaryRed, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const CustomText('Cancel')),
          ElevatedButton(
            onPressed: () {
              projectsBloc.add(RemoveProjectMember(widget.projectId, member.id!));
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed, foregroundColor: AppColors.primaryWhite),
            child: const CustomText('Remove'),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return CustomBlocConsumer<ProjectsBloc, ProjectsState>(
      bloc: projectsBloc,
      listener: (context, state) {
        if (state is ProjectDetailsLoaded) {
          setState(() {
            _project = state.project;
            _tasks = state.tasks;
            _filteredTasks = state.tasks;
          });
        } else if (state is AllUsersLoaded) {
          // Users loaded successfully, no need to update UI here
        } else if (state is ProjectOperationSuccess) {
          context.showMessage(state.message);
        } else if (state is ProjectOperationFailure) {
          context.showMessage(isError: true, state.message);
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          appBar: CustomAppBar(title: _project?.name ?? 'Project Details'),
          body: state is ProjectDetailsLoading
              ? const LoadingWidget()
              : state is ProjectsError
              ? _buildErrorWidget()
              : _buildContent(),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.primaryRed),
          16.heightBox(),
          CustomText(
            'Failed to load project details',
            style: AppStyle.bold18.copyWith(color: AppColors.primaryRed),
            textAlign: TextAlign.center,
          ),
          16.heightBox(),
          ElevatedButton(onPressed: _loadProjectDetails, child: const CustomText('Retry')),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_project == null) {
      return const Center(child: CustomText('No project data available'));
    }

    return Column(
      children: [
        _buildProjectInfo(),
        Container(
          padding: symmetricPadding(16, 16),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.primaryDarkGrey,
            indicatorColor: AppColors.primaryColor,
            tabs: const [
              Tab(text: 'Tasks'),
              Tab(text: 'Members'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: [_buildTasksTab(), _buildMembersTab()]),
        ),
      ],
    );
  }

  Widget _buildProjectInfo() {
    return Container(
      padding: symmetricPadding(16, 16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(_project?.name ?? '', style: AppStyle.bold22),
          if (_project?.description != null) ...[
            8.heightBox(),
            CustomText(_project!.description!, style: AppStyle.meduim14.copyWith(color: AppColors.primaryDarkGrey)),
          ],
          12.heightBox(),
          Row(
            children: [
              Icon(Icons.people, size: 16, color: AppColors.primaryColor),
              8.widthBox(),
              CustomText('${_project?.members?.length ?? 0} Members', style: AppStyle.meduim14),
              24.widthBox(),
              Icon(Icons.task, size: 16, color: AppColors.primaryColor),
              8.widthBox(),
              CustomText('${_tasks.length} Tasks', style: AppStyle.meduim14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: symmetricPadding(12, 12),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildStatusFilter()),
              12.widthBox(),
              Expanded(child: _buildMemberFilter()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText('Status', style: AppStyle.meduim12),
        4.heightBox(),
        GestureDetector(
          onTap: () async {
            final controller = TextEditingController(
              text: _selectedStatuses.isNotEmpty ? _selectedStatuses.map(_getStatusText).join(', ') : '',
            );
            showDropdownOptions<TaskStatus>(
              context,
              controller,
              (status) => status != null ? _getStatusText(status) : '',
              items: TaskStatus.values,
              multiSelect: true,
              selectedItems: _selectedStatuses,
              onDone: (selected) {
                setState(() {
                  _selectedStatuses = List<TaskStatus>.from(selected);
                  _applyFilters();
                });
              },
            );
          },
          child: Container(
            padding: symmetricPadding(12, 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGrey),
              borderRadius: BorderRadius.circular(AppStyle.borderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomText(
                    _selectedStatuses.isNotEmpty ? _selectedStatuses.map(_getStatusText).join(', ') : 'All Statuses',
                    style: AppStyle.meduim14,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: AppColors.primaryDarkGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText('Member', style: AppStyle.meduim12),
        4.heightBox(),
        GestureDetector(
          onTap: () async {
            final controller = TextEditingController(
              text: _selectedMembers.isNotEmpty ? _selectedMembers.map((u) => u.fullName ?? u.userName).join(', ') : '',
            );
            showDropdownOptions<User>(
              context,
              controller,
              (user) => user?.fullName ?? user?.userName ?? '',
              items: _project?.members ?? [],
              multiSelect: true,
              selectedItems: _selectedMembers,
              onDone: (selected) {
                setState(() {
                  _selectedMembers = List<User>.from(selected);
                  _applyFilters();
                });
              },
            );
          },
          child: Container(
            padding: symmetricPadding(12, 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGrey),
              borderRadius: BorderRadius.circular(AppStyle.borderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomText(
                    _selectedMembers.isNotEmpty
                        ? _selectedMembers.map((u) => u.fullName ?? u.userName).join(', ')
                        : 'All Members',
                    style: AppStyle.meduim14,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: AppColors.primaryDarkGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersTab() {
    return Stack(
      children: [
        _project?.members?.isNotEmpty == true
            ? ListView.builder(
                padding: symmetricPadding(0, 16),
                itemCount: _project!.members!.length,
                itemBuilder: (context, index) {
                  final member = _project!.members![index];
                  return _buildMemberCard(member);
                },
              )
            : const EmptyWidget(
                icon: Icon(Icons.people_outline, size: 64, color: AppColors.primaryGrey),
                text: 'No members found',
              ),
        // Floating action button for adding members
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _showAddMemberDialog,
            backgroundColor: AppColors.primaryColor,
            tooltip: 'Add Member',
            child: const Icon(Icons.person_add, color: AppColors.primaryWhite),
          ),
        ),
      ],
    );
  }

  Widget _buildTasksTab() {
    return Stack(
      children: [
        Column(
          children: [
            _buildFilterSection(),
            16.heightBox(),
            Expanded(
              child: _filteredTasks.isNotEmpty
                  ? ListView.builder(
                      padding: symmetricPadding(0, 16),
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        return _buildTaskCard(task);
                      },
                    )
                  : const EmptyWidget(
                      icon: Icon(Icons.task_outlined, size: 64, color: AppColors.primaryGrey),
                      text: 'No tasks found',
                    ),
            ),
          ],
        ),
        // Floating action button for adding tasks
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _showAddTaskDialog,
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.add_task, color: AppColors.primaryWhite),
            tooltip: 'Add Task',
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(User member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: symmetricPadding(16, 16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryColor,
            child: Text(
              (member.fullName?.isNotEmpty == true
                  ? member.fullName!.substring(0, 1).toUpperCase()
                  : member.userName.substring(0, 1).toUpperCase()),
              style: AppStyle.bold16.copyWith(color: AppColors.primaryWhite),
            ),
          ),
          16.widthBox(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(member.fullName ?? member.userName, style: AppStyle.bold16),
                CustomText(member.email, style: AppStyle.meduim14.copyWith(color: AppColors.primaryDarkGrey)),
              ],
            ),
          ),
          // Check if this member is the project owner
          if (_project?.owner?.id != member.id) ...[
            IconButton(
              icon: Icon(Icons.remove_circle_outline, color: AppColors.primaryRed, size: 20),
              onPressed: () => _showRemoveMemberDialog(member),
              tooltip: 'Remove Member',
            ),
          ] else ...[
            Container(
              padding: symmetricPadding(6, 12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: CustomText(
                'Owner',
                style: AppStyle.meduim12.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return InkWell(
      onTap: () {
        context.router.push(TaskDetailsRoute(task: task, users: _project?.members ?? [])).then((value) {
          _loadProjectDetails();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: symmetricPadding(16, 16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(AppStyle.borderRadius),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: CustomText(task.title, style: AppStyle.bold16)),
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
              ],
            ),
            if (task.description?.isNotEmpty == true) ...[
              8.heightBox(),
              CustomText(task.description!, style: AppStyle.meduim14.copyWith(color: AppColors.primaryDarkGrey), maxLines: 2),
            ],
            12.heightBox(),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: AppColors.primaryColor),
                8.widthBox(),
                CustomText(task.assignedUserName ?? task.assignedUser?.userName ?? 'Unassigned', style: AppStyle.meduim14),
                const Spacer(),
                Icon(Icons.calendar_today, size: 16, color: AppColors.primaryColor),
                8.widthBox(),
                CustomText('Task #${task.id}', style: AppStyle.meduim14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
