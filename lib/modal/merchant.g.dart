// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Merchant _$MerchantFromJson(Map<String, dynamic> json) => Merchant(
      mid: json['mid'] as int,
      name: json['name'] as String,
      desc: json['desc'] as String,
    )
      ..img = json['img'] as String?
      ..score = (json['score'] as num?)?.toDouble()
      ..sales = json['sales'] as int?;

Map<String, dynamic> _$MerchantToJson(Merchant instance) => <String, dynamic>{
      'mid': instance.mid,
      'name': instance.name,
      'desc': instance.desc,
      'img': instance.img,
      'score': instance.score,
      'sales': instance.sales,
    };
