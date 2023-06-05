// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderCreateParam _$OrderCreateParamFromJson(Map<String, dynamic> json) =>
    OrderCreateParam(
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemCreateParam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderCreateParamToJson(OrderCreateParam instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

OrderItemCreateParam _$OrderItemCreateParamFromJson(
        Map<String, dynamic> json) =>
    OrderItemCreateParam(
      sid: json['sid'] as int,
      count: json['count'] as int,
    );

Map<String, dynamic> _$OrderItemCreateParamToJson(
        OrderItemCreateParam instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'count': instance.count,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      oid: json['oid'] as int,
      uid: json['uid'] as int,
      mid: json['mid'] as int,
      totalAmount: json['totalAmount'] as int,
      merchant: json['merchant'] == null
          ? null
          : Merchant.fromJson(json['merchant'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']),
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'oid': instance.oid,
      'uid': instance.uid,
      'mid': instance.mid,
      'totalAmount': instance.totalAmount,
      'merchant': instance.merchant,
      'status': _$OrderStatusEnumMap[instance.status],
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
      'items': instance.items,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.NONPAYMENT: 'NONPAYMENT',
  OrderStatus.PENDING: 'PENDING',
  OrderStatus.CANCELLED: 'CANCELLED',
  OrderStatus.REFUSED: 'REFUSED',
  OrderStatus.SHIPPING: 'SHIPPING',
  OrderStatus.WAITING: 'WAITING',
  OrderStatus.DELIVERED: 'DELIVERED',
};

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      oiid: json['oiid'] as int,
      oid: json['oid'] as int,
      sid: json['sid'] as int,
      count: json['count'] as int,
      appointmentTime: json['appointmentTime'] as String,
      commodity: json['commodity'] == null
          ? null
          : Commodity.fromJson(json['commodity'] as Map<String, dynamic>),
      specification: json['specification'] == null
          ? null
          : Specification.fromJson(
              json['specification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'oiid': instance.oiid,
      'oid': instance.oid,
      'sid': instance.sid,
      'count': instance.count,
      'appointmentTime': instance.appointmentTime,
      'commodity': instance.commodity,
      'specification': instance.specification,
    };
