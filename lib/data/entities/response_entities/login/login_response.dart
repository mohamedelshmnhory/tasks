import 'package:json_annotation/json_annotation.dart';

import '../../../../application/core/utils/mapper/data_mapper.dart';
import '../../../../domain/models/user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends DataMapper<User> {
  User? user;
  String? token;

  LoginResponse({this.token, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  User mapToDomain() {
    return User(
      token: token,
      userName: user?.userName ?? '',
      email: user?.email ?? '',
      fullName: user?.fullName ?? '',
      id: user?.id,
      avatar: user?.avatar,
      phone: user?.phone,
      phone_country: user?.phone_country,
      phone_code: user?.phone_code,
      lang: user?.lang,
    );
  }
}
