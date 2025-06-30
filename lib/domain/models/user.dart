import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.token,
    this.avatar,
    this.id,
    this.name,
    this.phone,
    this.phone_country,
    this.phone_code,
    this.lang,
  });

  final String? token;
  final String? avatar;
  final int? id;
  final String? name;
  final String? phone;
  final String? phone_country;
  final String? phone_code;
  final String? lang;

  // Convert the object to JSON
  Map<String, dynamic> toJson() => {
        'avatar': avatar,
        'id': id,
        'name': name,
        'phone': phone,
        'phone_country': phone_country,
        'phone_code': phone_code,
        'token': token,
        'lang': lang
      };

  // Create the object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'] as String?,
      avatar: json['avatar'] as String?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      phone_country: json['phone_country'] as String?,
      phone_code: json['phone_code'] as String?,
      lang: json['lang'] as String?,
    );
  }

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
    );
  }

  @override
  List<Object?> get props => <Object?>[id, token];
}
