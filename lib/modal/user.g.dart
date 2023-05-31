// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as int?,
      deptId: json['deptId'] as int?,
      userName: json['userName'] as String?,
      nickName: json['nickName'] as String?,
      userType: json['userType'] as String?,
      email: json['email'] as String?,
      phonenumber: json['phonenumber'] as String?,
      sex: json['sex'] as String?,
      avatar: json['avatar'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'deptId': instance.deptId,
      'userName': instance.userName,
      'nickName': instance.nickName,
      'userType': instance.userType,
      'email': instance.email,
      'phonenumber': instance.phonenumber,
      'sex': instance.sex,
      'avatar': instance.avatar,
      'status': instance.status,
    };
