import 'package:json_annotation/json_annotation.dart';

import '../../../../application/core/utils/mapper/data_mapper.dart';
import '../../../../domain/models/user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends DataMapper<User> {
  int? id;
  String? name;
  String? phone;
  String? phone_country;
  String? language;
  String? avatar;
  String? token;

  LoginResponse({this.token, this.id, this.name, this.phone, this.phone_country, this.language, this.avatar});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  User mapToDomain() {
    return User(
      id: id,
      name: name,
      phone: phone,
      avatar: avatar,
      token: token,
    );
  }
}
