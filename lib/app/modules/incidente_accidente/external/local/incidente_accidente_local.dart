import 'dart:developer';

import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/incidente_accidente/data/datasource/datasource.dart';

import 'package:safe2biz/app/modules/incidente_accidente/data/models/incidente_accidente_model.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';

class IncidentesAccidentesLocal implements IncidentesAccidentesLocalDatasource {
  IncidentesAccidentesLocal({required this.sqlite});
  final LocalSqlite sqlite;

  @override
  Future<List<IncidenteAccidenteModel>> getIncidentesAccidentesFromStorage(
      String idSede,
      ) async {
    try {
      final db = await sqlite.database;
      final result = await db.query(
          LocalSqlite.TABLE_INC_REGISTRO,
          where: 'fb_uea_pe_id = ?',
          whereArgs: [idSede],
          orderBy: 'fecha_evento DESC, hora DESC'  // Ordena por fecha y hora descendente
      );

      if (result.isNotEmpty) {
        return List.from(result)
            .map((item) => IncidenteAccidenteModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      log('Error fetching incidentes accidentes: $e');
      throw AppException(message: stackTrace.toString());
    }
  }


  @override
  Future<bool> saveIncidenteAccidenteStorage(
    IncidenteAccidente incidenteAccidente,
  ) async {
    try {
      final db = await sqlite.database;

      final result = await db.insert(LocalSqlite.TABLE_INC_REGISTRO, {
        'inc_tipo_evento': incidenteAccidente.incTipoReporte,
        'inc_tipo_evento_nombre': incidenteAccidente.incTipoReporteNombre,
        'inc_sub_tipo_evento': incidenteAccidente.incSubTipoReporte,
        'inc_sub_tipo_evento_nombre':
            incidenteAccidente.incSubTipoReporteNombre,
        'inc_segun_tipo': incidenteAccidente.incSegunTipo,
        'inc_segun_tipo_nombre': incidenteAccidente.incSegunTipoNombre,
        'inc_potencial_perdida': incidenteAccidente.incPotencialPerdida,
        'inc_potencial_perdida_nombre':
            incidenteAccidente.incPotencialPerdidaNombre,
        'fb_gerencia_id': incidenteAccidente.fbGerencia,
        'fb_gerencia_nombre': incidenteAccidente.fbGerenciaNombre,
        'fb_area': incidenteAccidente.fbArea,
        'fb_area_nombre': incidenteAccidente.fbAreaNombre,
        'fecha_evento': incidenteAccidente.fecha,
        'hora': incidenteAccidente.hora,
        'lugar_evento': incidenteAccidente.lugar,
        'descripcion_evento': incidenteAccidente.descripcion,
        'imagen_pre_evento_nombre': incidenteAccidente.imagenPreReporteNombre,
        'imagen_pre_evento_ruta': incidenteAccidente.imagenPreReporteRuta,
        'imagen_evento_nombre': incidenteAccidente.imagenReporteNombre,
        'imagen_evento_ruta': incidenteAccidente.imagenReporteRuta,
        'fb_empleado_id': incidenteAccidente.fbEmpleadoId,
        'fb_uea_pe_id': incidenteAccidente.fbUeaPeId,
        'estado': incidenteAccidente.estado,
      });

      if (result > 0) {
        return true;
      } else {
        throw const LocalFailure(message: 'Error al guardar acto y condición');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> deleteAllIncidentesAccidentesStorage() async {
    try {
      final db = await sqlite.database;

      final result = await db.delete(LocalSqlite.TABLE_INC_REGISTRO);

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
  Future<bool> deleteIncidenteAccidenteStorage(int id) async {
    try {
      final db = await sqlite.database;

      final result = await db.delete(
        LocalSqlite.TABLE_INC_REGISTRO,
        whereArgs: [id],
        where: 'inc_incidente_id = ?',
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
  Future<IncidenteAccidenteModel> getIncidenteAccidenteFromStorage(
      String id) async {
    try {
      final db = await sqlite.database;

      final result = await db.query(
        LocalSqlite.TABLE_INC_REGISTRO,
        whereArgs: [id],
        where: 'inc_incidente_id = ?',
      );

      if (result.isNotEmpty) {
        final actosCondiciones = List.from(result)
            .map((item) => IncidenteAccidenteModel.fromJson(item))
            .toList();
        return actosCondiciones.first;
      } else {
        return IncidenteAccidenteModel.fromJson({});
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> editIncidenteAccidenteFromStorage(
    IncidenteAccidente incidenteAccidente,
  ) async {
    try {
      final db = await sqlite.database;

      final result = await db.update(
        LocalSqlite.TABLE_INC_REGISTRO,
        {
          'inc_tipo_evento': incidenteAccidente.incTipoReporte,
          'inc_tipo_evento_nombre': incidenteAccidente.incTipoReporteNombre,
          'inc_sub_tipo_evento': incidenteAccidente.incSubTipoReporte,
          'inc_sub_tipo_evento_nombre':
              incidenteAccidente.incSubTipoReporteNombre,
          'inc_segun_tipo': incidenteAccidente.incSegunTipo,
          'inc_segun_tipo_nombre': incidenteAccidente.incSegunTipoNombre,
          'inc_potencial_perdida': incidenteAccidente.incPotencialPerdida,
          'inc_potencial_perdida_nombre':
              incidenteAccidente.incPotencialPerdidaNombre,
          'fb_gerencia_id': incidenteAccidente.fbGerencia,
          'fb_gerencia_nombre': incidenteAccidente.fbGerenciaNombre,
          'fb_area': incidenteAccidente.fbArea,
          'fb_area_nombre': incidenteAccidente.fbAreaNombre,
          'fecha_evento': incidenteAccidente.fecha,
          'hora': incidenteAccidente.hora,
          'lugar_evento': incidenteAccidente.lugar,
          'descripcion_evento': incidenteAccidente.descripcion,
          'imagen_pre_evento_nombre': incidenteAccidente.imagenPreReporteNombre,
          'imagen_pre_evento_ruta': incidenteAccidente.imagenPreReporteRuta,
          'imagen_evento_nombre': incidenteAccidente.imagenReporteNombre,
          'imagen_evento_ruta': incidenteAccidente.imagenReporteRuta,
          'fb_empleado_id': incidenteAccidente.fbEmpleadoId,
          'fb_uea_pe_id': incidenteAccidente.fbUeaPeId,
          'estado': incidenteAccidente.estado,
        },
        whereArgs: [incidenteAccidente.id],
        where: 'inc_incidente_id = ?',
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

  @override
  Future<bool> editStatusIncidenteAccidenteFromStorage(
    int id,
    String status,
  ) async {
    try {
      final db = await sqlite.database;

      final result = await db.update(
        LocalSqlite.TABLE_INC_REGISTRO,
        {
          'estado': status,
        },
        whereArgs: [id],
        where: 'inc_incidente_id = ?',
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
