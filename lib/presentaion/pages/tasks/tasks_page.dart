import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../../../domain/enums/task_status.dart';

@RoutePage()
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TaskStatus? _selectedStatus;
  String? _selectedProject;
  String? _selectedEmployee;

  // Mock data for demonstration
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': 1,
      'title': 'Implement Login Screen',
      'description': 'Create a modern login screen with email and password fields',
      'project': 'Mobile App',
      'employee': 'John Doe',
      'status': TaskStatus.todo,
      'dueDate': DateTime.now().add(const Duration(days: 2)),
    },
    {
      'id': 2,
      'title': 'Design Database Schema',
      'description': 'Design the database schema for the task management system',
      'project': 'Backend',
      'employee': 'Jane Smith',
      'status': TaskStatus.doing,
      'dueDate': DateTime.now().add(const Duration(days: 5)),
    },
    {
      'id': 3,
      'title': 'Write API Documentation',
      'description': 'Document all API endpoints with examples',
      'project': 'Documentation',
      'employee': 'Mike Johnson',
      'status': TaskStatus.done,
      'dueDate': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  List<Map<String, dynamic>> get _filteredTasks {
    return _tasks.where((task) {
      if (_selectedStatus != null && task['status'] != _selectedStatus) {
        return false;
      }
      if (_selectedProject != null && task['project'] != _selectedProject) {
        return false;
      }
      if (_selectedEmployee != null && task['employee'] != _selectedEmployee) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
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
                      labelStyle:  TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(task['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        _buildStatusChip(task['status']),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(task['description']),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildInfoChip(Icons.work, task['project'], Colors.blue),
                              const SizedBox(width: 8),
                              _buildInfoChip(Icons.person, task['employee'], Colors.green),
                              const SizedBox(width: 8),
                              _buildInfoChip(Icons.calendar_today, _formatDate(task['dueDate']), Colors.orange),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // trailing: _buildStatusChip(task['status']),
                    onTap: () {
                      // TODO: Navigate to task details
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
      case TaskStatus.doing:
        color = Colors.orange;
        break;
      case TaskStatus.done:
        color = Colors.green;
        break;
      case TaskStatus.canceled:
        color = Colors.red;
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
