import './index.dart' as client;
import 'package:local_biz/modal/category.dart';

Future<List<Category>> fetchByMid(int mid, {client.PageParam? page}) async {
  final rsp = await client
      .get<List<dynamic>>('/lb/management/category/list/$mid', page: page);
  final list = rsp.data?.map((m) => Category.fromJson(m)).toList();
  return list ?? [];
}
