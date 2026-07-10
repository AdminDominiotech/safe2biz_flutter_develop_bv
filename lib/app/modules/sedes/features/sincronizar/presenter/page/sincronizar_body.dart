import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/global/core/utils/utils.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/models/acto_condicion_model.dart';
import 'package:safe2biz/app/modules/auth/features/settings/data/models/setting_model.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/incidente_accidente/data/datasource/api/incidentes_accidentes_api_datasource.dart';
import 'package:safe2biz/app/modules/incidente_accidente/data/models/incidente_accidente_model.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/incidente_accidente.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/detail_incidente_accidente/presenter/bloc/detail_inc_bloc.dart' as det;
import 'package:safe2biz/app/modules/incidente_accidente/features/detail_incidente_accidente/presenter/page/detail_inc_page.dart';
import 'package:safe2biz/app/modules/incidente_accidente/presenter/bloc/inc_bloc.dart';
import 'package:safe2biz/app/modules/planes_accion/data/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/company/domain/domain.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_page.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/bloc/sincronizar_bloc.dart';
import 'package:safe2biz/app/ui/module_ui.dart';
import 'package:http/http.dart' as http;
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/ayc_nivel_riesgo_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/inc_mensuales_tipo_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_frecuencia_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_severidad_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

final _modules = [
  'Módulo de Incidentes',
  'Módulo de Actos y Condiciones',
  'Módulo de Planes de Acción',
  'Módulo de Listas de Verificación'
];

int? entrega_id;
int? cantProdEntregar;

SqlDb sqlDb = SqlDb();
final auth = GetIt.I<AuthController>();
class SincronizarBody extends StatefulWidget {
  SincronizarBody({Key? key}) : super(key: key);
  @override
  State<SincronizarBody> createState() => _SincronizarBodyState();
}
final apiEntrega = ApiEntregaEpp();

LocalSqlite sqlite = LocalSqlite();
final authController = AuthController(sqlite: sqlite);

class _SincronizarBodyState extends State<SincronizarBody> {
  bool _cargando = false;

  Future<void> _bootstrap() async {
    if (_cargando) return;
    _cargando = true;
    try {



      if (!mounted) return;
      setState(() {}); // refresca UI si corresponde
    } catch (e) {
      if (!mounted) return;
      Toast.show(description: 'Error: $e', toastType: ToastType.error);
    } finally {
      _cargando = false;
    }
  }


  final _checkModuleINC = ValueNotifier<bool>(false);
  final _checkModuleAyC = ValueNotifier<bool>(false);
  final _checkModuleAC = ValueNotifier<bool>(false);
  final _checkModuleOPS = ValueNotifier<bool>(false);

  String syncSedeName = '';
  String syncDate = '';

  bool isSync = false;

  late GlobalKey<SfCartesianChartState> _cartesianChartOne;
  late GlobalKey<SfCartesianChartState> _cartesianChartTwo;
  late GlobalKey<SfCartesianChartState> _cartesianChartThree;
  late GlobalKey<SfCartesianChartState> _cartesianChartFour;

  String _joinUrl(String base, String tail) {
    final b = base.replaceAll(RegExp(r'/+$'), '');      // quita '/' al final
    final t = tail.replaceFirst(RegExp(r'^/+'), '');    // quita '/' al inicio
    return '$b/$t';
  }

  Uri _wsUrl(String base, String path) {
    var b = base.trim();
    if (b.startsWith('https://')) {
      b = b.replaceFirst('https://', 'http://'); // si tu server lo requiere
    }
    b = b.replaceAll(RegExp(r'/+$'), '');     // quita '/' al final
    final p = path.replaceFirst(RegExp(r'^/+'), ''); // quita '/' al inicio
    return Uri.parse('$b/$p');
  }









  Future<List<IncidenteAccidenteModel>> getIncidentesAccidentesFromStorage() async {
    final user = await authController.getUserFromStorage();

    try {
      final idSede = LocalPreferences.prefs?.getString('current_sede_id') ??
          '0';
      final estadoSinSubir = '0';

      final db = await sqlite.database;
      final result = await db.query(
        LocalSqlite.TABLE_INC_REGISTRO,
        whereArgs: [idSede, estadoSinSubir],
        where: 'fb_uea_pe_id = ? AND estado = ?',
      );

      if (result.isNotEmpty) {
        //future send data api
        print("ID sede ----> ${idSede} ");

        final model = List.from(result)
            .map((item) => IncidenteAccidenteModel.fromJson(item))
            .toList();

        print("model -- $model");
        print("1--- ${model[0].fbArea} --- ${model[0].fbGerencia} -- ${model[0]
            .hora}");

        for (var i = 0; i <= model.length; i++) {
          final editInc = await db.execute("UPDATE 'INC_REGISTRO' "
              " SET 'estado' = '1' "
              " WHERE INC_REGISTRO.inc_incidente_id = '${model[i].id}' ");

          print("Se ha cambiado el estado de los registros de --- ${model[i]
              .id}");

          Future <http.Response> postEntregaEpp() async {
            var url = '${user!.urlApp}/ws/null/pr_movil_INC_Inserta_Incidente';
            var map = new Map<String, dynamic>();
            var data = [];

            map['uea_id'] = '${model[i].fbUeaPeId}';
            map['fb_empleado_id'] = '${model[i].fbEmpleadoId}';
            map['inc_tipo_evento'] = '${model[i].incTipoReporte}';
            map['inc_sub_tipo_evento'] = '${model[i].incSubTipoReporte}';
            map['inc_segun_tipo'] = '${model[i].incSegunTipo}';
            map['fb_gerencia'] = '${model[i].fbGerencia}';
            map['inc_potencial_perdida'] = '${model[i].incPotencialPerdida}';
            map['fb_area'] = '${model[i].fbArea}';
            map['fecha_evento'] = '${model[i].fecha}';
            map['hora'] = '${model[i].hora}';
            map['lugar_evento'] = '${model[i].lugar}';
            map['descripcion_evento'] = '${model[i].descripcion}';
            map['imagen_pre_evento'] =
            '${model[i].imagenPreReporteNombre};${model[i]
                .imagenPreReporteRuta}';
            map['imagen_evento'] = '';


            //datoEntregaProd.first["fecha_entrega"].substring(0,10)
            final response2 = await http.post(Uri.parse(url),
                headers: {
                  "userLogin": "${user.userLogin}@${user.arroba}",
                  "userPassword": "${user.password}",
                  "systemRoot": "${user.enterprise}"
                },
                body: map
            );

            print("Mapa ---> $map");

            log('${result}');
            if (response2.statusCode == 201) {
              print('Data inserted successfully');
            } else {
              print('Insertion failed--- NULL');
            }
            data = json.decode(response2.body)['data'];


            //entrega_id = data[0]['epp_entrega_id'];
            //                entrega_id = jsonDecode(response2.body[0]);
            //              print("Valor entrega_id ==> $entrega_id");


            print("En ejecución...");

            print(response2.body);
            return response2;
          }


          await postEntregaEpp();
        }

        print("TABLE INC ---- $model");

        return model;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  //Subir a la nube registros Actos y Condiciones
  Future<List<ActoCondicionModel>> getAYCFromStorage() async {
    final user = await authController.getUserFromStorage();
    try {
      final idSede = LocalPreferences.prefs?.getString('current_sede_id') ??
          '0';
      final estadoSinSubir = '0';

      final db = await sqlite.database;
      final result = await db.query(
        LocalSqlite.TABLE_AYC_REGISTRO,
        whereArgs: [idSede, estadoSinSubir],
        where: 'fb_uea_pe_id = ? AND estado = ?',
      );


      if (result.isNotEmpty) {
        //future send data api
        print("ID sede ----> ${idSede} ");

        final model = List.from(result)
            .map((item) => ActoCondicionModel.fromJson(item))
            .toList();

        print("model -- $model");

        for (var i = 0; i <= model.length; i++) {
          final editInc = await db.execute("UPDATE 'AYC_REGISTRO' "
              " SET 'estado' = '1' "
              " WHERE AYC_REGISTRO.ayc_registro_id = '${model[i].id}' ");

          print("Se ha cambiado el estado de los registros de --- ${model[i].id}");

          Future <http.Response> postEntregaEpp() async {
            var url = '${user!.urlApp}/ws/null/pr_movil_AYC_Inserta_AyC';
            var map = new Map<String, dynamic>();
            var data = [];

            map['empleado'] = '${model[i].fbEmpleadoId}';
            map['uea'] = '${model[i].fbUeaPeId}';
            map['origen'] = '${model[i].origen}';
            map['desviacion'] = '${model[i].estado}';
            map['empresa'] = '${model[i].fbEmpresaEspecializadaId}';
            map['gerencia'] = '${model[i].fbGerencia}';
            map['area'] = '${model[i].fbAreaId}';
            map['lugar'] = '${model[i].lugar}';
            map['fecha'] = '${model[i].fecha}';
            map['hora'] = '${model[i].hora}';
            map['tipo_evento'] = '${model[i].tipoEventoId}';
            map['nivel_riesgo'] = '${model[i].nivelRiesgoId}';
            map['descripcion'] = '${model[i].descripcion}';
            map['accion_ejec'] = '${model[i].accionEjec}';
            map['corrigio'] = '${model[i].corrigio}';
            map['foto_pre_evento'] =
            '${model[i].fotoPreEventoNombre};${model[i].fotoPreEventoRuta}';
            map['foto_evento'] =
            '${model[i].fotoEventoNombre};${model[i].fotoEventoRuta}';
            map['latitud'] = '${model[i].latitud}';
            map['longitud'] = '${model[i].longitud}';
            map['bsafId'] = '${model[i].bsafId}';
            map['tarjetaRoja'] = '${model[i].tarjetaRoja}';


            //datoEntregaProd.first["fecha_entrega"].substring(0,10)
            final response2 = await http.post(Uri.parse(url),
                headers: {
                  "userLogin": "${user.userLogin}@${user.arroba}",
                  "userPassword": "${user.password}",
                  "systemRoot": "${user.enterprise}"
                },
                body: map
            );

            print("Mapa ---> $map");

            log('${result}');
            if (response2.statusCode == 201) {
              print('Data inserted successfully');
            } else {
              print('Insertion failed--- NULL');
            }
            data = json.decode(response2.body)['data'];


            //entrega_id = data[0]['epp_entrega_id'];
            //                entrega_id = jsonDecode(response2.body[0]);
            //              print("Valor entrega_id ==> $entrega_id");


            print("En ejecución...");

            print(response2.body);
            return response2;
          }


          await postEntregaEpp();
        }

        print("TABLE AYC ---- $model");

        return model;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  //Subir Planes de Acción
  //Subir a la nube registros Actos y Condiciones
  /*
  Future<List<PlanesAccionModel>> getPlanAccionFromStorage() async {
    final user = await authController.getUserFromStorage();


    try {
      final idSede = LocalPreferences.prefs?.getString('current_sede_id') ??
          '0';
      final estadoSinSubir = '0';

      final db = await sqlite.database;
      final result = await db.query(
        LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA,
        whereArgs: [idSede, estadoSinSubir],
        where: 'uea_id = ? AND estado = ?',
      );


      if (result.isNotEmpty) {
        //future send data api
        print("ID sede ----> ${idSede} ");

        final model = List.from(result)
            .map((item) => PlanesAccionModel.fromJson(item))
            .toList();

        print("model -- $model");
        for (var i = 0; i <= model.length; i++) {
          final editInc = await db.execute("UPDATE 'SAC_ACCION_CORRECTIVA' "
              " SET 'estado' = '1' "
              " WHERE SAC_ACCION_CORRECTIVA.sac_accion_correctiva_id = '${model[i].id}' ");

          print("Se ha cambiado el estado de los registros de --- ${model[i].id}");

          Future <http.Response> postEntregaEpp() async {
            var url = '${user!.urlApp}/ws/null/pr_movil_ACC_Actualiza';
            var map = new Map<String, dynamic>();
            var data = [];

            map['sac_accion_correctiva_id'] = '${model[i].id}';
            map['fecha_eje'] = '${model[i].fechaEjecucion}';
            map['user_id'] = '${auth.getID}';
            map['obs_resp_corr'] = '${model[i].obsRespCorr}';
            map['evidencia'] = '${model[i].evidenciaNombre}; ${model[i].evidenciaRuta}';
                        //datoEntregaProd.first["fecha_entrega"].substring(0,10)
            final response2 = await http.post(Uri.parse(url),
                headers: {
                  "userLogin": "${user.userLogin}@${user.arroba}",
                  "userPassword": "${user.password}",
                  "systemRoot": "${user.enterprise}"
                },
                body: map
            );

            print("Mapa ---> $map");

            log('${result}');
            if (response2.statusCode == 201) {
              print('Data inserted successfully');
            } else {
              print('Insertion failed--- NULL');
            }
            data = json.decode(response2.body)['data'];


            //entrega_id = data[0]['epp_entrega_id'];
            //                entrega_id = jsonDecode(response2.body[0]);
            //              print("Valor entrega_id ==> $entrega_id");


            print("En ejecución...");

            print(response2.body);
            return response2;
          }


          await postEntregaEpp();
        }

        print("TABLE AYC ---- $model");

        return model;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

*/

  void sendEpp() async {
  final idSede = LocalPreferences.prefs?.getString('current_sede_id') ??
      '0';
  final estadoSinSubir = '0';

  List<Map> responseReadAll = await sqlDb.readData(
      "SELECT empleadoMina.id, empleadoMina.fb_empleado_id, empleadoMina.nombreCompleto,empleadoMina.fb_puesto_trabajo_id,empleadoMina.cargo_nombre, empleadoMina.foto,empleadoMina.numero_documento,empleadoMina.area_nombre, empleadoMina.fb_area_id,empleadoMina.area_codigo,empleadoMina.puesto_trabajo_codigo,empleadoMina.puesto_trabajo_nombre,empleadoMina.fb_cargo_id,empleadoMina.cargo_codigo,empleadoMina.cargo_nombre,empleadoMina.epp_rol_epp_id,empleadoMina.codigo_rol,empleadoMina.nombre_rol, empleadoMina.fb_uea_pe_id, "
          " empleadoMina.empresa, producto_empleado_mina.fecha_entrega, producto_empleado_mina.hora_entrega, producto_empleado_mina.id as prod_emp_id, producto_empleado_mina.id_empleado as prod_emp_mina_id, producto_empleado_mina.foto_evidencia, producto_empleado_mina.estado_subido, producto_empleado_mina.anho,  producto_empleado_mina.motivo, "
          " SUM(producto_empleado_mina.cantidad) as sumacantidad"
          " FROM empleadoMina "
          " INNER JOIN producto_empleado_mina ON empleadoMina.id = producto_empleado_mina.id_empleado"
          " WHERE empleadoMina.fb_uea_pe_id = $idSede AND producto_empleado_mina.estado_subido = 'Por Enviar'"
          " GROUP BY producto_empleado_mina.foto_evidencia, producto_empleado_mina.hora_entrega"
          " ORDER BY substr(producto_empleado_mina.fecha_entrega,1,4) DESC, substr(producto_empleado_mina.fecha_entrega,9,2) DESC, substr(producto_empleado_mina.fecha_entrega,4,2) ASC, "
          " substr(producto_empleado_mina.hora_entrega, 1,2) ASC, substr(producto_empleado_mina.hora_entrega, 4,2) DESC "
  );

  print("response read all length ${responseReadAll.length}");

  for(var i=0; i<responseReadAll.length; i++){
    String formatDate = "${responseReadAll[i]['fecha_entrega'].replaceAll(new RegExp(r'[^\w\s]+'),'')}";
    String formatHour = "${responseReadAll[i]['hora_entrega'].replaceAll(new RegExp(r'[^\w\s]+'),'')}";
    File fotoSubida = File("${responseReadAll[i]["foto_evidencia"]}");
    final fotoCompress = await Utils.compressImage(fotoSubida);
    final fotoBase64Compress = await Utils.fileToBase64(fotoCompress as File);   //TODO: POSIBLE ERROR FIXIT
    String? base64 = fotoBase64Compress;
    print("BASE 64  $base64");
    print("formatDate ${formatDate}");
    String base64Subida = '${formatDate}${formatHour}${responseReadAll[i]['id']}-min.jpg;${base64}';

    print("prod_emp_id  ---- ${responseReadAll[i]['prod_emp_id']}");


    final editInc = await sqlDb.readData("UPDATE 'producto_empleado_mina' "
        " SET 'estado_subido' = 'Enviado' "
        " WHERE producto_empleado_mina.id = '${responseReadAll[i]['prod_emp_id']}' ");

  Future <http.Response> postEntregaEpp() async {
    final user = await authController.getUserFromStorage();


    var url = '${user!.urlApp}/ws/null/entrega_epp?pr_ws_entrega';
    var map = new Map<String, dynamic>();
    map['fb_empleado_id'] = '${responseReadAll[i]['fb_empleado_id']}';
    map['dni'] = '${responseReadAll[i]['numero_documento']}';
    map['nombreCompleto'] = '${responseReadAll[i]['nombreCompleto']}';
    map['fb_area_id'] = '${responseReadAll[i]["fb_area_id"]}';
    map['codigo_area'] = '${responseReadAll[i]["area_codigo"]}';
    map['nombre_area'] = '${responseReadAll[i]["area_nombre"]}';
    map['fb_puesto_trabajo_id'] =
    '${responseReadAll[i]["fb_puesto_trabajo_id"]}';
    map['codigo_puesto'] = '${responseReadAll[i]["puesto_trabajo_codigo"]}';
    map['nombre_puesto'] = '${responseReadAll[i]["puesto_trabajo_nombre"]}';
    map['fb_cargo_id'] = '${responseReadAll[i]["fb_cargo_id"]}';
    map['codigo_cargo'] = '${responseReadAll[i]["cargo_codigo"]}';
    map['nombre_cargo'] = '${responseReadAll[i]["cargo_nombre"]}';
    map['epp_rol_epp_id'] = '${responseReadAll[i]["epp_rol_epp_id"]}';
    map['rol_epp_codigo'] = '${responseReadAll[i]["codigo_rol"]}';
    map['rol_epp_nombre'] = '${responseReadAll[i]["nombre_rol"]}';
    map['epp_ficha_entrega_id'] = '1';
    map['fb_uea_pe_id'] = '${responseReadAll[i]["fb_uea_pe_id"]}';
    map['fecha_entrega'] = '${responseReadAll[i]["fecha_entrega"]}';
   // map['foto_evidencia'] = '${base64Subida}';


    var data =[];

    //datoEntregaProd.first["fecha_entrega"].substring(0,10)
    final response2 = await http.post(Uri.parse(url),
        headers: {

          "userLogin": "${user.userLogin}@${user.arroba}",
          "userPassword": "${user.password}",
          "systemRoot": "${user.enterprise}"
        },
        body: map
    );

    print("Mapa ---> $map");

    // log('${result}');
    if (response2.statusCode == 201) {
      print('Data inserted successfully');
    } else {
      print('Insertion failed--- NULL');
    }
    data = json.decode(response2.body)['data'];
    print("Valores ENTREGA------> ${data[0]['epp_entrega_id']}");

    entrega_id = data[0]['epp_entrega_id'];

    //                entrega_id = jsonDecode(response2.body[0]);
    //              print("Valor entrega_id ==> $entrega_id");

    print(response2.body);
    return response2;
  }
  await postEntregaEpp();
}

}
void sendEppDetalle() async{
  final idSede = LocalPreferences.prefs?.getString('current_sede_id') ??
      '0';
  final estadoSinSubir = '0';

  List<Map> responseReadAll = await sqlDb.readData(
      "SELECT empleadoMina.id, empleadoMina.fb_empleado_id, empleadoMina.nombreCompleto,empleadoMina.fb_puesto_trabajo_id,empleadoMina.cargo_nombre, empleadoMina.foto,empleadoMina.numero_documento,empleadoMina.area_nombre, empleadoMina.fb_area_id,empleadoMina.area_codigo,empleadoMina.puesto_trabajo_codigo,empleadoMina.puesto_trabajo_nombre,empleadoMina.fb_cargo_id,empleadoMina.cargo_codigo,empleadoMina.cargo_nombre,empleadoMina.epp_rol_epp_id,empleadoMina.codigo_rol,empleadoMina.nombre_rol, empleadoMina.fb_uea_pe_id, "
          " empleadoMina.empresa, producto_empleado_mina.fecha_entrega, producto_empleado_mina.hora_entrega, producto_empleado_mina.id as prod_emp_id, producto_empleado_mina.id_empleado as prod_emp_mina_id, producto_empleado_mina.foto_evidencia, producto_empleado_mina.estado_subido, producto_empleado_mina.anho,  producto_empleado_mina.motivo, "
          " SUM(producto_empleado_mina.cantidad) as sumacantidad"
          " FROM empleadoMina "
          " INNER JOIN producto_empleado_mina ON empleadoMina.id = producto_empleado_mina.id_empleado"
          " WHERE empleadoMina.fb_uea_pe_id = $idSede "
          " GROUP BY producto_empleado_mina.foto_evidencia, producto_empleado_mina.hora_entrega"
          " ORDER BY substr(producto_empleado_mina.fecha_entrega,1,4) DESC, substr(producto_empleado_mina.fecha_entrega,9,2) DESC, substr(producto_empleado_mina.fecha_entrega,4,2) ASC, "
          " substr(producto_empleado_mina.hora_entrega, 1,2) ASC, substr(producto_empleado_mina.hora_entrega, 4,2) DESC "
  );

  Future.delayed(Duration(milliseconds: 2000), () async {

    cantProdEntregar = responseReadAll.length;
    for(var j = 0; j<=cantProdEntregar!; j++){
      //print("Entregas ----> $entregas");


      List<Map> datoEntregaDetalleProd = await sqlDb.readData(
          " SELECT EntregaDetalleEpp.epp_entrega_id, EntregaDetalleEpp.epp_ficha_entrega_id, EntregaDetalleEpp.epp_equipo_id, EntregaDetalleEpp.epp_producto_id, EntregaDetalleEpp.epp_motivo_entrega_id, "
              "EntregaDetalleEpp.epp_almacen_temp_id, EntregaDetalleEpp.estado_vigencia, EntregaDetalleEpp.flag_uso, EntregaDetalleEpp.fecha_entrega, EntregaDetalleEpp.fecha_fin_vigencia, "
              "EntregaDetalleEpp.flag_pertenece_rol, EntregaDetalleEpp.cantidad, EntregaDetalleEpp.tiempo_recambio  "
              " FROM EntregaDetalleEpp "
              " WHERE EntregaDetalleEpp.id_emp = '${responseReadAll[j]['id']}' AND EntregaDetalleEpp.fecha_entrega = '${responseReadAll[j]['fecha_entrega']}' AND EntregaDetalleEpp.hora_entrega = '${responseReadAll[j]['hora_entrega']}' ");

      print("dato entrega detalle --- $datoEntregaDetalleProd");

      Future <http.Response> postEntregaDetalleEpp() async {
        final user = await authController.getUserFromStorage();
        var url2 = '${user!.urlApp}/ws/null/entrega_detalle_epp?pr_ws_entrega_detalle';

        var map2 = Map<String, dynamic>();
        map2['epp_entrega_id'] = '${entrega_id}';
        map2['epp_ficha_entrega_id'] = '1';
        map2['epp_equipo_id'] = '${datoEntregaDetalleProd[j]["epp_equipo_id"]}';
        map2['epp_producto_id'] = '${datoEntregaDetalleProd[j]["epp_producto_id"]}';
        map2['epp_motivo_entrega_id'] = '${datoEntregaDetalleProd[j]["epp_motivo_entrega_id"]}';
        map2['epp_almacen_temp_id'] = '${datoEntregaDetalleProd[j]["epp_almacen_temp_id"]}';
        map2['fb_puesto_trabajo_id'] = '${datoEntregaDetalleProd[j]["fb_puesto_trabajo_id"]}';
        map2['estado_vigencia'] = '${datoEntregaDetalleProd[j]["estado_vigencia"]}';
        map2['flag_uso'] = '${datoEntregaDetalleProd[j]["flag_uso"]}';
        map2['fecha_entrega'] = '${datoEntregaDetalleProd[j]["fecha_entrega"]}';   //current day when the register is update on server
        map2['fecha_fin_vigencia'] = '${datoEntregaDetalleProd[j]["fecha_fin_vigencia"]}';  //current day when the register is update on server + tiempo_recambio
        //       map2['cantidad_dias_vigente'] = '30';                              //Fecha actual - fecha de vigencia
        map2['flag_pertenencia'] = '${datoEntregaDetalleProd[j]["flag_pertenencia"]}';
        map2['cantidad'] = '${datoEntregaDetalleProd[j]["cantidad"]}';
        map2['fb_uea_pe_id'] = '${idSede}';
        map2['flag_pertenece_rol'] = '1';
        map2['tiempo_recambio'] = '${datoEntregaDetalleProd[j]["tiempo_recambio"]}';

        //datoEntregaProd.first["fecha_entrega"].substring(0,10)
        final response3 = await http.post(Uri.parse(url2),
            headers: {

              "userLogin": "${user.userLogin}@${user.arroba}",
              "userPassword": "${user.password}",
              "systemRoot": "${user.enterprise}"
            },
            body: map2
        ).timeout(Duration(seconds: 5));

        //   log('${result}');
        if (response3.statusCode == 201) {
          print('Data inserted successfully');
        } else {
          print(
              'Insertion failed--- NULL');
        }
        print(
            "Valores ENTREGA_DETALLE------> ${jsonDecode(
                response3.body)}");
        print(
            "ENTREGA DETALLE VALORES ----> ${response3.body}");
        print(
            "MAPA entrega_detalle ${map2}");

        setState(() { });

        return response3;
      }
      await postEntregaDetalleEpp();
    }
  });


}


  void asyncMethod() async{
    await getIncidentesAccidentesFromStorage();
    // La sincronizacion SOLO debe descargar informacion (tablas secundarias),
    // NO subir registros del usuario. Antes esto subia los Actos y Condiciones
    // (estado='0') a la nube y los marcaba estado='1', lo que provocaba que se
    // borraran/purgaran. La subida de AyC ahora se hace UNICAMENTE desde la
    // lista de Actos y Condiciones (boton de subir), no al sincronizar.
    // await getAYCFromStorage();
    //await getPlanAccionFromStorage();
    //sendEpp();
    //sendEppDetalle();
    apiEntrega.getAllEmp();

/*
    List<Map> responseReadAll = await sqlDb.readData(
        "SELECT empleadoMina.id, empleadoMina.fb_empleado_id, empleadoMina.nombreCompleto,empleadoMina.fb_puesto_trabajo_id,empleadoMina.cargo_nombre, empleadoMina.foto,empleadoMina.numero_documento,empleadoMina.area_nombre, empleadoMina.fb_area_id,empleadoMina.area_codigo,empleadoMina.puesto_trabajo_codigo,empleadoMina.puesto_trabajo_nombre,empleadoMina.fb_cargo_id,empleadoMina.cargo_codigo,empleadoMina.cargo_nombre,empleadoMina.epp_rol_epp_id,empleadoMina.codigo_rol,empleadoMina.nombre_rol, empleadoMina.fb_uea_pe_id, "
            " empleadoMina.empresa, producto_empleado_mina.fecha_entrega, producto_empleado_mina.hora_entrega, producto_empleado_mina.id_empleado as prod_emp_mina_id, producto_empleado_mina.foto_evidencia, producto_empleado_mina.estado_subido, producto_empleado_mina.anho,  producto_empleado_mina.motivo, "
            " SUM(producto_empleado_mina.cantidad) as sumacantidad"
            " FROM empleadoMina "
            " INNER JOIN producto_empleado_mina ON empleadoMina.id = producto_empleado_mina.id_empleado"
            " WHERE empleadoMina.fb_uea_pe_id = 1 "
            " GROUP BY producto_empleado_mina.foto_evidencia, producto_empleado_mina.hora_entrega"
            " ORDER BY substr(producto_empleado_mina.fecha_entrega,1,4) DESC, substr(producto_empleado_mina.fecha_entrega,9,2) DESC, substr(producto_empleado_mina.fecha_entrega,4,2) ASC, "
            " substr(producto_empleado_mina.hora_entrega, 1,2) ASC, substr(producto_empleado_mina.hora_entrega, 4,2) DESC "
    );
    print("response epp --$responseReadAll\n ");
    print("Content first row--- ${responseReadAll[0]}\nId first row----- ${responseReadAll[0]['id']} ");
*/
  }


  @override
  void initState() {
    super.initState();
    asyncMethod();
    _bootstrap();
  //  readData();



//03-03-2023

    _download(context);
   // _upload(context);

    /*
    Future.delayed(const Duration(milliseconds: 500), () {
      _download(context);
    });
    */

    //asyncMethod();
  }

  bool loadSync = false;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    syncSedeName = LocalPreferences.prefs?.getString(
      'sync_sede',
    ) ??
        '';
    syncDate = LocalPreferences.prefs?.getString('sync_date') ?? '';
    final auth = GetIt.I<AuthController>();
    return WillPopScope(
      onWillPop: () async {
        Nav.back(context, isSync);
        return false;
      },
      child: Scaffold(
        appBar: AppBarBack(
          'Descargar Información',
          showLogo: false,
          onPressed: () {
            Nav.back(context, isSync);
          },
        ),
        backgroundColor: S2BColors.white,
        body: BlocListener<SincronizarBloc, SincronizarState>(

          listener: (context, state) async {
            if (state is DownloadingModulos) {
           // print("downloading modulos ---- $DownloadingModulos();");
              /*
              LoadingInfo.show(
                context: context,
                message: 'Descargando...',
              );
              */
            }
            if (state is CloseLoading) {
              Nav.back(context);
            }

            if (state is DownloadedModulos) {
              final date = DateTime.now();
              syncSedeName = LocalPreferences.prefs?.getString('current_sede') ?? '';
              syncDate = '${date.formatLocalFech} - ${date.formatHour}';
              await LocalPreferences.prefs?.setString('sync_sede', syncSedeName);
              await LocalPreferences.prefs?.setString('sync_date', syncDate);
              isSync = true;
              Toast.show(
                description:
                'Información Descargada Exitosamente !',
                toastType: ToastType.success,
              );
            }
          },
          child: BlocBuilder<SincronizarBloc, SincronizarState>(
            builder: (context, state) {
              final hasModules =
                  auth.getModulos().contains(Module.INC.name) ||
                  auth.getModulos().contains(Module.AYC.name) ||
                  auth.getModulos().contains(Module.PLAN_ACCION.name);
              return ListView(
                padding: const EdgeInsets.all(S2BRadius.md),
                children: [
                  TextLabel.h6(
                    'Sincronización de Datos',
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                    color: S2BColors.blue,
                  ),
                  Image.asset(
                    UiValues.couldSyncIconGif,
                    height: size.height * .25,
                  ),
                  TextLabel.body(
                    'Ultima sincronización',
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                    color: S2BColors.primaryColor,
                  ),
                  TextLabel.body(
                    'Fecha: $syncDate',
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                    color: S2BColors.primaryColor,
                  ),
                  TextLabel.body(
                    'Sede: $syncSedeName',
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                    color: S2BColors.primaryColor,
                  ),
                  if (auth.getModulos().contains(Module.INC.name))

                    ValueListenableBuilder<bool>(
                      valueListenable: _checkModuleINC,
                      builder: (context, check, __) {
                        return _ItemInfo(
                          label: _modules[0],
                          value: check,
                          onChanged: (value) {
                            _checkModuleINC.value = value ?? false;

                          },
                        );
                      },

                    ),
                  if (auth.getModulos().contains(Module.AYC.name))
                    ValueListenableBuilder<bool>(
                      valueListenable: _checkModuleAyC,
                      builder: (context, check, __) {
                        return _ItemInfo(
                          label: _modules[1],
                          value: check,
                          onChanged: (value) {
                            _checkModuleAyC.value = value ?? false;
                            print("======== Se cargo el modulo AYC");
                          },
                        );
                      },
                    ),
                  if (auth.getModulos().contains(Module.PLAN_ACCION.name))
                    ValueListenableBuilder<bool>(
                        valueListenable: _checkModuleAC,
                        builder: (context, check, __) {
                          return _ItemInfo(
                            label: _modules[2],
                            value: check,
                            onChanged: (value) {
                              _checkModuleAC.value = value ?? false;
                              print("======== Se cargo el modulo PLAN ACCION");
                            },
                          );
                        }),
                  if (auth.getModulos().contains(Module.LIST_VERIFI.name))
                    ValueListenableBuilder<bool>(
                        valueListenable: _checkModuleOPS,
                        builder: (context, check, __) {
                          return _ItemInfo(
                            label: _modules[3],
                            value: check,
                            onChanged: (value) {
                              _checkModuleOPS.value = value ?? false;
                              print("======== Se cargo el modulo LIST_VERIFICACION");
                            },
                          );
                        }),



                  SizedBox(height: 25,),
                  Visibility(
                    visible: true,
                    child: RepaintBoundary(
                      child: GestureDetector(
                        child: SimpleCircularProgressBar(
                          size: 60,
                          progressStrokeWidth: 10,
                          backStrokeWidth: 15,
                          onGetText: (double value) {

                            TextStyle centerTextStyle = TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF00297B).withOpacity(value * 0.01),
                            );

                            return Text(
                              '${value.toInt()}',
                              style: centerTextStyle,
                            );
                          },

                          animationDuration: 12,
                          progressColors: [
                            Colors.white
                          ],
                          backColor: Color(0XFF00297B),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sincronizando...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                      
                    ],
                  )
                  
                  
                  
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _download(BuildContext context) async {

    int insertFlag =
    await sqlDb.insertData(
        "INSERT INTO 'EstadoBloc' "
            "('estado_bloc') VALUES "
            "('1' )");
    print("Se inserto el flag estado_bloc ============> ${insertFlag}");
    print("No hubo sincronizacion");

    //Instancia request EPP
    context.read<SincronizarBloc>().add(
          GetModulosEv(

            downloadAyC: _checkModuleAyC.value,
            downloadINC: _checkModuleINC.value,
            downloadAC: _checkModuleAC.value,
            downloadOPS: _checkModuleOPS.value,

          ),
        );
    print("=====  CHECK INC ---${_checkModuleINC.value}");
    print("=====  CHECK AYC ---${_checkModuleAyC.value}");

  }


//Upload Incidentes
}

class _ItemInfo extends StatelessWidget {
  const _ItemInfo({
    Key? key,
    required this.label,
    this.value = false,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final bool? value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: S2BRadius.xs),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(S2BRadius.xs),
        color: S2BColors.white,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: S2BSpacing.sl,
            vertical: S2BSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextLabel.body(
                  label,
                  fontWeight: FontWeight.w500,
                  textOverflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              // SizedBox(
              //   height: 20,
              //   width: 20,
              //   child: Checkbox(
              //     value: value,
              //     onChanged: onChanged,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

Future <List<void>> RequestDataIncMensualData(String anho) async {
  final user = await authController.getUserFromStorage();

  var url = '${user!.urlApp}/ws/null/pr_grp_Estad_Incidente_Mensual?fb_uea_pe_id=${auth.user.value!.uuid}&anho=$anho';
  var mapIncGen = Map<String, dynamic>();
  var datos = [];
  var response = await http.post(Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "userLogin": "${user.userLogin}@${user.arroba}",
      "userPassword": "${user.password}",
      "systemRoot": "${user.enterprise}"
    },
  );

  print("${response.statusCode}");
  datos = json.decode(response.body)['data'];
  final result =
  (datos.map((e) => inc_mensuales_tipo_model.fromJson(e)).toList() as List).map((emp) {
    print('Insertando.. $emp');
    sqlDb.createIncidentesMesTipo(emp);
  }).toList();
  return result;
}




Future <List<void>> RequestAYCnivel(String anho) async {
  final user = await authController.getUserFromStorage();

  var url = '${user!.urlApp}/ws/null/pr_grp_ayc_nivel_riesgo?fb_uea_pe_id=${auth.user.value!.uuid}&Anno=$anho';
  var mapIncGen = Map<String, dynamic>();
  var datos = [];
  var response = await http.post(Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "userLogin": "${user.userLogin}@${user.arroba}",
      "userPassword": "${user.password}",
      "systemRoot": "${user.enterprise}"
    },
  );

  print("${response.statusCode}");

  datos = json.decode(response.body)['data'];
  final result =
  (datos.map((e) => ayc_nivel_riesgo_model.fromJson(e)).toList() as List).map((emp) {
    print('Insertando.. $emp');
    sqlDb.createAycNivelRiesgo(emp);
  }).toList();
  return result;
}



Future<List<Map>> readData() async {


  List<Map> responseReadAll = await sqlDb.readData(
      "SELECT * FROM INC_REGISTRO"
  );

  print("response INC_REGISTRO --- $responseReadAll");
  return responseReadAll;

}
