import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasks/presentaion/widgets/custom_elevated_button.dart';
import 'package:tasks/presentaion/widgets/custom_loading_widget.dart';
import 'package:tasks/presentaion/widgets/snackbar_utill.dart';

import '../../../application/core/basecomponents/base_view_model_view.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../../data/entities/project.dart';
import 'bloc/projects_bloc.dart';
import 'bloc/projects_event.dart';
import 'bloc/projects_state.dart';

@RoutePage()
class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final projectsBloc = locator<ProjectsBloc>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      projectsBloc.add(AddProject(Project(name: _nameController.text, description: _descriptionController.text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBlocConsumer<ProjectsBloc, ProjectsState>(
      bloc: projectsBloc,
      listener: (context, state) {
        if (state is ProjectsError) {
          context.showMessage(isError: true, state.message);
        }
        if (state is ProjectAdded) {
          context.router.maybePop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Add Project')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Project Name', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a project name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  if (state is ProjectsLoading)
                    const LoadingWidget()
                  else
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(onPressed: _submit, title: 'Add Project'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
