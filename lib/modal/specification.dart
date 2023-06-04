import 'package:json_annotation/json_annotation.dart';
import 'package:local_biz/modal/commodity.dart';
import 'package:local_biz/modal/specification_atb.dart';

part 'specification.g.dart';

@JsonSerializable()
class Specification {
  int sid;
  double price;
  Commodity? commodity;

  @JsonKey(name: "attributes")
  List<SpecificationAtb> atbs;
  Specification({required this.sid, required this.price, this.commodity, this.atbs = const []});

  factory Specification.fromJson(Map<String, dynamic> json) =>
      _$SpecificationFromJson(json);
  Map<String, dynamic> toJson() => _$SpecificationToJson(this);
}
