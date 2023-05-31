import 'package:local_biz/log.dart';
import 'package:local_biz/modal/user.dart';

import './index.dart' as client;


Future<User?> getUser() async {
  final rsp = await client.get('/system/user/getInfo');
  logger.d(rsp.data['user']);
  var user = User.fromJson(rsp.data['user']);
  logger.d(user.toJson());
  return user;
}
