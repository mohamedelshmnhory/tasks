// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      total: (json['total'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
      per_page: (json['per_page'] as num?)?.toInt(),
      next_page_url: json['next_page_url'] as String?,
      prev_page_url: json['prev_page_url'] as String?,
      current_page: (json['current_page'] as num?)?.toInt(),
      total_pages: (json['total_pages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'count': instance.count,
      'per_page': instance.per_page,
      'next_page_url': instance.next_page_url,
      'prev_page_url': instance.prev_page_url,
      'current_page': instance.current_page,
      'total_pages': instance.total_pages,
    };
