import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable(includeIfNull: false)
class LoginRequest {
  String? phone;
  String? phone_country;
  String? country_code;
  String? code;
  String? country_iso_code;
  String? email;
  String? username;
  String? fullName;
  String? passwordHash;
  @JsonKey(name: 'device_type')
  String? deviceType;
  String? version;
  String? buildVersion;
  @JsonKey(name: 'device_token')
  String? fcmDeviceId;
  num? latitude;
  num? longitude;
  num? culture;
  String? Language;
  @JsonKey(includeFromJson: false, includeToJson: false)
  File? image;

  LoginRequest(
      {this.phone,
      this.phone_country,
      this.code,
      this.country_code,
      this.country_iso_code,
      this.email,
      this.username,
      this.fullName,
      this.passwordHash,
      this.deviceType,
      this.buildVersion,
      this.version,
      this.fcmDeviceId,
      this.latitude,
      this.longitude,
      this.culture,
      this.Language,
      this.image}) {
    deviceType = Platform.isAndroid ? 'android' : 'ios';
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
