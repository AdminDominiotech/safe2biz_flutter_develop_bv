import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:safe2biz/app/modules/planes_accion/data/datasource/api/planes_accion_api_datasource.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';

class PlanesAccionApi implements PlanesAccionApiDatasource {
  PlanesAccionApi({required this.dioMicroServices});
  final DioMicroServices dioMicroServices;

  @override
  Future<bool> savePlanesAccionApi(PlanAccion planAccion, String userId) async {
    var formData = FormData.fromMap({
      'sac_accion_correctiva_id': planAccion.id,
      'fecha_eje': planAccion.fechaEjecucion,
      'user_id': userId,
      'obs_resp_corr': planAccion.obsRespCorr,
     // 'fecha_origen' : planAccion.fechaOrigen,
     // 'nombre_responsable_verificador' : planAccion.responsableVerificador,
      'evidencia': '${planAccion.evidenciaNombre};${planAccion.evidenciaRuta}',
    });

    final result = await dioMicroServices.msDio.post(
      '/pr_movil_ACC_Actualiza',
      data: formData,
    );
    log('${result}');
    if (result.statusCode == 200) {
      return true;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }
}