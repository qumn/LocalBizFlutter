import 'package:local_biz/modal/cart.dart';

import './index.dart' as client;

Future<List<Cart>> fetchCarts({client.PageParam? page}) async {
  final rsp = await client.get<List<dynamic>>('/lb/client/cars', page: page);
  final list = rsp.data?.map((c) => Cart.fromJson(c)).toList();
  return list ?? [];
}

Future<void> delteCarts(Iterable<int> cids) {
  var param = cids.map((cid) => "cids=$cid").join('&');
  if (param.isNotEmpty) {
    param = '?$param';
  }
  return client.delete('/lb/client/cars$param');
}
