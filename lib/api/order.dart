import 'package:local_biz/log.dart';
import 'package:local_biz/modal/order.dart';

import './index.dart' as client;


Future<Object> postOrder(Order order) async {
  final rsp = await client.post('/lb/management/order',  order);
  logger.d("post order: ${rsp.data}");
  return rsp.data;
}
