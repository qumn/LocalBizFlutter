import './index.dart' as client;
import 'package:local_biz/modal/commodity.dart';

Future<List<Commodity>> fetchByMid(int mid, {client.PageParam? page}) async {
  final rsp = await client.get<List<dynamic>>('/lb/management/commodity/list',
      page: page, param: {'mid': mid});
  final list = rsp.data?.map((m) => Commodity.fromJson(m)).toList();
  return list ?? [];
}
