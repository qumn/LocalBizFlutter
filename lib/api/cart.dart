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


class AddCartParam {
  AddCartParam({
    required this.mid,
    required this.cid,
    required this.sid,
    required this.count,
  });
  int mid;
  int cid;
  int sid;
  int count;

  Map<String, dynamic> toJson() => {
    'mid': mid, // TODO: this is not used. We should remove this field from the API.
    'cid': cid,
    'sid': sid,
    'count': count,
  };
}

Future<void> addCarts(List<AddCartParam> cart) {
  return client.post('/lb/client/cars', cart);
}
