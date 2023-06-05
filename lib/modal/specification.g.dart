// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Specification _$SpecificationFromJson(Map<String, dynamic> json) =>
    Specification(
      sid: json['sid'] as int,
      price: (json['price'] as num).toDouble(),
      commodity: json['commodity'] == null
          ? null
          : Commodity.fromJson(json['commodity'] as Map<String, dynamic>),
      atbs: (json['attributes'] as List<dynamic>?)
              ?.map((e) => SpecificationAtb.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SpecificationToJson(Specification instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'price': instance.price,
      'commodity': instance.commodity,
      'attributes': instance.atbs,
    };
