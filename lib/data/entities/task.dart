import 'package:json_annotation/json_annotation.dart';
import 'project.dart';
import '../../domain/models/user.dart';
import 'task_status.dart';
import 'comment.dart';

part 'task.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Task {
  final int? id;
  final String title;
  final String? description;
  final int projectId;
  final Project? project;
  final int? assignedUserId;
  final String? assignedUserName;
  final User? assignedUser;
  final TaskStatus status;
  List<Comment> comments = [];
  List<Attachment> attachments = [];

  Task({
    this.id,
    required this.title,
    this.description,
    required this.projectId,
    this.project,
    this.assignedUserId,
    this.assignedUserName,
    this.assignedUser,
    required this.status,
    this.comments = const [],
    this.attachments = const [],
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    int? projectId,
    Project? project,
    int? assignedUserId,
    User? assignedUser,
    TaskStatus? status,
    List<Comment>? comments,
    List<Attachment>? attachments,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      project: project ?? this.project,
      assignedUserId: assignedUserId ?? this.assignedUserId,
      assignedUser: assignedUser ?? this.assignedUser,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      attachments: attachments ?? this.attachments,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Attachment {
  final int id;
  final int? taskId;
  final String fileName;
  final String? url;
  final String? filePath;
  final DateTime uploadedAt;
  final Task? task;

  Attachment({
    required this.id,
    required this.taskId,
    required this.fileName,
    required this.url,
    required this.filePath,
    required this.uploadedAt,
    this.task,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}
