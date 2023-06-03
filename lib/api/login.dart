import './index.dart';

Future<String?> login(
    String usename, String password) async {
  final body = {
    'username': usename,
    'password': password,
  };
  final rsp = await dio.post("/auth/login", data: body);
  return rsp.data != null ? rsp.data['access_token'] : null;
}
