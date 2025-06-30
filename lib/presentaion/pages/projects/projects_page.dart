import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasks/application/core/basecomponents/base_view_model_view.dart';
import 'package:tasks/presentaion/pages/auth/bloc/authentication_bloc.dart';
import 'package:tasks/presentaion/widgets/custom_loading_widget.dart';
import 'package:tasks/presentaion/widgets/snackbar_utill.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../../data/entities/project.dart';
import 'bloc/projects_bloc.dart';
import 'bloc/projects_event.dart';
import 'bloc/projects_state.dart';
import '../../../application/core/utils/auto_router_setup/app_router.dart';

@RoutePage()
class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final projectsBloc = locator<ProjectsBloc>();
  String? _selectedStatus;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    // Fetch projects on page load
    Future.microtask(() => projectsBloc.add(const FetchProjects()));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildProjectCard(Project project) {
    // You can adjust this to use real task data from the project
    final int totalTasks = project.tasks?.length ?? 0;
    final int completedTasks = project.tasks?.where((t) => t.status.toString() == 'TaskStatus.Done').length ?? 0;
    final double progress = totalTasks > 0 ? completedTasks / totalTasks : 0;
    final progressColor = progress == 1
        ? Colors.green
        : progress > 0
        ? Colors.orange
        : Colors.blue;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          context.router.push(ProjectDetailsRoute(projectId: project.id!));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(project.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: progressColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      totalTasks > 0 ? '${(progress * 100).toInt()}%' : 'No Tasks',
                      style: TextStyle(color: progressColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(project.description ?? '', style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: totalTasks > 0 ? progress : 0,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${project.members?.length ?? 0} members', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  // You can add due date or other info here if available
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap, bool isSelected = false}) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Task Management',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Manage your tasks efficiently', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Projects',
            onTap: () {
              Navigator.pop(context);
              // context.router.push(const ProjectsRoute());
            },
            isSelected: true,
          ),
          _buildDrawerItem(
            icon: Icons.task,
            title: 'Tasks',
            onTap: () {
              Navigator.pop(context);
              context.router.push(const TasksRoute());
            },
          ),
          _buildDrawerItem(
            icon: Icons.people,
            title: 'Employees',
            onTap: () {
              Navigator.pop(context);
              context.router.push(const EmployeesRoute());
            },
          ),
          _buildDrawerItem(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              Navigator.pop(context);
              context.router.push(const ProfileRoute());
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              locator<AuthenticationBloc>().add(const LogoutEvent(apiRequest: false));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedStatus == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedStatus = selected ? value : null;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(color: isSelected ? Theme.of(context).primaryColor : Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.router.push(const AddProjectRoute()).then((value) {
                if (value == true) {
                  projectsBloc.add(const FetchProjects());
                }
              });
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search projects...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', null),
                      _buildFilterChip('Not Started', 'Not Started'),
                      _buildFilterChip('In Progress', 'In Progress'),
                      _buildFilterChip('Completed', 'Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomBlocConsumer<ProjectsBloc, ProjectsState>(
              bloc: projectsBloc,
              listener: (BuildContext context, ProjectsState state) {
                if (state is ProjectsError) {
                  return context.showMessage(isError: true, state.message);
                }
              },
              builder: (context, state) {
                if (state is ProjectsLoading) {
                  return const LoadingWidget();
                }
                final projects = projectsBloc.projects;
                final filteredProjects = _searchQuery == null || _searchQuery!.isEmpty
                    ? projects
                    : projects.where((project) {
                        final query = _searchQuery!.toLowerCase();
                        return project.name.toLowerCase().contains(query) ||
                            (project.description?.toLowerCase().contains(query) ?? false);
                      }).toList();
                return ListView.builder(
                  itemCount: filteredProjects.length,
                  itemBuilder: (context, index) {
                    return _buildProjectCard(filteredProjects[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
