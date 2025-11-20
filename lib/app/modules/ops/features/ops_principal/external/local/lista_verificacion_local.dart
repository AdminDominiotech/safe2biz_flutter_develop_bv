import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:sqflite/sqflite.dart';

class ListaVerificacionLocal implements ListaVerificacionLocalDatasource {
  ListaVerificacionLocal({required this.sqlite});
  final LocalSqlite sqlite;

  @override
  Future<List<RegistroGeneral>> getListaVerificacionFromStorage(
      String idSede, String idListaVerificacion) async {
    try {
      final db = await sqlite.database;

      /*final result = await db.query(
        LocalSqlite.TABLE_OPS_REGISTRO_GENERALES,
        whereArgs: [idSede],
        where: 'uea_id = ?',
      );*/

      final result = await db.rawQuery(
        '''SELECT * FROM ${LocalSqlite.TABLE_OPS_REGISTRO_GENERALES}
            WHERE fb_uea_pe_id = $idSede
            AND ops_lista_verificacion_id = $idListaVerificacion''',
      );

      //final result = await db.query(LocalSqlite.TABLE_OPS_REGISTRO_GENERALES);

      if (result.isNotEmpty) {
        final registroGeneral = List.from(result)
            .map((item) => RegistroGeneralModel.fromJson(item))
            .toList();
        return registroGeneral;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> editListaVerificacionFromStorage(
      RegistroGeneral registroGeneral) async {
    try {
      final db = await sqlite.database;

      final result = await db.update(
        LocalSqlite.TABLE_OPS_REGISTRO_GENERALES,
        {
          'fb_uea_pe_id'                    : registroGeneral.fbUeaPeId,
          'codigo'                          : registroGeneral.codigo,
          'g_tipo_origen_id'                : registroGeneral.gTipoOrigenId,
          'fecha_ops'                       : registroGeneral.fechaOps,
          'hora_ops'                        : registroGeneral.horaOps,
          'turno'                           : registroGeneral.turno,
          'fb_area_id'                      : registroGeneral.fbAreaId,
          'g_rol_empresa_id'                : registroGeneral.gRolEmpresaId,
          'fb_empresa_especializada_id'     : registroGeneral.fbEmpresaEspecializadaId,
          'fb_empleado_id'                  : registroGeneral.fbEmpleadoId,
          'ops_lista_verificacion_id'       : registroGeneral.opsListaVerificacionId,
          'ops_tipo_resultado_id'           : registroGeneral.opsTipoResultadoId,
          'latitud'                         : registroGeneral.latitud,
          'longitud'                        : registroGeneral.longitud,
          'fb_area_nombre'                  : registroGeneral.fbAreaNombre,
          'turno_nombre'                    : registroGeneral.turnoNombre,
          'fb_empresa_especializada_nombre' : registroGeneral.fbEmpresaEspecializadaNombre,
          'fb_empleado_nombre_completo'     : registroGeneral.fbEmpleadoNombreCompleto,
          'id_generado_syncronizacion'      : registroGeneral.idGeneradoSyncronizacion,
          'estado'                          : registroGeneral.estado,
          'flag'                            : registroGeneral.flag,
          'ops_tipo_inspeccion_id'          : registroGeneral.idOpsTipoInspeccion,
          'ops_sub_tipo_inspeccion_id'      : registroGeneral.idOpsSubTipoInspeccion,
          'ops_alcance_inspeccion_id'       : registroGeneral.idOpsAlcanceInspeccion,
          'ops_sub_tipo_inspeccion_text'    : registroGeneral.OpsSubTipoInspeccionText,
          'ops_tipo_inspeccion_text'        : registroGeneral.OpsTipoInspeccionText,
          'ops_alcance_inspeccion_text'     : registroGeneral.OpsAlcanceInspeccionText,
          'alcance'                         : registroGeneral.alcance,
          'criterio'                        : registroGeneral.criterio,

          // 👇 Campos que faltaban (coinciden con tu final data)
          'fb_verificador_id'               : registroGeneral.fbVerificadorId,
          'verificador_nombre'              : registroGeneral.verificadorNombre,
          'fb_auditor_id'                   : registroGeneral.fbAuditorId,
          'auditor_nombre'                  : registroGeneral.auditorNombre,
          'ops_contratista_id'              : registroGeneral.opsContratistaId,
          'contratista_nombre'              : registroGeneral.contratistaNombre,

          'tipo_servicio_nombre'            : registroGeneral.tipoServicioNombre,
          'equipo_auditor'                  : registroGeneral.equipoAuditor,
          'personal_auditado'               : registroGeneral.personalAuditado,
          'ops_involucrados'                    : registroGeneral.involucrados,
          'ops_inspectores'                     : registroGeneral.inspectores,
        },
        whereArgs: [registroGeneral.id],
        where: 'ops_registro_generales_id = ?',
      );


      if (result > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> deleteAllListaVerificacionStorage() async {
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
  Future<bool> deleteListaVerificacionStorage(String id) async {
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
  Future<bool> editStatusListaVerificacionFromStorage(
      String id, String status) async {
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

  Future<int> saveListaVerificacionStorage(RegistroGeneral registroGeneral) async {
    final db = await sqlite.database;

    // 1) Construye el mapa de datos a insertar
    final data = {
      'fb_uea_pe_id': registroGeneral.fbUeaPeId,
      'codigo': registroGeneral.codigo,
      'g_tipo_origen_id': registroGeneral.gTipoOrigenId,
      'fecha_ops': registroGeneral.fechaOps,
      'hora_ops': registroGeneral.horaOps,
      'turno': registroGeneral.turno,
      'fb_area_id': registroGeneral.fbAreaId,
      'g_rol_empresa_id': registroGeneral.gRolEmpresaId,
      'fb_empresa_especializada_id': registroGeneral.fbEmpresaEspecializadaId,
      'fb_empleado_id': registroGeneral.fbEmpleadoId,
      'ops_lista_verificacion_id': registroGeneral.opsListaVerificacionId,
      'ops_tipo_resultado_id': registroGeneral.opsTipoResultadoId,
      'latitud': registroGeneral.latitud,
      'longitud': registroGeneral.longitud,
      'fb_area_nombre': registroGeneral.fbAreaNombre,
      'turno_nombre': registroGeneral.turnoNombre,
      'fb_empresa_especializada_nombre': registroGeneral.fbEmpresaEspecializadaNombre,
      'fb_empleado_nombre_completo': registroGeneral.fbEmpleadoNombreCompleto,
      'id_generado_syncronizacion': registroGeneral.idGeneradoSyncronizacion,
      'ops_tipo_inspeccion_id' : registroGeneral.idOpsTipoInspeccion,
      'ops_sub_tipo_inspeccion_id' : registroGeneral.idOpsSubTipoInspeccion,
      'ops_alcance_inspeccion_id': registroGeneral.idOpsAlcanceInspeccion,
      'estado': registroGeneral.estado,
      'flag': registroGeneral.flag,
      'alcance': registroGeneral.alcance,
      'criterio': registroGeneral.criterio,  // asegúrate de usar el nombre correcto

      'ops_sub_tipo_inspeccion_text' : registroGeneral.OpsSubTipoInspeccionText,
      'ops_tipo_inspeccion_text': registroGeneral.OpsTipoInspeccionText,
      'ops_alcance_inspeccion_text' : registroGeneral.OpsAlcanceInspeccionText,
      'fb_verificador_id'     : registroGeneral.fbVerificadorId,
      'verificador_nombre'    : registroGeneral.verificadorNombre,
      'fb_auditor_id'         : registroGeneral.fbAuditorId,
      'auditor_nombre'        : registroGeneral.auditorNombre,

      'contratista_nombre'    : registroGeneral.contratistaNombre,


      // Contratista y servicio
      'ops_contratista_id'    : registroGeneral.opsContratistaId,
      'tipo_servicio_nombre'  : registroGeneral.tipoServicioNombre,

      // Textareas adicionales
      'equipo_auditor'        : registroGeneral.equipoAuditor,
      'personal_auditado'     : registroGeneral.personalAuditado,

      // Ya existentes en otras reglas
      'ops_involucrados'          : registroGeneral.involucrados,
      'ops_inspectores'           : registroGeneral.inspectores,

    };

    // 2) Imprime el mapa para debug
    print('💾 [Local] Insertando en OPS_REGISTRO_GENERALES: $data');

    // 3) Haz el insert
    final result = await db.insert(
      LocalSqlite.TABLE_OPS_REGISTRO_GENERALES,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 4) Imprime el ID devuelto
    print('✅ [Local] Insert result: $result');

    // 5) Listado de todos los registros para ver qué hay en la tabla
    final all = await db.query(LocalSqlite.TABLE_OPS_REGISTRO_GENERALES);
    print('🗒️ [Local] Contenido de OPS_REGISTRO_GENERALES:');
    for (var row in all) {
      print(row);
    }

    return result;
  }


  @override
  Future<bool> saveRegistroResultadoStorage(
    RegistroResultado registroResultado,
  ) async {
    try {
      final db = await sqlite.database;

      final result = await db.insert(LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO, {
        'ops_registro_generales_id': registroResultado.opsRegistroGeneralesId,
        'ops_lista_verif_pregunta_id':
            registroResultado.opsListaVerifPreguntaId,
        'ops_lista_verif_seccion_id': registroResultado.opsListaVerifSeccionId,
        'ops_lista_verif_categoria_id':
            registroResultado.opsListaVerifCategoriaId,
        'ops_lista_verif_resultado_id':
            registroResultado.opsListaVerifResultadoId,
        'observacion': registroResultado.observacion,
        'ruta_imagen': registroResultado.rutaImagen,
        'nombre_imagen': registroResultado.nombreImagen,
        'id_generado_syncronizacion':
            registroResultado.idGeneradoSyncronizacion,
        'aux_codigo': registroResultado.auxCodigo,
      });

      if (result > 0) {
        return true;
      } else {
        throw const LocalFailure(
          message: 'Error al guardar registro resultado',
        );
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<RegistroResultado> getRegistroResultadoFromStorage(String idGenerales,
      String idCategoria, String idSeccion, String idPregunta) async {
    try {
      final db = await sqlite.database;

      final result = await db.rawQuery(
        '''SELECT * FROM ${LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO}
            WHERE ops_registro_generales_id =$idGenerales 
            AND ops_lista_verif_categoria_id = $idCategoria                        
            AND ops_lista_verif_seccion_id  = $idSeccion
            AND ops_lista_verif_pregunta_id  = $idPregunta''',
      );
      if (result.isNotEmpty) {
        final model = List.from(result)
            .map((item) => RegistroResultadoModel.fromJson(item))
            .toList();
        return model.first;
      } else {
        return RegistroResultadoModel.fromJson({});
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<List<RegistroResultado>> getRegistroResultadoByIdGeneralFromStorage(
    String idGenerales,
  ) async {
    try {
      final db = await sqlite.database;

      final result = await db.rawQuery(
        '''SELECT * FROM ${LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO}
            WHERE ops_registro_generales_id =$idGenerales''',
      );
      if (result.isNotEmpty) {
        final registroResultado = List.from(result)
            .map((item) => RegistroResultadoModel.fromJson(item))
            .toList();
        return registroResultado;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> editRegistroResultadoFromStorage(
    RegistroResultado registroResultado,
  ) async {
    try {
      final db = await sqlite.database;

      final result = await db.update(
        LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO,
        {
          'ops_registro_generales_id': registroResultado.opsRegistroGeneralesId,
          'ops_lista_verif_pregunta_id':
              registroResultado.opsListaVerifPreguntaId,
          'ops_lista_verif_seccion_id':
              registroResultado.opsListaVerifSeccionId,
          'ops_lista_verif_categoria_id':
              registroResultado.opsListaVerifCategoriaId,
          'ops_lista_verif_resultado_id':
              registroResultado.opsListaVerifResultadoId,
          'observacion': registroResultado.observacion,
          'ruta_imagen': registroResultado.rutaImagen,
          'nombre_imagen': registroResultado.nombreImagen,
          'id_generado_syncronizacion':
              registroResultado.idGeneradoSyncronizacion,
          'aux_codigo': registroResultado.auxCodigo,
        },
        whereArgs: [registroResultado.id],
        where: 'ops_registro_resultado_id = ?',
      );
      if (result > 0) {
        return true;
      } else {
        throw const LocalFailure(message: 'Error al editar Registro resultado');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  Future<bool> editStatusRegistroGeneralesFromStorage(
    int id,
    String status,
  ) async {
    try {
      final db = await sqlite.database;

      final result = await db.update(
        LocalSqlite.TABLE_OPS_REGISTRO_GENERALES,
        {
          'estado': status,
        },
        whereArgs: [id],
        where: 'ops_registro_generales_id = ?',
      );
      if (result > 0) {
        return true;
      } else {
        throw const LocalFailure(message: 'Error al editar registro generales');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  Future<bool> editStatusRegistroResultadoFromStorage(
    int id,
    String status,
  ) async {
    // try {
    // final db = await sqlite.database;

    // final result = await db.update(
    //   LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO,
    //   {
    //     'estado': status,
    //   },
    //   whereArgs: [id],
    //   where: 'ops_registro_generales_id = ?',
    // );
    // if (result > 0) {
    return true;
    //   } else {
    //     throw const LocalFailure(message: 'Error al editar registro resultado');
    //   }
    // } catch (e, stackTrace) {
    //   throw AppException(message: stackTrace.toString());
    // }
  }

  @override
  Future<bool> deleteRegistroGeneralFromStorage(int id) async {
    try {
      final db = await sqlite.database;

      final result = await db.delete(
        LocalSqlite.TABLE_OPS_REGISTRO_GENERALES,
        whereArgs: [id],
        where: 'ops_registro_generales_id = ?',
      );

      if (result == 1) {
        return true;
      } else {
        throw const LocalFailure(
            message: 'Error al eliminar los registro general');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> deleteRegistroResultadoFromStorage(String id) async {
    try {
      final db = await sqlite.database;

      final result = await db.delete(
        LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO,
        whereArgs: [id],
        where: 'ops_registro_generales_id = ?',
      );

      if (result == 1) {
        return true;
      } else {
        throw const LocalFailure(
          message: 'Error al eliminar los registro resultado',
        );
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }
}
