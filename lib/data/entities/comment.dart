import 'package:json_annotation/json_annotation.dart';
import '../../domain/models/user.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Comment {
  final int? id;
  final String text;
  final int? userId;
  final User? user;
  final DateTime? createdAt;

  Comment({this.id, required this.text, this.userId, this.user, this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
