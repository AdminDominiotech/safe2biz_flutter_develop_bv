import 'dart:convert';

import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/planes_accion/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/data/models/models.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'dart:developer' as dev;

class PlanesAccionLocal implements PlanesAccionLocalDatasource {
  PlanesAccionLocal({required this.sqlite});
  final LocalSqlite sqlite;

  @override
  Future<List<PlanesAccionModel>> getPlanesAccionFromStorage(String idSede) async {
    try {
      final db = await sqlite.database;

      // Log de entrada
      dev.log(
        '[PLANES] → query tabla=${LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA} where="uea_id = ?" args=[$idSede]',
        name: 'Storage',
      );

      final sw = Stopwatch()..start();

      final result = await db.query(
        LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA,
        where: 'uea_id = ?',
        whereArgs: [idSede],
      );

      sw.stop();
      dev.log('[PLANES] ← filas=${result.length} en ${sw.elapsedMilliseconds}ms', name: 'Storage');

      // Muestra de 3 filas crudas (tal cual vienen del query)
      if (result.isNotEmpty) {
        final sampleRaw = result.take(3).map((m) => jsonEncode(m)).toList();
        dev.log('[PLANES] sample(3)[raw]: $sampleRaw', name: 'Storage');

        final planesAccion = result
            .map((item) => PlanesAccionModel.fromJson(item))
            .toList();

        // Si tu modelo tiene toJson(), puedes loguear una muestra ya mapeada:
        // final sampleMapped = planesAccion.take(3).map((e) => jsonEncode(e.toJson())).toList();
        // dev.log('[PLANES] sample(3)[mapped]: $sampleMapped', name: 'Storage');

        return planesAccion;
      } else {
        dev.log('[PLANES] vacío para uea_id=$idSede', name: 'Storage');
        return [];
      }
    } catch (e, s) {
      dev.log('[PLANES][ERR] $e', name: 'Storage', error: e, stackTrace: s);
      throw AppException(message: e.toString());
    }
  }


  @override
  Future<bool> editPlanAccionFromStorage(PlanAccion planAccion) async {
    try {
      final db = await sqlite.database;

      final result = await db.update(
        LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA,
        {
          'codigo_accion_correctiva': planAccion.codigo,
          'accion_correctiva_detalle': planAccion.detalle,
          'fecha_acordada_ejecucion': planAccion.fechaEjec,
          'nombre_responsable_correccion': planAccion.responsable,
          'origen': planAccion.origen,
          'uea_id': planAccion.ueaId,
          'fecha_ejecucion': planAccion.fechaEjecucion,
          'evidencia_nombre': planAccion.evidenciaNombre, // Sin espacio extra
          'evidencia_ruta': planAccion.evidenciaRuta,
          'estado': planAccion.estado,
          'obs_resp_corr': planAccion.obsRespCorr,
          'fecha_origen': planAccion.fechaOrigen,
          'nombre_responsable_verificador': planAccion.responsableVerificador
        },
        where: 'sac_accion_correctiva_id = ?',
        whereArgs: [planAccion.id],
      );


      if (result > 0) {
        return true;
      } else {
        throw const LocalFailure(message: 'Error al editar plan de acciión');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> deleteAllPlanesAccionStorage() async {
    try {
      final db = await sqlite.database;

      final result = await db.delete(LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA);

      if (result == 1) {
        return true;
      } else {
        throw const LocalFailure(
            message: 'Error al eliminar los actos y condiciones');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> deletePlanAccionStorage(String id) async {
    try {
      final db = await sqlite.database;

      final result = await db.delete(
        LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA,
        whereArgs: [id],
        where: 'sac_accion_correctiva_id = ?',
      );

      if (result == 1) {
        return true;
      } else {
        throw LocalFailure(
          message: 'Error al eliminar acto y condicione $id',
        );
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> editStatusPlanAccionFromStorage(String id, String status) async {
    try {
      final db = await sqlite.database;

      final result = await db.update(
        LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA,
        {
          'estado': status,
        },
        whereArgs: [id],
        where: 'sac_accion_correctiva_id = ?',
      );
      if (result > 0) {
        return true;
      } else {
        throw const LocalFailure(message: 'Error al editar acto y condición');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }
}
