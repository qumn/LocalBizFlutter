// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      carId: json['carId'] as int,
      count: json['count'] as int,
      status: $enumDecode(_$CartStatusEnumMap, json['status']),
      commodity: json['commodity'] == null
          ? null
          : Commodity.fromJson(json['commodity'] as Map<String, dynamic>),
      specification: json['specification'] == null
          ? null
          : Specification.fromJson(
              json['specification'] as Map<String, dynamic>),
      merchant: json['merchant'] == null
          ? null
          : Merchant.fromJson(json['merchant'] as Map<String, dynamic>),
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
    );

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'carId': instance.carId,
      'commodity': instance.commodity,
      'specification': instance.specification,
      'count': instance.count,
      'status': _$CartStatusEnumMap[instance.status]!,
      'merchant': instance.merchant,
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
    };

const _$CartStatusEnumMap = {
  CartStatus.selected: 'SELECTED',
  CartStatus.unselected: 'UNSELECTED',
};
