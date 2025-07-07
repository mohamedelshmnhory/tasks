import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../data/entities/project.dart';
import '../../data/entities/task.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class User extends Equatable {
  final int? id;
  final String userName;
  final String email;
  final String? passwordHash;
  final String? fullName;
  final List<Project>? projects;
  final List<Task>? assignedTasks;
  final String? token;
  final String? avatar;
  final String? name;
  final String? phone;
  final String? phone_country;
  final String? phone_code;
  final String? lang;

  User({
    this.id,
    required this.userName,
    required this.email,
    this.passwordHash,
    this.fullName,
    this.projects,
    this.assignedTasks,
    this.token,
    this.avatar,
    this.name,
    this.phone,
    this.phone_country,
    this.phone_code,
    this.lang,
  });

  User copyWith(User? model) {
    return User(
      token: model?.token ?? token,
      avatar: model?.avatar ?? avatar,
      id: model?.id ?? id,
      name: model?.name ?? name,
      phone: model?.phone ?? phone,
      phone_country: model?.phone_country ?? phone_country,
      phone_code: model?.phone_code ?? phone_code,
      lang: model?.lang ?? lang,
      userName: model?.userName ?? userName,
      email: model?.email ?? email,
      fullName: model?.fullName ?? fullName,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id];
}
