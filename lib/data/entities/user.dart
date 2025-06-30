import 'package:json_annotation/json_annotation.dart';
import 'project.dart';
import 'task.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final int? id;
  final String userName;
  final String email;
  final String? passwordHash;
  final String? fullName;
  final List<Project>? projects;
  final List<Task>? assignedTasks;

  User({
    this.id,
    required this.userName,
    required this.email,
    this.passwordHash,
    this.fullName,
    this.projects,
    this.assignedTasks,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
} 