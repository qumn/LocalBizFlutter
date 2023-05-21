// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUser _$LoginUserFromJson(Map<String, dynamic> json) => LoginUser(
      json['username'] as String,
      json['password'] as String,
      json['uuid'] as String,
      json['code'] as String,
    );

Map<String, dynamic> _$LoginUserToJson(LoginUser instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'uuid': instance.uuid,
      'code': instance.code,
    };
