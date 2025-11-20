import 'dart:developer';

import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/registro_general.dart';
import 'package:safe2biz/app/modules/planes_accion/data/models/models.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/sac_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/turno_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:sqflite/sqflite.dart';

class SincronizarLocal implements SincronizarLocalDatasource {
  SincronizarLocal({required this.sqlite});
  final LocalSqlite sqlite;

  @override
  Future<List<AreaModel>> getAreasFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_FB_AREA);
      if (result.isNotEmpty) {
        final areas =
            List.from(result).map((item) => AreaModel.fromJson(item)).toList();

        return areas;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<DesviacionModel>> getDesviacionesFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_G_TIPO_CAUSA);
      if (result.isNotEmpty) {
        final desviaciones = List.from(result)
            .map((item) => DesviacionModel.fromJson(item))
            .toList();

        return desviaciones;
      } else {
        throw const LocalFailure(message: 'Error al traer las desviaciones');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<EmpleadoModel>> getEmpleadosFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_AYC_REPORTANTE);
      if (result.isNotEmpty) {
        final empleados = List.from(result)
            .map((item) => EmpleadoModel.fromJson(item))
            .toList();

        return empleados;
      } else {
        throw const LocalFailure(message: 'Error al traer empleados');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<EmpresaEspModel>> getEmpresasEspecializadasFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_FB_EMPRESA_ESPECIALIZADA);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => EmpresaEspModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<GerenciaModel>> getGerenciasFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_FB_GERENCIA);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => GerenciaModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<PlanesAccionModel>> getSacFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA);
      if (result.isNotEmpty) {
        final models =
            List.from(result).map((item) => PlanesAccionModel.fromJson(item)).toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }




  @override
  Future<List<NivelRiesgoModel>> getNivelesRiesgosFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_G_NIVEL_RIESGO);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => NivelRiesgoModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<TipoEventoModel>> getTiposEventosFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_TIPO_RIESGO_AYC);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => TipoEventoModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<DetallePerdida>> getDetallesPerdidasFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_INC_DETALLE_PERDIDA);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => DetallePerdidaModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<PotencialPerdida>> getPotencialesPerdidasFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_INC_POTENCIAL_PERDIDA);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => PotencialPerdidaModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<SubTipoReporte>> getSubTiposReportesFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_INC_SUB_TIPO_REPORTE);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => SubTipoReporteModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<TipoReporte>> getTiposReportesFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_INC_TIPO_REPORTE);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => TipoReporteModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<VerificacionOps>> getVerificacionesOpsFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_OPS_LISTA_VERIFICACION);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => VerificacionOpsModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<CategoriaOps>> getCategoriasOpsFromLocal() async {
    try {
      final db = await sqlite.database;

      final result =
          await db.query(LocalSqlite.TABLE_OPS_LISTA_VERIF_CATEGORIA);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => CategoriaOpsModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<SeccionOps>> getSeccionesOpsFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_OPS_LISTA_VERIF_SECCION);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => SeccionOpsModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<PreguntaOps>> getPreguntasOpsFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_OPS_LISTA_VERIF_PREGUNTA);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => PreguntaOpsModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<Turno>> getTurnosOpsFromLocal() async {
    try {
      final db = await sqlite.database;

      final result = await db.query(LocalSqlite.TABLE_OPS_TURNOS);
      if (result.isNotEmpty) {
        final models =
            List.from(result).map((item) => TurnoModel.fromJson(item)).toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<ResultadoOps>> getResultadoOpsFromLocal() async {
    try {
      final db = await sqlite.database;

      final result =
          await db.query(LocalSqlite.TABLE_OPS_LISTA_VERIF_RESULTADO);
      if (result.isNotEmpty) {
        final models = List.from(result)
            .map((item) => ResultadoOpsModel.fromJson(item))
            .toList();

        return models;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveAreasToLocal(List<Area> areas) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_FB_AREA);
      final batch = db.batch();

      for (final i in areas) {
        batch.insert(LocalSqlite.TABLE_FB_AREA, {
          'fb_area_id': i.id,
          'fb_gerencia_id': i.fbGerenciaId,
          'codigo': i.codigo,
          'nombre': i.nombre,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  Future<bool> saveSacToLocal(List<PlanAccion> sacList, String companyId) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA);

      final batch = db.batch();

      for (final i in sacList) {
        batch.insert(LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA, {
          'sac_accion_correctiva_id': i.id,
          'codigo_accion_correctiva': i.codigo,
          'accion_correctiva_detalle': i.detalle,
          'fecha_acordada_ejecucion': i.fechaEjecucion,
          'nombre_responsable_correccion': i.responsable,
          'origen': i.origen,
          'uea_id': companyId,
          'fecha_origen': i.fechaOrigen,
          'nombre_responsable_verificador': i.responsableVerificador,

          'fecha_ejecucion': "",
          'evidencia_nombre': "",
          'evidencia_ruta': "",
          'estado': "",
          'obs_resp_corr': "",
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveDesviacionesToLocal(List<Desviacion> desviaciones) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_G_TIPO_CAUSA);

      final batch = db.batch();

      for (final i in desviaciones) {
        batch.insert(LocalSqlite.TABLE_G_TIPO_CAUSA, {
          'g_tipo_causa_id': i.id,
          'ayc': i.ayc,
          'descripcion': i.descripcion,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveEmpleadosToLocal(List<Empleado> empleados) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_AYC_REPORTANTE);

      final batch = db.batch();

      for (final i in empleados) {
        batch.insert(LocalSqlite.TABLE_AYC_REPORTANTE, {
          'fb_empleado_id': i.id,
          'fb_uea_pe_id': i.fbUeaPeId,
          'nombreCompleto': i.nombreCompleto,
          'numero_documento': i.numeroDocumento,
          'cargo_nombre': i.cargoNombre,
          'gerencia_nombre': i.gerenciaNombre,
          'empresa': i.empresa,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveEmpresasEspecializadasToLocal(
      List<EmpresaEsp> empresaEsps) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_FB_EMPRESA_ESPECIALIZADA);

      final batch = db.batch();

      for (final i in empresaEsps) {
        batch.insert(LocalSqlite.TABLE_FB_EMPRESA_ESPECIALIZADA, {
          'fb_empresa_especializada_id': i.id,
          'razon_social': i.razonSocial,
          'ruc': i.rucEmpresa,
          'g_rol_empresa_id': i.gRolEmpresaId,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveGerenciasToLocal(List<Gerencia> gerencias) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_FB_GERENCIA);

      final batch = db.batch();

      for (final i in gerencias) {
        batch.insert(LocalSqlite.TABLE_FB_GERENCIA, {
          'fb_gerencia_id': i.id,
          'fb_uea_pe_id': i.fbUeaPeId,
          'codigo': i.codigo,
          'nombre': i.nombre,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveNivelRiesgoToLocal(List<NivelRiesgo> nivelRiesgos) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_G_NIVEL_RIESGO);

      final batch = db.batch();

      for (final i in nivelRiesgos) {
        batch.insert(LocalSqlite.TABLE_G_NIVEL_RIESGO, {
          'g_nivel_riesgo_id': i.id,
          'nombre': i.nombre,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveTipoEventoToLocal(List<TipoEvento> tipoEventos) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_TIPO_RIESGO_AYC);

      final batch = db.batch();

      for (final i in tipoEventos) {
        batch.insert(LocalSqlite.TABLE_TIPO_RIESGO_AYC, {
          'inc_tipo_reporte_id': i.id,
          'nombre': i.nombre,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveDetallesPerdidasToLocal(
    List<DetallePerdida> detallesPerdidas,
  ) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_INC_DETALLE_PERDIDA);

      final batch = db.batch();

      for (final i in detallesPerdidas) {
        batch.insert(LocalSqlite.TABLE_INC_DETALLE_PERDIDA, {
          'inc_segun_tipo_id': i.id,
          'inc_tipo_reporte_id': i.tipoReporteId,
          'nombre': i.nombre,
          'codigo': i.codigo,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> savePotencialesPerdidasToLocal(
    List<PotencialPerdida> potencialPerdida,
  ) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_INC_POTENCIAL_PERDIDA);

      final batch = db.batch();

      for (final i in potencialPerdida) {
        batch.insert(LocalSqlite.TABLE_INC_POTENCIAL_PERDIDA, {
          'inc_potencial_perdida_id': i.id,
          'nombre': i.nombre,
          'codigo': i.codigo,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveSubTiposReportesToLocal(
    List<SubTipoReporte> subTipoReportes,
  ) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_INC_SUB_TIPO_REPORTE);

      final batch = db.batch();

      for (final i in subTipoReportes) {
        batch.insert(LocalSqlite.TABLE_INC_SUB_TIPO_REPORTE, {
          'inc_sub_tipo_reporte_id': i.id,
          'inc_tipo_reporte_id': i.tipoReporteId,
          'nombre': i.nombre,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveTiposReportesToLocal(List<TipoReporte> tipoReportes) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_INC_TIPO_REPORTE);

      final batch = db.batch();

      for (final i in tipoReportes) {
        batch.insert(LocalSqlite.TABLE_INC_TIPO_REPORTE, {
          'inc_tipo_reporte_id': i.id,
          'nombre': i.nombre,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }
  String _up(Object? v) => v?.toString().trim().toUpperCase() ?? '';
  String _t(Object? v)  => v?.toString().trim() ?? '';

  @override
  Future<bool> saveVerificacionesOpsToLocal(List<VerificacionOps> items) async {
    final db = await sqlite.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final i in items) {
        final codigoN = _up(i.codigo);
        // 1) insert IGNORE
        batch.insert(
          LocalSqlite.TABLE_OPS_LISTA_VERIFICACION,
          {
            'ops_lista_verificacion_id': i.id,
            'ops_tipo_resultado_id'    : i.opsTipoResultadoId,
            'ops_tipo_checklist_id'    : i.opsTipoChecklistId,
            'codigo'                   : codigoN,
            'nombre'                   : _t(i.nombre),
            'ops_sub_tipo_inspeccion_id' : i.opsSubTipoChecklistId
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        // 2) update por clave única (codigo)
        batch.update(
          LocalSqlite.TABLE_OPS_LISTA_VERIFICACION,
          {
            'ops_tipo_resultado_id' : i.opsTipoResultadoId,
            'ops_tipo_checklist_id' : i.opsTipoChecklistId,
            'nombre'                : _t(i.nombre),
            'ops_sub_tipo_inspeccion_id' : i.opsSubTipoChecklistId
          },
          where: "TRIM(UPPER(codigo)) = ?",
          whereArgs: [codigoN],
        );
      }
      await batch.commit(noResult: true);
    });
    return true;
  }


  @override
  Future<bool> saveCategoriasOpsToLocal(List<CategoriaOps> items) async {
    final db = await sqlite.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final i in items) {
        final nombreN = _t(i.nombre).toUpperCase();
        batch.insert(
          LocalSqlite.TABLE_OPS_LISTA_VERIF_CATEGORIA,
          {
            'ops_lista_verif_categoria_id': i.id,
            'ops_lista_verificacion_id'   : i.opsListaVerificacionId,
            'nombre'                      : _t(i.nombre),
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        batch.update(
          LocalSqlite.TABLE_OPS_LISTA_VERIF_CATEGORIA,
          {
            'ops_lista_verificacion_id': i.opsListaVerificacionId,
            'nombre'                   : _t(i.nombre),
          },
          where: "TRIM(UPPER(nombre)) = ?",
          whereArgs: [nombreN],
        );
      }
      await batch.commit(noResult: true);
    });
    return true;
  }


  @override
  Future<bool> saveSeccionesOpsToLocal(List<SeccionOps> items) async {
    final db = await sqlite.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final i in items) {
        final verifIdN = _up(i.opsListaVerificacionId);
        final ordenN   = _t(i.orden).toUpperCase(); // si ‘orden’ es texto numérico
        batch.insert(
          LocalSqlite.TABLE_OPS_LISTA_VERIF_SECCION,
          {
            'ops_lista_verif_seccion_id'  : i.id,
            'ops_lista_verif_categoria_id': i.opsListaVerifCategoriaId,
            'ops_lista_verificacion_id'   : i.opsListaVerificacionId,
            'nombre'                      : _t(i.nombre),
            'orden'                       : _t(i.orden),
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        batch.update(
          LocalSqlite.TABLE_OPS_LISTA_VERIF_SECCION,
          {
            'ops_lista_verif_categoria_id': i.opsListaVerifCategoriaId,
            'nombre'                      : _t(i.nombre),
          },
          where: "TRIM(UPPER(ops_lista_verificacion_id)) = ? AND TRIM(UPPER(COALESCE(orden,''))) = ?",
          whereArgs: [verifIdN, ordenN],
        );
      }
      await batch.commit(noResult: true);
    });
    return true;
  }



  Future<bool> savePreguntasOpsToLocal(List<PreguntaOps> items) async {
    final db = await sqlite.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final i in items) {
        final secIdN = _up(i.opsListaVerifSeccionId);
        final ordenN = _t(i.orden).toUpperCase();
        batch.insert(
          LocalSqlite.TABLE_OPS_LISTA_VERIF_PREGUNTA,
          {
            'ops_lista_verif_pregunta_id' : i.id,
            'ops_lista_verif_seccion_id'  : i.opsListaVerifSeccionId,
            'ops_lista_verif_categoria_id': i.opsListaVerifCategoriaId,
            'ops_lista_verificacion_id'   : i.opsListaVerificacionId,
            'nombre'                      : _t(i.nombre),
            'flag_pregunta'               : _t(i.flagPregunta),
            'orden'                       : _t(i.orden),
            'aux_codigo'                  : _t(i.codigo),
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        batch.update(
          LocalSqlite.TABLE_OPS_LISTA_VERIF_PREGUNTA,
          {
            'ops_lista_verif_categoria_id': i.opsListaVerifCategoriaId,
            'ops_lista_verificacion_id'   : i.opsListaVerificacionId,
            'nombre'                      : _t(i.nombre),
            'flag_pregunta'               : _t(i.flagPregunta),
            'aux_codigo'                  : _t(i.codigo),
          },
          where: "TRIM(UPPER(ops_lista_verif_seccion_id)) = ? AND TRIM(UPPER(COALESCE(orden,''))) = ?",
          whereArgs: [secIdN, ordenN],
        );
      }
      await batch.commit(noResult: true);
    });
    return true;
  }


  Future<bool> saveTurnoOpsToLocal(List<Turno> turnosOps) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_OPS_TURNOS);
      final batch = db.batch();

      for (final i in turnosOps) {
        batch.insert(LocalSqlite.TABLE_OPS_TURNOS, {
          'nombre': i.nombre,
          'codigo': i.codigo,
        });
        print("Registro turnos 👌");
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveResultadoOpsToLocal(List<ResultadoOps> items) async {
    // 1) quita duplicados dentro del mismo lote y omite vacíos
    final vistos = <String>{};
    final depurado = <ResultadoOps>[];
    for (final it in items) {
      final k = _up(it.codigo);
      if (k.isEmpty) continue;       // si no hay código, no lo guardes
      if (vistos.add(k)) depurado.add(it);
    }

    final db = await sqlite.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final i in depurado) {
        final codigoN = _up(i.codigo); // ya no será vacío aquí

        // 2) INSERT IGNORE (idempotente gracias al UNIQUE)
        batch.insert(
          LocalSqlite.TABLE_OPS_LISTA_VERIF_RESULTADO,
          {
            'ops_lista_verif_resultado_id': i.id,
            'ops_tipo_resultado_id'       : i.opsTipoResultadoId,
            'codigo'                      : codigoN,
            'nombre'                      : (i.nombre ?? '').trim(),
            'ops_tipo_checklist_id'       : i.opsTipoChecklistId,

          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        // 3) UPDATE por la misma clave normalizada (robusto a mayúsculas/espacios/NULL)
        batch.update(
          LocalSqlite.TABLE_OPS_LISTA_VERIF_RESULTADO,
          {
            'ops_tipo_resultado_id' : i.opsTipoResultadoId,
            'nombre'                : (i.nombre ?? '').trim(),
            'ops_tipo_checklist_id' : i.opsTipoChecklistId,
          },
          where: "TRIM(UPPER(COALESCE(codigo,''))) = ?",
          whereArgs: [codigoN],
        );
      }
      await batch.commit(noResult: true);
    });
    return true;
  }



  @override
  Future<int> updatePreguntasByRegistroGeneralOpsFromLocal(
    String idGeneral,
    String idVerificacion,
  ) async {
    try {
      final db = await sqlite.database;

      final result = await db.rawQuery(
        '''SELECT pre.ops_lista_verif_pregunta_id , orr.aux_codigo  FROM OPS_LISTA_VERIF_PREGUNTA as pre
                      LEFT OUTER JOIN OPS_REGISTRO_RESULTADO as orr
                      ON pre.ops_lista_verif_pregunta_id = orr.ops_lista_verif_pregunta_id
                      WHERE pre.ops_lista_verificacion_id  = "$idVerificacion"
                      AND orr.ops_registro_generales_id = "$idGeneral"''',
      );

      // log('''😊 SELECT pre.ops_lista_verif_pregunta_id , orr.aux_codigo  FROM OPS_LISTA_VERIF_PREGUNTA as pre
      //                 LEFT OUTER JOIN OPS_REGISTRO_RESULTADO as orr
      //                 ON pre.ops_lista_verif_pregunta_id = orr.ops_lista_verif_pregunta_id
      //                 WHERE pre.ops_lista_verificacion_id  = $idVerificacion
      //                 AND orr.ops_registro_generales_id = $idGeneral''');

      await db.rawUpdate(
        'UPDATE ${LocalSqlite.TABLE_OPS_LISTA_VERIF_PREGUNTA} SET aux_codigo = ?',
        [''],
      );
      if (result.isNotEmpty) {
        int rows = 0;

        for (final item in result) {
          final res = await db.rawUpdate(
            'UPDATE ${LocalSqlite.TABLE_OPS_LISTA_VERIF_PREGUNTA} SET aux_codigo = ? WHERE ops_lista_verif_pregunta_id = ?',
            ['${item['aux_codigo']}', '${item['ops_lista_verif_pregunta_id']}'],
          );
          rows += res;
        }

        print('😊 actualizo: $rows');

        return rows;
      } else {
        print('😊 actualizo: 0');
        return 0;
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }
}
