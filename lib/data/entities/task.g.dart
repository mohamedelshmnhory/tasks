// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      projectId: (json['projectId'] as num).toInt(),
      project: json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
      assignedUserId: (json['assignedUserId'] as num?)?.toInt(),
      assignedUserName: json['assignedUserName'] as String?,
      assignedUser: json['assignedUser'] == null
          ? null
          : User.fromJson(json['assignedUser'] as Map<String, dynamic>),
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'title': instance.title,
      if (instance.description case final value?) 'description': value,
      'projectId': instance.projectId,
      if (instance.project?.toJson() case final value?) 'project': value,
      if (instance.assignedUserId case final value?) 'assignedUserId': value,
      if (instance.assignedUserName case final value?)
        'assignedUserName': value,
      if (instance.assignedUser?.toJson() case final value?)
        'assignedUser': value,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'comments': instance.comments.map((e) => e.toJson()).toList(),
      'attachments': instance.attachments.map((e) => e.toJson()).toList(),
    };

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'todo',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.done: 'done',
};

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
      id: json['id'] as int,
      taskId: json['taskId'] as int?,
      fileName: json['fileName'] as String,
      url: json['url'] as String,
      filePath: json['filePath'] as String?,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      task: json['task'] == null ? null : Task.fromJson(json['task'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AttachmentToJson(Attachment instance) => <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'fileName': instance.fileName,
      'filePath': instance.filePath,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      if (instance.task != null) 'task': instance.task?.toJson(),
    };
