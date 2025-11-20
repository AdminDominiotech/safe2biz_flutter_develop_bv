



import 'dart:convert';
import 'dart:developer';

import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';

import 'package:safe2biz/app/modules/epp/data/models/EntregaApiDatasource.dart';

class EntregaApi implements EntregaApiDatasource {
  EntregaApi({required this.dioMicroServices});
  final DioMicroServices dioMicroServices;

  @override
  Future<bool> saveEntregaApi() async {
    final result = await dioMicroServices.msDio.post(
      '/entrega_epp?pr_ws_entrega',

      data: {
        'fb_empleado': '0',
        'dni': 'dni' ,
        'nombreCompleto': 'nombreCompleto',
        'fb_area_id': '0',
        'codigo_area': 'codigo_area',
        'nombre_area': 'nombre_area',
        'fb_puesto_trabajo_id' : '0' ,
        'codigo_puesto' : 'codigo_puesto',
        'nombre_puesto' : 'nombre_puesto',
        'fb_cargo_id' : '0',
        'codigo_cargo' : 'codigo_cargo',
        'nombre_cargo' : 'nombre_cargo',
        'epp_rol_epp_id' : '0',
        'rol_epp_codigo' : 'rol_epp_codigo',
        'rol_epp_nombre' : 'rol_epp_nombre',
        'epp_ficha_entrega_id' : '0',
        'fb_uea_pe_id' : '0',
        'fecha_entrega' : 'fecha_entrega_epp'

      },
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
