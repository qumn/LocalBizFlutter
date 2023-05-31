import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? userId;
  int? deptId;
  String? userName;
  String? nickName;
  String? userType;
  String? email;
  String? phonenumber;
  String? sex;
  String? avatar;
  String? status;
  // DateTime? createBy;
  // DateTime? createTime;
  // DateTime? updateBy;
  // DateTime? updateTime;

  User({
    this.userId,
    this.deptId,
    this.userName,
    this.nickName,
    this.userType,
    this.email,
    this.phonenumber,
    this.sex,
    this.avatar,
    this.status,
    // this.createBy,
    // this.createTime,
    // this.updateBy,
    // this.updateTime,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
