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
      token: json['token'] as String?,
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      phone_country: json['phone_country'] as String?,
      phone_code: json['phone_code'] as String?,
      lang: json['lang'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'userName': instance.userName,
      'email': instance.email,
      if (instance.passwordHash case final value?) 'passwordHash': value,
      if (instance.fullName case final value?) 'fullName': value,
      if (instance.projects?.map((e) => e.toJson()).toList() case final value?)
        'projects': value,
      if (instance.assignedTasks?.map((e) => e.toJson()).toList()
          case final value?)
        'assignedTasks': value,
      if (instance.token case final value?) 'token': value,
      if (instance.avatar case final value?) 'avatar': value,
      if (instance.name case final value?) 'name': value,
      if (instance.phone case final value?) 'phone': value,
      if (instance.phone_country case final value?) 'phone_country': value,
      if (instance.phone_code case final value?) 'phone_code': value,
      if (instance.lang case final value?) 'lang': value,
    };
