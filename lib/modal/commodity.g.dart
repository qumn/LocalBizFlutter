// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commodity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Commodity _$CommodityFromJson(Map<String, dynamic> json) => Commodity(
      cid: json['cid'] as int,
      mid: json['mid'] as int,
      name: json['name'] as String,
      img: json['img'] as String?,
      desc: json['desc'] as String?,
      specifications: (json['specifications'] as List<dynamic>?)
              ?.map((e) => Specification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )
      ..createTime = json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String)
      ..updateTime = json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String)
      ..category = json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>);

Map<String, dynamic> _$CommodityToJson(Commodity instance) => <String, dynamic>{
      'cid': instance.cid,
      'mid': instance.mid,
      'name': instance.name,
      'img': instance.img,
      'desc': instance.desc,
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
      'category': instance.category,
      'specifications': instance.specifications,
    };
