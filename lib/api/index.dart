import 'dart:math';

import 'package:dio/dio.dart';
import 'package:local_biz/persistent/persistent.dart';

import '../config.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: backendUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ),
)..interceptors.add(
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
      // TODO: handler 401 unauthorized, go to login page
      return handler.next(e);
    }),
  );
