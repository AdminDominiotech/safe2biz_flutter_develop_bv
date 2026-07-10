import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/datasource/api/actos_condiciones_api_datasource.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:dio/adapter.dart';
import '../../../../global/controllers/auth_controller.dart';

class ActosCondicionesApi implements ActosCondicionesApiDatasource {
  ActosCondicionesApi({required this.dioMicroServices});
  final DioMicroServices dioMicroServices;

  String _truncate(String s, {int max = 120}) =>
      s.length <= max ? s : '${s.substring(0, max)}... (len=${s.length})';

  String _mask(String? s) {
    if (s == null || s.isEmpty) return '';
    if (s.length <= 4) return '*' * s.length;
    return '${'*' * (s.length - 4)}${s.substring(s.length - 4)}';
  }

  // ✅ Opción A: _dio() ASYNC y obtiene user con await
  Future<Dio> _dio() async {
    final local = LocalSqlite();
    final auth = AuthController(sqlite: local);
    final user = await auth.getUserFromStorage();

    if (user == null || user.urlApp == null || user.urlApp!.trim().isEmpty) {
      throw Exception('No hay usuario en storage o urlApp está vacío');
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: '${user.urlApp}/ws',
        followRedirects: true,
        validateStatus: (s) => s != null && s < 500,
        connectTimeout: 30000,
        receiveTimeout: 60000,
        sendTimeout: 60000,
      ),
    );

    final adapter = dio.httpClientAdapter as DefaultHttpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        debugPrint('badCertificateCallback host=$host port=$port');
        return host == 'desafe2biz.buenaventura.pe';
      };
      return client;
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          debugPrint('→ ${o.method} ${o.uri}');
          debugPrint('→ headers: ${jsonEncode(o.headers)}');

          if (o.data != null) {
            try {
              final dataStr = o.data.toString();
              debugPrint('→ data: ${_truncate(dataStr, max: 800)}');
            } catch (_) {
              debugPrint('→ data: [no se pudo imprimir]');
            }
          }

          h.next(o);
        },
        onResponse: (r, h) {
          debugPrint('← ${r.statusCode} ${r.requestOptions.uri}');
          debugPrint('← headers: ${r.headers.map}');
          debugPrint('← data: ${_truncate(r.data.toString(), max: 1200)}');
          h.next(r);
        },
        onError: (e, h) {
          debugPrint('⨯ type: ${e.type}');
          debugPrint('⨯ message: ${e.message}');
          debugPrint('⨯ error: ${e.error}');
          debugPrint('⨯ uri: ${e.requestOptions.uri}');
          debugPrint('⨯ method: ${e.requestOptions.method}');
          debugPrint('⨯ headers: ${jsonEncode(e.requestOptions.headers)}');

          try {
            debugPrint('⨯ request data: ${_truncate(e.requestOptions.data.toString(), max: 1200)}');
          } catch (_) {
            debugPrint('⨯ request data: [no se pudo imprimir]');
          }

          if (e.response != null) {
            debugPrint('⨯ statusCode: ${e.response?.statusCode}');
            debugPrint('⨯ response headers: ${e.response?.headers.map}');
            debugPrint('⨯ response body: ${_truncate(e.response?.data.toString() ?? '', max: 2000)}');
          } else {
            debugPrint('⨯ response: null');
          }

          debugPrint('⨯ stackTrace: ${e.stackTrace}');
          h.next(e);
        },
      ),
    );

    return dio;
  }
  String _toYMD(String f) {
    final p = f.split('/');
    if (p.length == 3 && p[0].length <= 2) {
      return '${p[2]}-${p[1].padLeft(2, '0')}-${p[0].padLeft(2, '0')}';
    }
    return f;
  }

  Future<bool> saveActoCondicionApi(ActoCondicion a) async {
    // 1) Usuario y cabeceras
    final local = LocalSqlite();
    final auth = AuthController(sqlite: local);
    final user = await auth.getUserFromStorage();

    final arroba = (user!.arroba ?? '').trim();
    final systemRoot = (user.enterprise ?? arroba).trim();
    final userLoginHeader = '${user.userLogin}@$arroba';

    final headers = <String, String>{
      'userLogin': userLoginHeader,
      'userPassword': user.password ?? '',
      'systemRoot': systemRoot,
    };

    debugPrint('*** Headers AYC (sin password) ***');
    debugPrint(jsonEncode({
      'userLogin': userLoginHeader,
      'userPassword': _mask(user.password),
      'systemRoot': systemRoot,
    }));

    // 2) Payload
    final payload = <String, dynamic>{
      'empleado': a.fbEmpleadoId?.toString(),
      'uea': a.fbUeaPeId?.toString(),
      'origen': a.origen?.toString(),
      'desviacion': a.gTipoCausaId?.toString(),
      'empresa': a.fbEmpresaEspecializadaId?.toString(),
      'gerencia': a.fbGerencia?.toString(),
      'area': a.fbAreaId?.toString(),
      'lugar': a.lugar ?? '',
      'fecha': _toYMD(a.fecha ?? ''),
      'hora': a.hora ?? '',
      'tipo_evento': a.tipoEventoId?.toString(),
      'nivel_riesgo': a.nivelRiesgoId?.toString(),
      'descripcion': a.descripcion ?? '',
      'accion_ejec': a.accionEjec ?? '',
      'corrigio': a.corrigio?.toString(),
      'foto_pre_evento': (a.fotoPreEventoNombre != null &&
          a.fotoPreEventoNombre!.isNotEmpty &&
          a.fotoPreEventoRuta != null &&
          a.fotoPreEventoRuta!.isNotEmpty)
          ? '${a.fotoPreEventoNombre};${a.fotoPreEventoRuta}'
          : '',
      'foto_evento': (a.fotoEventoNombre != null &&
          a.fotoEventoNombre!.isNotEmpty &&
          a.fotoEventoRuta != null &&
          a.fotoEventoRuta!.isNotEmpty)
          ? '${a.fotoEventoNombre};${a.fotoEventoRuta}'
          : '',
      'latitud': a.latitud?.toString(),
      'longitud': a.longitud?.toString(),
      'bsafId': a.bsafId?.toString(),
      'tarjetaRoja': a.tarjetaRoja?.toString()
    };

    
    debugPrint('*** Payload AYC (previo a envío) ***');
    debugPrint(const JsonEncoder.withIndent('  ').convert(payload));

    final dio = await _dio(); // ✅ ahora es await
    final path = '/null/pr_movil_AYC_Inserta_AyC';

    final resp = await dio.post(
      path,
      data: payload,
      options: Options(
        headers: headers,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    debugPrint('*** Response ***');
    debugPrint('uri: ${resp.requestOptions.uri}');
    debugPrint('statusCode: ${resp.statusCode}');
    debugPrint('headers:\n${resp.headers}');
    debugPrint('Response Text:\n${resp.data}');

    if (resp.statusCode == 200) return true;
    throw ServerException(statusCode: resp.statusCode);
  }
}
