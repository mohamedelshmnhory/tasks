// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      userName: json['userName'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String?,
      fullName: json['fullName'] as String?,
      projects: (json['projects'] as List<dynamic>?)
          ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
      assignedTasks: (json['assignedTasks'] as List<dynamic>?)
          ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'email': instance.email,
      'passwordHash': instance.passwordHash,
      'fullName': instance.fullName,
      'projects': instance.projects?.map((e) => e.toJson()).toList(),
      'assignedTasks': instance.assignedTasks?.map((e) => e.toJson()).toList(),
    };
