import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_request.g.dart';
@JsonSerializable()
class LogoutRequest {
  final String? userId;
  final String? deviceId;

  LogoutRequest({this.userId, this.deviceId});
  factory LogoutRequest.fromJson(Map<String, dynamic> json) => _$LogoutRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LogoutRequestToJson(this);
}