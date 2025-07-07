// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      ownerId: (json['ownerId'] as num?)?.toInt(),
      owner: json['owner'] == null
          ? null
          : User.fromJson(json['owner'] as Map<String, dynamic>),
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      tasksNumber: (json['tasksNumber'] as num?)?.toInt(),
      completedTasksNumber: (json['completedTasksNumber'] as num?)?.toInt(),
      membersNumber: (json['membersNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'name': instance.name,
      if (instance.description case final value?) 'description': value,
      if (instance.ownerId case final value?) 'ownerId': value,
      if (instance.owner?.toJson() case final value?) 'owner': value,
      if (instance.tasks?.map((e) => e.toJson()).toList() case final value?)
        'tasks': value,
      if (instance.members?.map((e) => e.toJson()).toList() case final value?)
        'members': value,
      if (instance.tasksNumber case final value?) 'tasksNumber': value,
      if (instance.completedTasksNumber case final value?)
        'completedTasksNumber': value,
      if (instance.membersNumber case final value?) 'membersNumber': value,
    };
