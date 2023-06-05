import 'package:local_biz/log.dart';
import 'package:local_biz/modal/order.dart';

import './index.dart' as client;


Future<Object> postOrder(OrderCreateParam order) async {
  final rsp = await client.post('/lb/management/order',  order);
  logger.d("post order: ${rsp.data}");
  return rsp.data;
}

Future<List<Order>> fetchOrders() async {
  final rsp = await client.get('/lb/management/order/list');
  logger.d("get orders: ${rsp.data}");
  return rsp.data.map<Order>((e) => Order.fromJson(e)).toList();
}
