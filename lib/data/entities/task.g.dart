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
      assignedUser: json['assignedUser'] == null
          ? null
          : User.fromJson(json['assignedUser'] as Map<String, dynamic>),
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'title': instance.title,
      if (instance.description case final value?) 'description': value,
      'projectId': instance.projectId,
      if (instance.project?.toJson() case final value?) 'project': value,
      if (instance.assignedUserId case final value?) 'assignedUserId': value,
      if (instance.assignedUser?.toJson() case final value?)
        'assignedUser': value,
      'status': _$TaskStatusEnumMap[instance.status]!,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'todo',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.done: 'done',
};
