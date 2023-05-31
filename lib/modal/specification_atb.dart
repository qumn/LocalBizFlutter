import 'package:json_annotation/json_annotation.dart';

part 'specification_atb.g.dart';

@JsonSerializable()
class SpecificationAtb {
  String? key;
  String? value;
  SpecificationAtb({this.key = "", this.value = ""});

  factory SpecificationAtb.fromJson(Map<String, dynamic> json) =>
      _$SpecificationAtbFromJson(json);
  Map<String, dynamic> toJson() => _$SpecificationAtbToJson(this);
}
