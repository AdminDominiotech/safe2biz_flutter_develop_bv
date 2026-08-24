import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:safe2biz/app/global/core/env/env.dart';
import 'package:safe2biz/app/global/core/http/insecure_http_overrides.dart';

class DioMicroServices {
  static final DioMicroServices _singleton = DioMicroServices._internal();

  late Dio msDio;
  late DioHeaders? _headers;
  bool _initialized = false;

  DioHeaders get headers =>
      _headers ?? DioHeaders(company: '', userLogin: '', userPassword: '');

  factory DioMicroServices() {
    if (Env.host == null) {
      throw Exception('[DioMicroServices] Env.host no ha sido inicializado');
    }

    if (!_singleton._initialized) {
      _singleton._buildDio();
      _singleton._initialized = true;
    }

    return _singleton;
  }

  DioMicroServices._internal();

  void rebuildClient() {
    if (Env.host == null) {
      throw Exception('[DioMicroServices] Env.host no ha sido inicializado');
    }

    _buildDio();
    _initialized = true;
    print('[Dio] Cliente reconstruido con nuevo host: ${Env.host}');
  }

  void _buildDio() {
    final host = Env.host!.startsWith('http://') ||
        Env.host!.startsWith('https://')
        ? Env.host!
        : 'https://${Env.host!}';

    msDio = Dio(
      BaseOptions(
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
      ),
    );

    final adapter = msDio.httpClientAdapter as DefaultHttpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
      print('[Dio] onHttpClientCreate ejecutado');

      client.badCertificateCallback = InsecureHosts.badCertificateCallback;

      return client;
    };

    msDio.interceptors.clear();

    msDio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
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