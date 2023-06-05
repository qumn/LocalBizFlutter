// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:local_biz/modal/commodity.dart';
import 'package:local_biz/modal/merchant.dart';
import 'package:local_biz/modal/specification.dart';

part 'order.g.dart';

@JsonSerializable()
class OrderCreateParam {
  List<OrderItemCreateParam> items;

  OrderCreateParam({required this.items});

  factory OrderCreateParam.fromJson(Map<String, dynamic> json) =>
      _$OrderCreateParamFromJson(json);
  Map<String, dynamic> toJson() => _$OrderCreateParamToJson(this);
}

@JsonSerializable()
class OrderItemCreateParam {
  final int sid;
  final int count;

  OrderItemCreateParam({
    required this.sid,
    required this.count,
  });

  factory OrderItemCreateParam.fromJson(Map<String, dynamic> json) =>
      _$OrderItemCreateParamFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemCreateParamToJson(this);
}

@JsonSerializable()
class Order {
  int oid;
  int uid;
  int mid;
  int totalAmount;
  Merchant? merchant;
  OrderStatus? status;
  List<OrderItem> items;

  Order(
      {required this.oid,
      required this.uid,
      required this.mid,
      required this.totalAmount,
      this.merchant,
      this.status,
      this.items = const []});
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class OrderItem {
  int oiid;
  int oid;
  int sid;
  int count;
  String appointmentTime;
  Commodity? commodity;
  Specification? specification;

  OrderItem(
      {required this.oiid,
      required this.oid,
      required this.sid,
      required this.count,
      required this.appointmentTime,
      required this.commodity,
      required this.specification});
  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

enum OrderStatus {
  NONPAYMENT,
  PENDING,
  CANCELLED,
  REFUSED,
  SHIPPING,
  WAITING,
  DELIVERED
}
