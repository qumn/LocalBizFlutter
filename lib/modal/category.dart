import 'package:json_annotation/json_annotation.dart';

import 'commodity.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  int catId;
  int mid;
  String name;
  int priority;
  List<Commodity> commodities;

  Category(
      {required this.catId,
      required this.mid,
      required this.name,
      required this.priority,
      required this.commodities
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
