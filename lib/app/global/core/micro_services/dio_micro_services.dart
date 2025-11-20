import 'package:dio/dio.dart';
import 'package:safe2biz/app/global/core/env/env.dart';
import 'dart:io';

import 'package:safe2biz/app/global/core/interceptors/dio_error_interceptor.dart';

class DioMicroServices {
  static final DioMicroServices _singleton = DioMicroServices._internal();

  late Dio msDio;
  late DioHeaders? _headers;

  DioHeaders get headers =>
      _headers ?? DioHeaders(company: '', userLogin: '', userPassword: '');

  factory DioMicroServices() {
    if (Env.host == null) {
      throw Exception('[DioMicroServices] Env.host no ha sido inicializado');
    }

    _singleton._buildDio();

    return _singleton;
  }

  DioMicroServices._internal();


  void rebuildClient() {
    if (Env.host == null) {
      throw Exception('[DioMicroServices] Env.host no ha sido inicializado');
    }

    _buildDio();
    print('[Dio] Cliente reconstruido con nuevo host: ${Env.host}');
  }

  void _buildDio() {

    final host = Env.host!.startsWith('http://')
        ? Env.host!
        : Env.host!.replaceFirst(RegExp(r'^https?://'), 'http://');

    msDio = Dio(BaseOptions(
      connectTimeout: 9000000,
      receiveTimeout: 70000,
      baseUrl: host,
      followRedirects: false,
      headers: {
        Headers.contentTypeHeader: Headers.jsonContentType,
        Headers.acceptHeader: Headers.jsonContentType,
        HttpHeaders.acceptEncodingHeader: 'gzip',
        'App-name': 'Safe2App',
        'App-version': 'v0.1',
      },
    ))
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true))
      ..interceptors.add(InterceptorsWrapper(
        onError: (DioError err, ErrorInterceptorHandler handler) async {
          final opts = err.requestOptions;
          final uri = opts.uri;
          final triedHttps = opts.extra['triedHttps'] == true;

          // 2) Si fue HTTP y aún no probamos HTTPS, rehacer por HTTPS
          if (uri.scheme == 'http' && !triedHttps) {
            final httpsHost = opts.baseUrl.replaceFirst(
              'http://',
              'https://',
            );

            final newOptions = opts.copyWith(
              baseUrl: httpsHost,
              extra: {...opts.extra, 'triedHttps': true},
            );

            try {
              final response = await msDio.fetch(newOptions);
              return handler.resolve(response);
            } catch (_) {
              return handler.next(err);
            }
          }
          return handler.next(err);
        },
      ));
  }
}



class DioHeaders {
  DioHeaders({
    required this.userLogin,
    required this.userPassword,
    required this.company,
  });
  String userLogin;
  String userPassword;
  String company;

  DioHeaders copyWith({
    String? userLogin,
    String? userPassword,
    String? company,
  }) =>
      DioHeaders(
        userLogin: userLogin ?? this.userLogin,
        userPassword: userPassword ?? this.userPassword,
        company: company ?? this.company,
      );
}
