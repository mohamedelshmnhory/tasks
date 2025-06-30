import 'package:json_annotation/json_annotation.dart';

part 'base_api_response.g.dart';

// @JsonSerializable(explicitToJson: true)
// class BaseAPiResponseModel {
//   final bool isSucceeded;
//   final String methodName;
//   final Status status;
//
//   BaseAPiResponseModel({
//     required this.isSucceeded,
//     required this.methodName,
//     required this.status,
//   });
//
//   factory BaseAPiResponseModel.fromJson(Map<String, dynamic> json) =>
//       _$BaseAPiResponseModelFromJson(json);
//
//   // Map<String, dynamic> toJson() => _$BaseAPiResponseModelToJson(this);
// }
//

@JsonSerializable()
class StatusAPI {
  num? code;
  num? subCode;
  String? message;

  StatusAPI({this.code, this.subCode, this.message});

  factory StatusAPI.fromJson(Map<String, dynamic> json) => _$StatusAPIFromJson(json);

  Map<String, dynamic> toJson() => _$StatusAPIToJson(this);
}
