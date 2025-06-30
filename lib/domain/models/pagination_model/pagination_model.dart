import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_model.g.dart';

@JsonSerializable()
class PaginationModel {
  int? total;
  int? count;
  int? per_page;
  String? next_page_url;
  String? prev_page_url;
  int? current_page;
  int? total_pages;

  PaginationModel(
      {this.total,
      this.count,
      this.per_page,
      this.next_page_url,
      this.prev_page_url,
      this.current_page,
      this.total_pages});

  factory PaginationModel.fromJson(Map<String, dynamic> json) => _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}
