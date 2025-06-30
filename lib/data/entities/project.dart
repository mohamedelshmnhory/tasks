import 'package:json_annotation/json_annotation.dart';
import 'task.dart';
import 'user.dart';

part 'project.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Project {
  final int? id;
  final String name;
  final String? description;
  final int? ownerId;
  final User? owner;
  final List<Task>? tasks;
  final List<User>? members;

  Project({this.id, required this.name, this.description, this.ownerId, this.owner, this.tasks, this.members});

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
