import '../modal/merchant.dart';
import './index.dart';

Future<List<Merchant>> getAll() async {
  final rsp = await dio.get<List<dynamic>>('/merchant/list');
  final list = rsp.data?.map((m) => Merchant.fromJson(m)).toList();
  return list ?? [];
}

Future<Merchant?> get(mid) async {
  final rsp = await dio.get('/merchant/$mid');
  var merchant = rsp.data != null ? Merchant.fromJson(rsp.data!) : null;
  return merchant;
}
