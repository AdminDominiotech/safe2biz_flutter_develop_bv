import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/datasource/api/actos_condiciones_api_datasource.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';

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

// Crea un Dio base (ajusta timeouts según tu necesidad)
  Dio _dio() => Dio(
    BaseOptions(
      baseUrl: 'https://app.safe2biz.com/safe2biz/ws',
      followRedirects: true,
      validateStatus: (s) => s != null && s < 500,
      connectTimeout: 30000, // ms (Dio 4)
      receiveTimeout: 60000,
      sendTimeout: 60000,
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        debugPrint('→ ${o.method} ${o.uri}');
        h.next(o);
      },
      onResponse: (r, h) {
        debugPrint('← ${r.statusCode} ${r.requestOptions.uri}');
        h.next(r);
      },
      onError: (e, h) {
        debugPrint('⨯ ${e.type}  uri=${e.requestOptions.uri}');
        if (e.response != null) {
          debugPrint('⨯ body=${e.response?.data}');
        }
        h.next(e);
      },
    ),
  );

  String _toYMD(String f) {
    // si viene dd/MM/yyyy lo conviertes; si ya viene yyyy-MM-dd, lo dejas
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

    final arroba = (user!.arroba ?? '').trim();           // p.ej. 'safe2biz'
    final systemRoot = (user.enterprise ?? arroba).trim(); // a veces coincide con arroba
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
      // nombre;base64 tal cual lo necesitas:
      'foto_pre_evento': '${a.fotoPreEventoNombre};${a.fotoPreEventoRuta}',
      'foto_evento': '${a.fotoEventoNombre};${a.fotoEventoRuta}',
      'latitud': a.latitud?.toString(),
      'longitud': a.longitud?.toString(),
    };

    // Logs de verificación
    debugPrint('*** Payload AYC (previo a envío) ***');
    debugPrint(const JsonEncoder.withIndent('  ').convert(payload));
    for (final k in ['foto_pre_evento', 'foto_evento']) {
      final parts = (payload[k] as String?)?.split(';') ?? const [];
      final name = parts.isNotEmpty ? parts.first : '';
      final b64 = parts.length > 1 ? parts[1] : '';
      debugPrint('$k.nombre = $name');
      debugPrint('$k.base64 (preview) = ${_truncate(b64)}');
    }

    final dio = _dio();
    final path = '/null/pr_movil_AYC_Inserta_AyC';

    // 3) Envío como x-www-form-urlencoded (suele ser lo que esperan estos WS)
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

/* Si el WS te exige multipart SÍ o SÍ, sustituye el bloque de envío por este:

  final form = FormData.fromMap(payload);
  final resp = await dio.post(
    path,
    data: form,
    options: Options(
      headers: headers,
      // contentType: Headers.multipartFormDataContentType, // Dio lo pone solo con FormData
    ),
  );

*/
}
