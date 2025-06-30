import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/user.dart';

@RoutePage()
class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _employees = [];
  List<User> _filteredEmployees = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployees() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Replace with actual API call
      // Mock data for demonstration
      await Future.delayed(const Duration(seconds: 1));
      _employees = [
        User(id: 1, name: 'John Doe', phone: '+1234567890', avatar: 'https://i.pravatar.cc/150?img=1'),
        User(id: 2, name: 'Jane Smith', phone: '+1987654321', avatar: 'https://i.pravatar.cc/150?img=2'),
        User(id: 3, name: 'Mike Johnson', phone: '+1122334455', avatar: 'https://i.pravatar.cc/150?img=3'),
      ];
      _filteredEmployees = _employees;
    } catch (e) {
      setState(() {
        _error = 'Failed to load employees. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterEmployees(String query) {
    setState(() {
      _filteredEmployees = _employees
          .where(
            (employee) =>
                employee.name?.toLowerCase().contains(query.toLowerCase()) ?? false || (employee.phone?.contains(query) ?? false),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadEmployees)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search employees...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: _filterEmployees,
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadEmployees, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_filteredEmployees.isEmpty) {
      return const Center(child: Text('No employees found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredEmployees.length,
      itemBuilder: (context, index) {
        final employee = _filteredEmployees[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: employee.avatar != null ? NetworkImage(employee.avatar!) : null,
              child: employee.avatar == null ? Text(employee.name?[0].toUpperCase() ?? '?') : null,
            ),
            title: Text(employee.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(employee.phone ?? 'No phone number'),
            trailing: IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                // TODO: Implement call functionality
              },
            ),
            onTap: () {
              // TODO: Navigate to employee details
            },
          ),
        );
      },
    );
  }
}
