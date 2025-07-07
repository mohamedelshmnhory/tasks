// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: (json['id'] as num?)?.toInt(),
      text: json['text'] as String,
      userId: (json['userId'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'text': instance.text,
      if (instance.userId case final value?) 'userId': value,
      if (instance.user?.toJson() case final value?) 'user': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
    };
