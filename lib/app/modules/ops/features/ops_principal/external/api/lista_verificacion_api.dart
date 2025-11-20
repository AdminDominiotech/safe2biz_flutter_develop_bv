import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/auth/features/login/presenter/page/login_page.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/datasource/api/lista_verificacion_api_datasource.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dio/dio.dart';

class ListaVerificacionApi implements ListaVerificacionApiDatasource {
  ListaVerificacionApi({required this.dioMicroServices});
  final DioMicroServices dioMicroServices;

  // Guarda el último opsId generado (ojo si vas a subir varios en paralelo)
  int? _lastOpsId;

  // ----------------- INTERFAZ: métodos que el repo ya espera -----------------
  @override
  Future<bool> saveListaVerificacionApi(
      RegistroGeneral registroGeneral, String userId) async {
    final formData = FormData.fromMap({'user_id': userId});
    final res = await dioMicroServices.msDio.post('/pr_movil_ACC_Actualiza', data: formData);
    if (res.statusCode == 200) return true;
    throw ServerException(statusCode: res.statusCode);
  }

  // Devuelve bool, pero internamente guardamos el opsId
  @override
  Future<bool> saveRegistrosGeneralesApi(
      RegistroGeneral registroGeneral,
      String userId,
      String idSede,
      ) async {
    _lastOpsId = await _saveRegistrosGeneralesInternal(registroGeneral, userId, idSede);
    return true;
  }

  // Recibe 3 params (como la interfaz) y usa el opsId guardado
  @override
  Future<bool> saveRegistrosResultadoApi(
      RegistroResultado registroResultado,
      String userId,
      String idSede,
      ) async {
    if (_lastOpsId == null) {
      throw StateError('Debes llamar primero a saveRegistrosGeneralesApi');
    }
    await _saveRegistrosResultadoInternal(registroResultado, userId, idSede, _lastOpsId!);
    return true;
  }

  // Si tu interfaz TIENE este método, déjalo con la misma firma
  @override
  Future<void> uploadRegistroCompleto(
      RegistroGeneral rg,
      List<RegistroResultado> resultados,
      String userId,
      String idSede,
      ) async {
    final list = resultados.isEmpty ? await _getResultadosLocal(rg.id) : resultados;

    final opsId = await _saveRegistrosGeneralesInternal(rg, userId, idSede);
    for (final rr in list) {
      await _saveRegistrosResultadoInternal(rr, userId, idSede, opsId);
    }
    await _marcarEnviadoLocal(rg.id);

  }


  Future<int> _saveRegistrosGeneralesInternal(
      RegistroGeneral rg,
      String userId,
      String idSede,
      ) async {
    String _to8(String? v) {
      final d = double.tryParse((v ?? '').trim());
      return (d ?? 0).toStringAsFixed(8);
    }

    // Normalización lat/lon (el SP las espera como VARCHAR)
    final latStr = _to8(rg.latitud);
    final lonStr = _to8(rg.longitud);

    // 1) Arma el payload (exacto al SP)
    final Map<String, dynamic> payload = {
      'sc_user_id': int.parse(userId),
      'fb_uea_pe_id': int.parse(idSede),

      // codigo es VARCHAR en el SP
      'codigo': (rg.codigo ?? '').toString(),

      'g_tipo_origen_id': int.tryParse(rg.gTipoOrigenId) ?? 0,
      'fecha_ops': rg.fechaOps,
      'hora_ops': (rg.horaOps.isEmpty ? '00:00:00' : rg.horaOps),
      'turno': rg.turno,
      'fb_area_id': int.tryParse(rg.fbAreaId) ?? 0,
      'g_rol_empresa_id': int.tryParse(rg.gRolEmpresaId) ?? 0,
      'fb_empresa_especializada_id': int.tryParse(rg.fbEmpresaEspecializadaId) ?? 0,
      'fb_empleado_id': int.tryParse(rg.fbEmpleadoId) ?? 0,
      'ops_lista_verificacion_id': int.tryParse(rg.opsListaVerificacionId) ?? 0,

      // lat/long como VARCHAR (SP las convierte)
      'latitud': latStr,
      'longitud': lonStr,

      'ruta_foto': '',
      'id_interno': 0,
      'flag_movil': '1',

      'criterio': rg.criterio,
      'alcance': rg.alcance,

      // === Nuevos (IDs) ===
      'ops_tipo_inspeccion_id': int.tryParse(rg.idOpsTipoInspeccion) ?? 0,
      'ops_sub_tipo_inspeccion_id': int.tryParse(rg.idOpsSubTipoInspeccion) ?? 0,
      'ops_alcance_inspeccion_id': int.tryParse(rg.idOpsAlcanceInspeccion) ?? 0,

      'fb_empleado_verificador_id': int.tryParse(rg.fbVerificadorId) ?? 0,
      'fb_empleado_auditor_id': int.tryParse(rg.fbAuditorId) ?? 0,

      // === Textos ===
      'lista_involucrados': rg.involucrados ?? '',
      'lista_inspectores': rg.inspectores ?? '',

      // Contratista (ID que el SP mapea a empresa destino si viene)
      'ops_contratista_id': int.tryParse(rg.opsContratistaId) ?? 0,

      'tipo_servicio': rg.tipoServicioNombre ?? '',
      'equipo_auditor': rg.equipoAuditor ?? '',
      'personal_auditado': rg.personalAuditado ?? '',
    };

    // 2) Log bonito del payload
    final pretty = const JsonEncoder.withIndent('  ').convert(payload);
    debugPrint('>>> POST /pr_ws_ops_registro_generales_in payload:\n$pretty');

    // 3) Envía
    final formData = FormData.fromMap(payload);

    try {
      final res = await dioMicroServices.msDio.post(
        '/pr_ws_ops_registro_generales_in',
        data: formData,
      );

      debugPrint('<<< statusCode: ${res.statusCode}');
      debugPrint('<<< response: ${res.data}');

      if (res.statusCode != 200) {
        throw ServerException(statusCode: res.statusCode);
      }

      final root = res.data;
      final list = root is Map && root.containsKey('data')
          ? List.from(root['data'])
          : List.from(root);
      final id = list.first['ops_registro_generales_id'] as int;
      debugPrint('<<< ops_registro_generales_id: $id');
      return id;
    } on DioError catch (e) {
      debugPrint('!!! DioException: ${e.message}');
      if (e.response != null) {
        debugPrint('!!! status: ${e.response?.statusCode}');
        debugPrint('!!! body  : ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<void> _saveRegistrosResultadoInternal(
      RegistroResultado rr,
      String userId,
      String idSede,
      int opsId,
      ) async {
    final formData = FormData.fromMap({
      'sc_user_id': int.parse(userId),
      'id_interno': 0,
      'codigo_movil': '',
      'fb_uea_pe_id': int.parse(idSede),
      'ops_registro_generales_id': opsId,
      'ops_lista_verif_pregunta_id': int.parse(rr.opsListaVerifPreguntaId),
      'ops_lista_verif_seccion_id': int.parse(rr.opsListaVerifSeccionId),
      'ops_lista_verif_categoria_id': int.parse(rr.opsListaVerifCategoriaId),
      'ops_lista_verif_resultado_id': int.parse(rr.opsListaVerifResultadoId),
      'observacion': rr.observacion,
      'imagen': '${rr.nombreImagen};${rr.rutaImagen}',

    });

    final res = await dioMicroServices.msDio.post(
      '/pr_ws_ops_registro_resultado_in',
      data: formData,
    );
    if (res.statusCode != 200) {
      throw ServerException(statusCode: res.statusCode);
    }
  }

  Future<List<RegistroResultado>> _getResultadosLocal(int idGeneral) async {
    final db = await LocalSqlite().database;
    final rows = await db.query(
      LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO,
      where: 'ops_registro_generales_id = ?',
      whereArgs: [idGeneral],
    );
    return rows
        .map((m) => RegistroResultadoModel.fromJson(m) as RegistroResultado)
        .toList();
  }

  Future<void> _marcarEnviadoLocal(int idGeneral) async {
    final db = await LocalSqlite().database;
    await db.update(
      LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO,
      {'estado': 1},
      where: 'ops_registro_generales_id = ?',
      whereArgs: [idGeneral],
    );
  }
}