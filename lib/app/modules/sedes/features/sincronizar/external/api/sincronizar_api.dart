import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/plan_accion_model.dart';
import 'package:safe2biz/app/modules/planes_accion/data/models/models.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/sac_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/turno_model.dart';

class SincronizarApi implements SincronizarApiDatasource {
  SincronizarApi({required this.dioMicroServices});
  final DioMicroServices dioMicroServices;

  @override
  Future<List<AreaModel>> getAreasFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_FB_AREA',
      queryParameters: {
        'fb_gerencia_id': '0',
      },
    );


    print('### [API FB_AREA] statusCode: ${result.statusCode}');
    print('### [API FB_AREA] data crudo: ${result.data}');

    if (result.statusCode == 200) {
      final data = result.data['data'];
      print('### [API FB_AREA] filas en data: ${(data as List).length}');
      final list =
          List.from(data).map((item) => AreaModel.fromJson(item)).toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  
  @override
  Future<List<DesviacionModel>> getDesviacionesFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_AYC_Desviacion',
      queryParameters: {
        'ayc': '0',
      },
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];

      final list = List.from(data)
          .map((item) => DesviacionModel.fromJson(item))
          .toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<EmpleadoModel>> getEmpleadosFromApi(String userId) async {
    final result = await dioMicroServices.msDio.post(
      '/pr_ws_fb_empleados_ee_uea',
      queryParameters: {
        'sc_user_id': userId,
      },
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];

      final list =
          List.from(data).map((item) => EmpleadoModel.fromJson(item)).toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<EmpresaEspModel>> getEmpresasEspecializadasFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_ws_fb_empresa_especializada',
      queryParameters: {
        'sc_user_id': '0',
      },
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];

      final list = List.from(data)
          .map((item) => EmpresaEspModel.fromJson(item))
          .toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<GerenciaModel>> getGerenciasFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_FB_GERENCIA',
      queryParameters: {
        'fb_uea_pe_id': '0',
      },
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];

      final list =
          List.from(data).map((item) => GerenciaModel.fromJson(item)).toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<PlanesAccionModel>> getSacFromApi(
      String companyId, String employeId) async {
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_ACC_Consulta_Pendientes',
      queryParameters: {
        'uea_id': companyId,
        'usuario_id': employeId,
      },
      // options: Options(
      //   headers: {
      //     'userLogin': 'cesar.cueva@safe2biz_demo',
      //     'userPassword': '4321',
      //     'systemRoot': 'safe2biz',
      //   },
      // ),
    );


    if (result.statusCode == 200) {
      final data = result.data['data'];
      print("employeId --- $employeId");

      final sacList =
          List.from(data).map((item) => PlanesAccionModel.fromJson(item)).toList();

      return sacList;
    } else {
      print("employeId --- $employeId");

      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<NivelRiesgoModel>> getNivelRiesgoFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_AYC_Nivel_Riesgo',
      queryParameters: {
        'variable': '0',
      },
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];
      final list = List.from(data)
          .map((item) => NivelRiesgoModel.fromJson(item))
          .toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<TipoEventoModel>> getTipoEventoFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_INC_Tipo_Evento',
      queryParameters: {
        'variable': '0',
      },
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];

      final list = List.from(data)
          .map((item) => TipoEventoModel.fromJson(item))
          .toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<TipoReporteModel>> getTiposReportesFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_INC_Tipo_Evento',
      queryParameters: {
        'variable': '0',
      },
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];

      final list = List.from(data)
          .map((item) => TipoReporteModel.fromJson(item))
          .toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<DetallePerdidaModel>> getDetallesPerdidasFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_INC_Detalle_Perdida',
      queryParameters: {
        'tipo_reporte': '0',
      },
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];

      final list = List.from(data)
          .map((item) => DetallePerdidaModel.fromJson(item))
          .toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<PotencialPerdidaModel>> getPotencialesPerdidasFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_INC_Potencial_Perdida',
      queryParameters: {
        'variable': '0',
      },
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];

      final list = List.from(data)
          .map((item) => PotencialPerdidaModel.fromJson(item))
          .toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<SubTipoReporteModel>> getSubTiposReportesFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_INC_Subtipo_Evento',
      queryParameters: {
        'inc_tipo_reporte': '0',
      },
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];

      final list = List.from(data)
          .map((item) => SubTipoReporteModel.fromJson(item))
          .toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }

  @override
  Future<List<VerificacionOpsModel>> getVerificacionesOpsFromApi(String userLogin) async {
    final r = await dioMicroServices.msDio.post(
      '/pr_ws_ops_lista_verificacion',
      queryParameters: {'userLogin': userLogin},
    );
    if (r.statusCode != 200) throw ServerException(statusCode: r.statusCode);

    final list = (r.data['data'] as List)
        .map((e) => VerificacionOpsModel.fromJson(e))
        .toList();

    String _norm(String? s) => (s ?? '').trim().toUpperCase();
    final vistos = <String>{};
    final unicos = <VerificacionOpsModel>[];
    for (final x in list) {
      final k = _norm(x.codigo);
      if (k.isEmpty || !vistos.add(k)) continue;
      unicos.add(x);
    }

    final filas = await LocalSqlite().readData(
      "SELECT UPPER(TRIM(codigo)) AS k FROM ${LocalSqlite.TABLE_OPS_LISTA_VERIFICACION};",
    );
    final enLocal = filas.map((f) => (f['k'] ?? '').toString()).toSet();

    final aInsertar = unicos.where((x) => !enLocal.contains(_norm(x.codigo))).toList();
    return aInsertar;
  }



  @override
  Future<List<CategoriaOpsModel>> getCategoriasOpsFromApi(String userLogin) async {
    final r = await dioMicroServices.msDio.post(
      '/pr_ws_ops_lista_verif_categoria',
      queryParameters: {'userLogin': userLogin},
    );
    if (r.statusCode != 200) throw ServerException(statusCode: r.statusCode);

    // 1) parseo
    final list = (r.data['data'] as List)
        .map((e) => CategoriaOpsModel.fromJson(e))
        .toList();

    // 2) únicos por NOMBRE dentro de la MISMA respuesta
    String _norm(String? s) => (s ?? '').trim().toUpperCase();
    final vistos = <String>{};
    final unicos = <CategoriaOpsModel>[];
    for (final x in list) {
      final k = _norm(x.nombre);
      if (k.isEmpty || !vistos.add(k)) continue;
      unicos.add(x);
    }

    // 3) quitar los nombres que YA existen en SQLite
    final filas = await LocalSqlite().readData(
      "SELECT UPPER(TRIM(nombre)) AS k FROM ${LocalSqlite.TABLE_OPS_LISTA_VERIF_CATEGORIA};",
    );
    final enLocal = filas.map((f) => (f['k'] ?? '').toString()).toSet();

    final aInsertar = unicos.where((x) => !enLocal.contains(_norm(x.nombre))).toList();
    return aInsertar; // luego los insertas con tu insertBatch(...)
  }


  @override
  Future<List<SeccionOpsModel>> getSeccionesOpsFromApi(String userLogin) async {
    final r = await dioMicroServices.msDio.post(
      '/pr_ws_ops_lista_verif_seccion',
      queryParameters: {'userLogin': userLogin},
    );
    if (r.statusCode != 200) throw ServerException(statusCode: r.statusCode);

    final list = (r.data['data'] as List)
        .map((e) => SeccionOpsModel.fromJson(e))
        .toList();

    String _norm(String? s) => (s ?? '').trim(); // si quieres, normaliza ceros a la izquierda
    final vistos = <String>{};
    final unicos = <SeccionOpsModel>[];
    for (final x in list) {
      final k = _norm(x.orden);
      if (!vistos.add(k)) continue;
      unicos.add(x);
    }

    final filas = await LocalSqlite().readData(
      "SELECT TRIM(orden) AS k FROM ${LocalSqlite.TABLE_OPS_LISTA_VERIF_SECCION};",
    );
    final enLocal = filas.map((f) => (f['k'] ?? '').toString()).toSet();

    final aInsertar = unicos.where((x) => !enLocal.contains(_norm(x.orden))).toList();
    return aInsertar;
  }


  @override
  Future<List<PreguntaOpsModel>> getPreguntasOpsFromApi(String userLogin) async {
    final r = await dioMicroServices.msDio.post(
      '/pr_ws_ops_lista_verif_pregunta',
      queryParameters: {'userLogin': userLogin},
    );
    if (r.statusCode != 200) throw ServerException(statusCode: r.statusCode);

    final list = (r.data['data'] as List)
        .map((e) => PreguntaOpsModel.fromJson(e))
        .toList();

    String _norm(String? s) => (s ?? '').trim();
    final vistos = <String>{};
    final unicos = <PreguntaOpsModel>[];
    for (final x in list) {
      final k = _norm(x.orden);
      if (!vistos.add(k)) continue;
      unicos.add(x);
    }

    final filas = await LocalSqlite().readData(
      "SELECT TRIM(orden) AS k FROM ${LocalSqlite.TABLE_OPS_LISTA_VERIF_PREGUNTA};",
    );
    final enLocal = filas.map((f) => (f['k'] ?? '').toString()).toSet();

    final aInsertar = unicos.where((x) => !enLocal.contains(_norm(x.orden))).toList();
    return aInsertar;
  }


  @override
  Future<List<TurnoModel>> getTurnoOpsFromApi() async {
    final result = await dioMicroServices.msDio.post(
      '/pr_ws_turno',
    );

    if (result.statusCode == 200) {
      final data = result.data['data'];

      final list =
          List.from(data).map((item) => TurnoModel.fromJson(item)).toList();

      return list;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }
  @override
  Future<List<ResultadoOpsModel>> getResultadoOpsFromApi() async {
    final r = await dioMicroServices.msDio.post('/pr_ws_ops_lista_verif_resultado');
    if (r.statusCode != 200) throw ServerException(statusCode: r.statusCode);

    final list = (r.data['data'] as List)
        .map((e) => ResultadoOpsModel.fromJson(e))
        .toList();

    String _norm(String? s) => (s ?? '').trim().toUpperCase();
    final vistos = <String>{};
    final unicos = <ResultadoOpsModel>[];
    for (final x in list) {
      final k = _norm(x.codigo);
      if (k.isEmpty || !vistos.add(k)) continue;
      unicos.add(x);
    }

    final filas = await LocalSqlite().readData(
      "SELECT UPPER(TRIM(codigo)) AS k FROM ${LocalSqlite.TABLE_OPS_LISTA_VERIF_RESULTADO};",
    );
    final enLocal = filas.map((f) => (f['k'] ?? '').toString()).toSet();

    final aInsertar = unicos.where((x) => !enLocal.contains(_norm(x.codigo))).toList();
    return aInsertar;
  }


}
