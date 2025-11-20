import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/incidente_accidente/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';

class IncidentesAccidentesApi implements IncidentesAccidentesApiDatasource {
  IncidentesAccidentesApi({required this.dioMicroServices});
  final DioMicroServices dioMicroServices;

  @override
  Future<bool> saveIncidenteAccidenteApi(
      IncidenteAccidente incidenteAccidente) async {
    var formData = FormData.fromMap({
      'uea_id': incidenteAccidente.fbUeaPeId,
      'fb_empleado_id': incidenteAccidente.fbEmpleadoId,
      'inc_tipo_evento': incidenteAccidente.incTipoReporte,
      'inc_sub_tipo_evento': incidenteAccidente.incSubTipoReporte,
      'inc_segun_tipo': incidenteAccidente.incSegunTipo,
      'fb_gerencia': incidenteAccidente.fbGerencia,
      'inc_potencial_perdida': incidenteAccidente.incPotencialPerdida,
      'fb_area': incidenteAccidente.fbArea,
      'fecha_evento': incidenteAccidente.fecha,
      'hora': incidenteAccidente.hora,
      'lugar_evento': incidenteAccidente.lugar,
      'descripcion_evento': incidenteAccidente.descripcion,
      'imagen_pre_evento':
          '${incidenteAccidente.imagenPreReporteNombre};${incidenteAccidente.imagenPreReporteRuta}',
      'imagen_evento': '',
    });

    for (var element in formData.fields) {
      print('-> ${element.key}: ${element.value}');
    }
    final result = await dioMicroServices.msDio.post(
      '/pr_movil_INC_Inserta_Incidente',
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
