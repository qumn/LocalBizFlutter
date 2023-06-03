import 'package:dio/dio.dart';
import 'package:local_biz/log.dart';
import 'package:local_biz/persistent/persistent.dart';
import '../config.dart';

class PageParam {
  final int num;
  final int size;
  const PageParam({this.num = 1, this.size = 10});
}

Future<Response<T>> delete<T>(String path, [Object? data]) async {
  return await dio.delete(path, data: data);
}

Future<Response<T>> get<T>(String path,
    {PageParam? page, Map<String, dynamic>? param}) async {
  param ??= {};
  if (page != null) {
    param['pageNum'] = page.num;
    param['pageSize'] = page.size;
  }
  return await dio.get(path, queryParameters: param);
}

Future<Response<T>> post<T>(String path, Object? data) async {
  return await dio.post(path, data: data);
}

final dio = Dio(
  BaseOptions(
    baseUrl: backendUrl,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'User-Agent': 'LocalBizMobile/1.0.0'
    },
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ),
)
  ..interceptors.add(
    InterceptorsWrapper(onResponse: (rsp, handler) {
      if (rsp.data['data'] != null) {
        rsp.data = rsp.data['data'];
      }
      return handler.next(rsp);
    }, onRequest: (options, handler) async {
      if (options.path == '/auth/login') {
        return handler.next(options);
      }
      final token = await getToken();
      options.headers['Authorization'] = 'Bearer $token';
      return handler.next(options);
    }, onError: (e, handler) {
      if (e.response?.statusCode == 401) {
        // go to login page
        logger.e("401 unauthorized");
      }
      // TODO: handler 401 unauthorized, go to login page
      return handler.next(e);
    }),
  )
  ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
