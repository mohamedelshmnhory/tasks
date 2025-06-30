// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      phone: json['phone'] as String?,
      phone_country: json['phone_country'] as String?,
      code: json['code'] as String?,
      country_code: json['country_code'] as String?,
      country_iso_code: json['country_iso_code'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      fullName: json['fullName'] as String?,
      passwordHash: json['passwordHash'] as String?,
      deviceType: json['device_type'] as String?,
      buildVersion: json['buildVersion'] as String?,
      version: json['version'] as String?,
      fcmDeviceId: json['device_token'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      culture: json['culture'] as num?,
      Language: json['Language'] as String?,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      if (instance.phone case final value?) 'phone': value,
      if (instance.phone_country case final value?) 'phone_country': value,
      if (instance.country_code case final value?) 'country_code': value,
      if (instance.code case final value?) 'code': value,
      if (instance.country_iso_code case final value?)
        'country_iso_code': value,
      if (instance.email case final value?) 'email': value,
      if (instance.username case final value?) 'username': value,
      if (instance.fullName case final value?) 'fullName': value,
      if (instance.passwordHash case final value?) 'passwordHash': value,
      if (instance.deviceType case final value?) 'device_type': value,
      if (instance.version case final value?) 'version': value,
      if (instance.buildVersion case final value?) 'buildVersion': value,
      if (instance.fcmDeviceId case final value?) 'device_token': value,
      if (instance.latitude case final value?) 'latitude': value,
      if (instance.longitude case final value?) 'longitude': value,
      if (instance.culture case final value?) 'culture': value,
      if (instance.Language case final value?) 'Language': value,
    };
