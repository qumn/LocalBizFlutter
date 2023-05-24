// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      catId: json['catId'] as int,
      mid: json['mid'] as int,
      name: json['name'] as String,
      priority: json['priority'] as int,
      commodities: (json['commodities'] as List<dynamic>)
          .map((e) => Commodity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'catId': instance.catId,
      'mid': instance.mid,
      'name': instance.name,
      'priority': instance.priority,
      'commodities': instance.commodities,
    };
