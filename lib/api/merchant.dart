import '../modal/merchant.dart';
import './index.dart' as client;

Future<List<Merchant>> getAll({client.PageParam? page}) async {
  final rsp = await client.get<List<dynamic>>('/lb/management/merchant/list', page: page);
  final list = rsp.data?.map((m) => Merchant.fromJson(m)).toList();
  return list ?? [];
}

Future<Merchant?> get(mid) async {
  final rsp = await client.get('/lb/management/merchant/$mid');
  var merchant = rsp.data?.let(Merchant.fromJson(rsp.data));
  // var merchant = rsp.data != null ? Merchant.fromJson(rsp.data!) : null;
  return merchant;
}
