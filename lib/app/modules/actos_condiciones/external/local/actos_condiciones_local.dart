import 'dart:developer';

import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/models/acto_condicion_model.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

class ActosCondicionesLocal implements ActosCondicionesLocalDatasource {
  ActosCondicionesLocal({required this.sqlite});
  final LocalSqlite sqlite;

  @override

  Future<List<ActoCondicionModel>> getActosCondicionesFromStorage(String idSede) async {
    try {
      final db = await sqlite.database;
      final result = await db.query(
          LocalSqlite.TABLE_AYC_REGISTRO,
          where: 'fb_uea_pe_id = ?',
          whereArgs: [idSede],
          orderBy: 'fecha DESC, hora DESC'  // Asegura que se ordene primero por fecha y luego por hora en orden descendente.
      );

      if (result.isNotEmpty) {
        return List.from(result)
            .map((item) => ActoCondicionModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      log('Error fetching actos y condiciones: $e');
      throw AppException(message: stackTrace.toString());
    }

  }

  @override
  Future<bool> saveActoCondicionStorage(ActoCondicion actoCondicion) async {
    try {
      final db = await sqlite.database;

      final result = await db.insert(LocalSqlite.TABLE_AYC_REGISTRO, {
        'origen': actoCondicion.origen,
        'g_tipo_causa_id': actoCondicion.gTipoCausaId,
        'g_tipo_causa_nombre': actoCondicion.gTipoCausaNombre,
        'fb_gerencia_id': actoCondicion.fbGerencia,
        'fb_gerencia_nombre': actoCondicion.fbGerenciaNombre,
        'fb_area_id': actoCondicion.fbAreaId,
        'fb_area_nombre': actoCondicion.fbAreaNombre,
        'descripcion': actoCondicion.descripcion,
        'lugar': actoCondicion.lugar,
        'fecha': actoCondicion.fecha,
        'hora': actoCondicion.hora,
        'corrigio': actoCondicion.corrigio,
        'tipo_evento_id': actoCondicion.tipoEventoId,
        'tipo_evento_nombre': actoCondicion.tipoEventoNombre,
        'nivel_riesgo_id': actoCondicion.nivelRiesgoId,
        'nivel_riesgo_nombre': actoCondicion.nivelRiesgoNombre,
        'accion_ejec': actoCondicion.accionEjec,
        'fb_empresa_especializada_id': actoCondicion.fbEmpresaEspecializadaId,
        'fb_empresa_especializada_nombre':
            actoCondicion.fbEmpresaEspecializadaNombre,
        'latitud': actoCondicion.latitud,
        'longitud': actoCondicion.longitud,
        'foto_pre_evento_nombre': actoCondicion.fotoPreEventoNombre,
        'foto_pre_evento_ruta': actoCondicion.fotoPreEventoRuta,
        'foto_evento_nombre': actoCondicion.fotoEventoNombre,
        'foto_evento_ruta': actoCondicion.fotoEventoRuta,
        'fb_empleado_id': actoCondicion.fbEmpleadoId,
        'fb_empleado_nombre': actoCondicion.fbEmpleadoNombre,
        'fb_uea_pe_id': actoCondicion.fbUeaPeId,
        'inc_bsaf_id' : actoCondicion.bsafId,
        'tarjeta_roja' : actoCondicion.tarjetaRoja,
        'interior_mina': actoCondicion.interiorMina,
        'interior_mina_nivel': actoCondicion.interiorMinaNivel,
        'interior_mina_labor': actoCondicion.interiorMinaLabor,
        'interior_mina_numero_labor': actoCondicion.interiorMinaNumeroLabor,
        'estado': actoCondicion.estado,
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
  Future<bool> deleteAllActosCondicionesStorage() async {
    try {
      final db = await sqlite.database;

      final result = await db.delete(LocalSqlite.TABLE_AYC_REGISTRO);

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
  Future<bool> deleteActoCondicionStorage(int id) async {
    try {
      final db = await sqlite.database;

      final result = await db.delete(
        LocalSqlite.TABLE_AYC_REGISTRO,
        whereArgs: [id],
        where: 'ayc_registro_id = ?',
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
  Future<ActoCondicionModel> getActoCondicionFromStorage(String id) async {
    try {
      final db = await sqlite.database;

      final result = await db.query(
        LocalSqlite.TABLE_AYC_REGISTRO,
        whereArgs: [id],
        where: 'ayc_registro_id = ?',
      );

      if (result.isNotEmpty) {
        final actosCondiciones = List.from(result)
            .map((item) => ActoCondicionModel.fromJson(item))
            .toList();
        return actosCondiciones.first;
      } else {
        return ActoCondicionModel.fromJson({});
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> editActoCondicionFromStorage(ActoCondicion actoCondicion) async {
    try {
      final db = await sqlite.database;

      final result = await db.update(
        LocalSqlite.TABLE_AYC_REGISTRO,
        {
          'origen': actoCondicion.origen,
          'g_tipo_causa_id': actoCondicion.gTipoCausaId,
          'g_tipo_causa_nombre': actoCondicion.gTipoCausaNombre,
          'fb_gerencia_id': actoCondicion.fbGerencia,
          'fb_gerencia_nombre': actoCondicion.fbGerenciaNombre,
          'fb_area_id': actoCondicion.fbAreaId,
          'fb_area_nombre': actoCondicion.fbAreaNombre,
          'descripcion': actoCondicion.descripcion,
          'lugar': actoCondicion.lugar,
          'fecha': actoCondicion.fecha,
          'hora': actoCondicion.hora,
          'corrigio': actoCondicion.corrigio,
          'tipo_evento_id': actoCondicion.tipoEventoId,
          'tipo_evento_nombre': actoCondicion.tipoEventoNombre,
          'nivel_riesgo_id': actoCondicion.nivelRiesgoId,
          'nivel_riesgo_nombre': actoCondicion.nivelRiesgoNombre,
          'accion_ejec': actoCondicion.accionEjec,
          'fb_empresa_especializada_id': actoCondicion.fbEmpresaEspecializadaId,
          'fb_empresa_especializada_nombre':
              actoCondicion.fbEmpresaEspecializadaNombre,
          'latitud': actoCondicion.latitud,
          'longitud': actoCondicion.longitud,
          'foto_pre_evento_nombre': actoCondicion.fotoPreEventoNombre,
          'foto_pre_evento_ruta': actoCondicion.fotoPreEventoRuta,
          'foto_evento_nombre': actoCondicion.fotoEventoNombre,
          'foto_evento_ruta': actoCondicion.fotoEventoRuta,
          'fb_empleado_id': actoCondicion.fbEmpleadoId,
          'fb_empleado_nombre': actoCondicion.fbEmpleadoNombre,
          'fb_uea_pe_id': actoCondicion.fbUeaPeId,
          'inc_bsaf_id' : actoCondicion.bsafId,
          'tarjeta_roja': actoCondicion.tarjetaRoja,
          'interior_mina': actoCondicion.interiorMina,
          'interior_mina_nivel': actoCondicion.interiorMinaNivel,
          'interior_mina_labor': actoCondicion.interiorMinaLabor,
          'interior_mina_numero_labor': actoCondicion.interiorMinaNumeroLabor,
          'estado': actoCondicion.estado,
        },
        whereArgs: [actoCondicion.id],
        where: 'ayc_registro_id = ?',
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
  Future<bool> editStatusActoCondicionFromStorage(int id, String status) async {
    try {
      final db = await sqlite.database;

      final result = await db.update(
        LocalSqlite.TABLE_AYC_REGISTRO,
        {
          'estado': status,
        },
        whereArgs: [id],
        where: 'ayc_registro_id = ?',
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
