import 'package:dio/dio.dart';

import '../config.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: backendUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ),
)..interceptors.add(InterceptorsWrapper(
    onResponse: (rsp, handler) {
      rsp.data = rsp.data['data'];
      return handler.next(rsp);
    },
  ));
