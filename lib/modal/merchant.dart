import 'package:json_annotation/json_annotation.dart';

part 'merchant.g.dart';

@JsonSerializable()
class Merchant {
  Merchant({
    required this.mid,
    required this.name,
    required this.desc,
  });

  int mid;
  String name;
  String desc;
  String? img;
  double? score;
  int? sales;

  factory Merchant.fromJson(Map<String, dynamic> json) =>
      _$MerchantFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantToJson(this);
}
