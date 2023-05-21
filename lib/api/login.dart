
import './index.dart';
import 'package:local_biz/log.dart';

Future<String?> login(
    String usename, String password, String uuid, String code) async {
  final body = {
    'username': usename,
    'password': password,
    'uuid': uuid,
    'code': code
  };
  logger.d("login body: $body");
  final rsp = await dio.post("/auth/login", data: body);
  logger.d("login rsp: ${rsp.data};");
  return rsp.data != null ? rsp.data['access_token'] : null;
}

class Code {
  Code(this.uuid, this.code);
  final String code; // the code image base64
  final String uuid;
}

Future<Code> fetchCode() async {
  final rsp = await dio.get("/code");
  logger.d("get code rsp: ${rsp.data};");
  return Code(rsp.data['uuid'], rsp.data['img']);
}
