import 'package:json_annotation/json_annotation.dart';
import 'project.dart';
import 'user.dart';
import 'task_status.dart';

part 'task.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Task {
  final int? id;
  final String title;
  final String? description;
  final int projectId;
  final Project? project;
  final int? assignedUserId;
  final User? assignedUser;
  final TaskStatus status;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.projectId,
    this.project,
    this.assignedUserId,
    this.assignedUser,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
} 