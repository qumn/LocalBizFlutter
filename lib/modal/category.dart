import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  int catId;
  int mid;
  String name;
  int priority;
  Category(
      {required this.catId,
      required this.mid,
      required this.name,
      required this.priority});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
