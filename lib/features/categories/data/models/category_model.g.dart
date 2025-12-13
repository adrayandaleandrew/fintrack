// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$CategoryTypeEnumMap, json['type']),
      icon: json['icon'] as String,
      color: json['color'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'type': _$CategoryTypeEnumMap[instance.type]!,
      'icon': instance.icon,
      'color': instance.color,
      'sortOrder': instance.sortOrder,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$CategoryTypeEnumMap = {
  CategoryType.income: 'income',
  CategoryType.expense: 'expense',
};
