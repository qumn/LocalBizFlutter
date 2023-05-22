import 'package:json_annotation/json_annotation.dart';

part 'merchant.g.dart';
   //          "mid": 1,
   //          "owner": 100,
   //          "name": "张三的店铺1",
   //          "desc": "一个简短的介绍",
   //          "introImg": "/2023/03/13/Main_body_R_20230313200037A002.png",
   //          "geom": null,
   //          "geomDesc": "湖北省襄阳市襄城区隆中街道湖北文理学院-逸夫图书馆",
   //          "phone": "18086617441",
   //          "createTime": "2023-03-27T20:33:34.583179",
   //          "updateTime": "2023-03-27T20:33:34.583287"

@JsonSerializable()
class Merchant {
  Merchant({
    required this.mid,
    required this.name,
  });

  int mid;
  String name;
  String? desc;
  String? introImg;
  double? score;
  int? sales;

  factory Merchant.fromJson(Map<String, dynamic> json) =>
      _$MerchantFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantToJson(this);
}
