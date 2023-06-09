import 'package:json_annotation/json_annotation.dart';
import 'package:local_biz/modal/specification.dart';

import 'category.dart';

part 'commodity.g.dart';

@JsonSerializable()
class Commodity {
  int cid;
  int mid;
  String name;
  String? img;
  String? desc;
  DateTime? createTime;
  DateTime? updateTime;
  Category? category;
  List<Specification> specifications;
  //Null? specifications;
  Commodity(
      {required this.cid,
      required this.mid,
      required this.name,
      this.img,
      this.desc,
      this.specifications = const []});

  factory Commodity.fromJson(Map<String, dynamic> json) =>
      _$CommodityFromJson(json);
  Map<String, dynamic> toJson() => _$CommodityToJson(this);

  @override
  bool operator ==(other) {
    return other is Commodity && other.cid == cid;
  }

  @override
  int get hashCode => cid.hashCode;
}
