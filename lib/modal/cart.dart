import 'package:json_annotation/json_annotation.dart';
import 'package:local_biz/modal/commodity.dart';
import 'package:local_biz/modal/merchant.dart';
import 'package:local_biz/modal/specification.dart';

part 'cart.g.dart';

enum CartStatus {
  @JsonValue("SELECTED")
  selected,
  @JsonValue("UNSELECTED")
  unselected
}

@JsonSerializable()
class Cart {
  Cart({
    required this.carId,
    required this.count,
    required this.status,
    this.commodity,
    this.specification,
  });
  int carId;
  Commodity? commodity;
  Specification? specification;
  int count;
  CartStatus status;
  Merchant? merchant;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}
