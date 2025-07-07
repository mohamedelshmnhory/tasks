import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../application/core/basecomponents/base_view_model_view.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../../application/core/utils/auto_router_setup/app_router.dart';
import '../../../data/entities/task.dart';
import '../../../data/entities/task_status.dart';
import 'bloc/tasks_bloc.dart';
import 'bloc/tasks_state.dart';
import 'bloc/tasks_event.dart';

@RoutePage()
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final tasksBloc = locator<TasksBloc>();
  List<Task> tasks = [];
  TaskStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    tasksBloc.add(const LoadMyTasks());
  }

  @override
  Widget build(BuildContext context) {
    return CustomBlocConsumer<TasksBloc, TasksState>(
      bloc: tasksBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MyTasksLoaded) {
          tasks = state.tasks;
          // Apply status filter if any
          if (_selectedStatus != null) {
            tasks = tasks.where((task) => task.status == _selectedStatus).toList();
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tasks'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // TODO: Implement advanced filtering
                },
              ),
            ],
          ),
          body: state is TaskLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          // Status filter
                          FilterChip(
                            label: const Text('All Status'),
                            selected: _selectedStatus == null,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStatus = null;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ...TaskStatus.values.map((status) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(status.name),
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                selected: _selectedStatus == status,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedStatus = selected ? status : null;
                                  });
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    // Task list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  _buildStatusChip(task.status),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(task.description ?? ''),
                                  const SizedBox(height: 8),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        _buildInfoChip(Icons.work, task.project?.name ?? '', Colors.blue),
                                        const SizedBox(width: 8),
                                        _buildInfoChip(Icons.person, task.assignedUser?.name ?? '', Colors.green),
                                        // const SizedBox(width: 8),
                                        // _buildInfoChip(Icons.calendar_today, _formatDate(task.dueDate), Colors.orange),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                context.router.push(TaskDetailsRoute(task: task, users: []));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: Navigate to add task screen
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(TaskStatus status) {
    Color color;
    switch (status) {
      case TaskStatus.todo:
        color = Colors.grey;
        break;
      case TaskStatus.inProgress:
        color = Colors.orange;
        break;
      case TaskStatus.done:
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Text(
        status.name,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
