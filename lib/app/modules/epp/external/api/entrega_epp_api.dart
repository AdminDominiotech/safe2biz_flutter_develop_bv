import 'dart:async';
import 'dart:convert';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/capacitacion_empleado_model.dart';
import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/enfermedades_empleado_model.dart';
import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/examen_medico_empleado_model.dart';
import 'package:safe2biz/app/modules/capacitacion/domain/entities/estado_curso_model.dart';
import 'package:safe2biz/app/modules/capacitacion/domain/entities/modalidad_model.dart';
import 'package:safe2biz/app/modules/capacitacion/domain/entities/rol_expo_model.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/empleado_model.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/producto_model.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:http/http.dart' as http;
import 'package:safe2biz/app/modules/epp/presenter/page/estadistica_entrega.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/lista_entrega.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/inc_mensuales_tipo_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/ayc_nivel_riesgo_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_frecuencia_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_severidad_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/frecuencia_mti_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/plan_accion_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev;

final localSqliteInstance = LocalSqlite();
final authController = AuthController(sqlite: localSqliteInstance);

class ApiEntregaEpp {
static ApiEntregaEpp? _instance;



factory ApiEntregaEpp() => _instance ??= new ApiEntregaEpp._();

  ApiEntregaEpp._();

Future<List<Map<String, dynamic>>> fetchDataParaSede(int sedeId) async {
  // Ejemplo con http:
  final url = Uri.parse('https://tu.api/entrega/sede/$sedeId');
  final resp = await http.get(url);
  if (resp.statusCode != 200) {
    throw Exception('Error al descargar datos de la sede $sedeId');
  }
  final body = json.decode(resp.body);
  // Asumo que el JSON viene con un array bajo "data"
  return List<Map<String, dynamic>>.from(body['data']);
}

@override
Future <List<Map>> readDataEntregaMinaEpp() async {
  List<Map> datoEscaneadoMinaProd = await sqlDb.readData("SELECT * FROM producto_empleado_mina ");
  print("prod_emp_epp ---> $datoEscaneadoMinaProd");
  return datoEscaneadoMinaProd;
}

Future <List<Map>> readDataEntregaEpp() async {
  List<Map> datoEscaneadoProd = await sqlDb.readData("SELECT * FROM EntregaEpp ");
  print("Entrega EPP ---> $datoEscaneadoProd");

  return datoEscaneadoProd;
}

Future <List<Map>> readDataEntreg() async {
  List<Map> datoEscaner = await sqlDb.readData(
      "SELECT EntregaEpp.fb_empleado_id, EntregaEpp.fecha_entrega, EntregaEpp.hora_entrega "
          " FROM EntregaEpp "
          " WHERE EntregaEpp.fb_empleado_id = '2' "
          " AND EntregaEpp.fecha_entrega = '2023/02/04' "
          " AND EntregaEpp.hora_entrega = '15:49'  ");
  print("Select * from entregaEpp--> $datoEscaner");
  return datoEscaner;
}


Future <List<Map>> readDataEntregaDetalleEpp() async {
  List<Map> datoEscaneadoProd = await sqlDb.readData("SELECT * FROM EntregaDetalleEpp ");
  print("Entrega Detalle EPP ---> $datoEscaneadoProd");
  return datoEscaneadoProd;
}


Future<List<Map>> readDataEntregaEppp() async {
  List<Map> response = await sqlDb.readData("SELECT * FROM EntregaEpp");
  print("ENTREGA EPP ===> $response");
  return response;
}

Future<List<Map>> readDataEntregaDetalleEppp() async {
  List<Map> response =
  await sqlDb.readData("SELECT * FROM EntregaDetalleEpp");
  print("ENTREGA DETALLE EPP $response");
  return response;
}

Future<List<Map>> readDataProdEmp() async {
  List<Map> response =
  await sqlDb.readData("SELECT * FROM producto_empleado_mina ");
  return response;
}

//Filtrar productos escaneados (sin registrar)

Future<List<Map>> readDataProd(int id_emp) async {
  List<Map> responseRead = await sqlDb.readData(""
      "SELECT empleadoMina.nombreCompleto, productoMina.equipo_nombre, productoMina.marca, productoMina.modelo, productoMina.foto_prod, productoMina.codigo, productoMina.nombre_proveedor, productoMina.equipo_descripcion, productoMina.foto_prod, producto_empleado_mina.id, producto_empleado_mina.cantidad,  producto_empleado_mina.estado_subido "
      " FROM producto_empleado_mina "
      " JOIN productoMina ON productoMina.id = producto_empleado_mina.id_producto"
      " JOIN empleadoMina ON empleadoMina.id = producto_empleado_mina.id_empleado where empleadoMina.id = $id_emp AND producto_empleado_mina.estado_subido = 'En Registro' ");
  return responseRead;
}

  Future<void> getAllProd() async {
    final swTotal = Stopwatch()..start();

    // 1) User + request
    final user = await authController.getUserFromStorage();
    if (user == null) {
      throw StateError('Usuario no disponible en storage');
    }

    final url = '${user.urlApp}/ws/null/lista_productos?lista_productos=1';
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'userLogin': '${user.userLogin}@${user.arroba}',
      'userPassword': '${user.password}',
      'systemRoot': '${user.arroba}',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
    };

    dev.log('➡️ getAllProd: POST $url', name: 'API');
    dev.log('Headers: $headers', name: 'API');

    // 2) HTTP con timeout + reintentos
    const httpTimeout = Duration(seconds: 45);
    const maxRetries = 3;
    http.Response resp;
    for (int attempt = 1; ; attempt++) {
      final swHttp = Stopwatch()..start();
      try {
        resp = await http.post(Uri.parse(url), headers: headers).timeout(httpTimeout);
        dev.log('✅ HTTP 200 en ${swHttp.elapsedMilliseconds} ms', name: 'API');
        break;
      } on TimeoutException {
        dev.log('⏳ Timeout intento $attempt', name: 'API');
        if (attempt >= maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      } catch (e, st) {
        dev.log('💥 Error HTTP intento $attempt: $e', stackTrace: st, name: 'API');
        if (attempt >= maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      }
    }

    if (resp.statusCode != 200) {
      dev.log('❗HTTP ${resp.statusCode}: ${resp.reasonPhrase}', name: 'API');
      throw Exception('Failed to load products (${resp.statusCode})');
    }

    // 3) Parseo seguro
    final rawBytes = resp.bodyBytes;
    dev.log('📥 Bytes recibidos: ${rawBytes.length}', name: 'API');

    late final dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(rawBytes));
    } catch (e, st) {
      dev.log('💥 JSON inválido: $e', stackTrace: st, name: 'API');
      throw const FormatException('Respuesta JSON inválida');
    }

    final List<dynamic> data =
    decoded is List ? decoded : (decoded['data'] as List? ?? const []);
    final total = data.length;
    dev.log('📊 Registros a procesar: $total', name: 'API');
    if (total == 0) {
      dev.log('ℹ️ No hay productos que sincronizar. Fin.', name: 'API');
      return;
    }

    // 4) Upsert masivo en SQLite (transaction + batch por bloques)
    final Database? db = await sqlDb.db; // usa tu SqlDb existente
    const chunkSize = 500;
    int processed = 0;
    int batchNum = 0;

    await db!.transaction((txn) async {
      Batch batch = txn.batch();

      Future<void> commitBatch() async {
        batchNum++;
        final swBatch = Stopwatch()..start();
        await batch.commit(noResult: true, continueOnError: true);
        dev.log('🧾 Commit batch #$batchNum en ${swBatch.elapsedMilliseconds} ms', name: 'DB');
        batch = txn.batch();
      }

      for (int i = 0; i < data.length; i++) {
        final m = Map<String, dynamic>.from(data[i] as Map);

        // Mapea campos del JSON → columnas de tu tabla 'productoMina'
        final row = <String, Object?>{
          'id': m['id'],
          'codigo': m['codigo'],
          'equipo_nombre': m['equipo_nombre'],
          'marca': m['marca'],
          'modelo': m['modelo'],
          'nombre_proveedor': m['nombre_proveedor'],
          'observacion': m['observacion'],
          'equipo_descripcion': m['equipo_descripcion'],
          'foto_prod': m['foto_prod'],
          'tipo_equipo_nombre': m['tipo_equipo_nombre'],
          'costo': (m['costo'] as num?)?.toDouble(),
          'tiempo_recambio': m['tiempo_recambio'],
          'tipo_equipo_codigo': m['tipo_equipo_codigo'],
          'tipo_equipo_id': m['tipo_equipo_id'],
          'epp_equipo_id': m['epp_equipo_id'],
          'epp_producto_id': m['epp_producto_id'],
          'equipo_codigo': m['equipo_codigo'],
        };

        batch.insert(
          'productoMina',
          row,
          conflictAlgorithm: ConflictAlgorithm.replace, // upsert simple
        );

        processed++;
        if (processed % chunkSize == 0) {
          dev.log('⏳ Progreso: $processed/$total', name: 'DB');
          await commitBatch();
        }
      }

      if (processed % chunkSize != 0) {
        await commitBatch();
      }
    });

    dev.log('✅ getAllProd COMPLETO. Procesados=$processed/$total '
        '| tiempo total ${swTotal.elapsedMilliseconds} ms', name: 'API');
  }



//Actualizacion de empleados / productos

  Future<List<void>> updAllEmp() async {
    final user = await authController.getUserFromStorage();
    var map = new Map<String, dynamic>();

    map['sc_user_id'] = '18544';

    var data = [];
    var url =
        '${user!.urlApp}/ws/null/empleados?pr_ws_fb_empleados';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );

    body:
    map;

    //UPDATE------

    //Response res = await Dio().get(url);
    data = json.decode(response.body)['data'];
    final result =
    (data.map((e) => EmpleadoModel.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.updateEmployee(emp);
    }).toList();
    return result;
  }


  Future<List<Map>> postRequest(String? query) async {

    List<Map> readSqlEmp = await sqlDb.readData("SELECT * "
        "FROM empleadoMina where empleadoMina.nombreCompleto LIKE '%$query%' AND fb_uea_pe_id = '${sedeEmp}' "); //SEDE
    return readSqlEmp;
  }

  Future<void> getAllEmp() async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_ws_fb_empleados_total?sc_user_id=1';

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "userLogin": "${user.userLogin}@${user.arroba}",
      "userPassword": "${user.password}",
      "systemRoot": "${user.arroba}"
    };

    // Imprime la URL y los headers de manera legible.
    print("URL enviada: $url");
    print("Headers enviados: ${jsonEncode(headers)}");

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      List<EmpleadoModel> employees = data.map((e) => EmpleadoModel.fromJson(e)).toList();

      print('Eliminando antiguos empleados...');
      await sqlDb.deleteAllEmployees();
      print('Insertando empleados...');
      await sqlDb.createEmployees(employees);
    } else {
      throw Exception('Failed to load employees');
    }
  }



  Future<void> getExamenMedicoEmp() async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_ws_examen_medico_empleados?fb_emp=1';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      List<ExamenMedicoEmpleadoModel> examenes = data.map((e) => ExamenMedicoEmpleadoModel.fromJson(e)).toList();

      print('Eliminando antiguos examenes');
      await sqlDb.deleteAllExamenesMedicos();
      print('Insertando examenes medicos actualizados...');;
      await sqlDb.createExamenesMedicos(examenes);
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<void> getEnfermedadesEmp() async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_ws_enfermedades_empleados?fb_emp=1';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      List<EnfermedadesEmpleadoModel> enfermedades = data.map((e) => EnfermedadesEmpleadoModel.fromJson(e)).toList();

      print('Eliminando antiguos datos de enfermedades del empleado');
      await sqlDb.deleteAllEnfermedadesEmpleado();
      print('Insertando datos de enfermedades de empleados actualizados...');;
      await sqlDb.createEnfermedadesEmpleado(enfermedades);
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<void> getCapacitacionEmp() async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_ws_capacitacion_empleados?fb_emp=1';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );


    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      List<CapacitacionEmpleadoModel> capacitaciones = data.map((e) => CapacitacionEmpleadoModel.fromJson(e)).toList();

      print('Eliminando antiguos datos de enfermedades del empleado');
      await sqlDb.deleteAllCapacitacionesEmpleado();
      print('Insertando datos de enfermedades de empleados actualizados...');;
      await sqlDb.createCapacitacionesEmpleado(capacitaciones);
    } else {
      throw Exception('Failed to load employees');
    }
  }


//==========ESTADISTICA=============//
  Future<List<String>?> readDataTipo(String anho) async {
    List responseRead = await sqlDb.readData(""
        "SELECT DISTINCT producto_empleado_mina.tipo_equipo_nombre FROM producto_empleado_mina WHERE producto_empleado_mina.anho = '$dropdownValue'"
        "ORDER BY producto_empleado_mina.tipo_equipo_nombre"
    );
    //   print("año ---> ${anho}");
    //   print(responseRead);
  }

//=============================================

  Future<int> readDataPrueba(String tipo, String anho) async {
    List<Map> responseRead = await sqlDb.readData(""
        "SELECT COUNT(producto_empleado_mina.tipo_equipo_nombre) FROM producto_empleado_mina WHERE producto_empleado_mina.tipo_equipo_nombre = '$tipo' AND producto_empleado_mina.anho = '$dropdownValue' "
        " GROUP BY producto_empleado_mina.id "
    );

    return responseRead.length;
  }


  Future<int> readDataEstado(String estado, String anho) async {
    List<Map> responseRead = await sqlDb.readData(""
        "SELECT COUNT(producto_empleado_mina.id_empleado) FROM producto_empleado_mina WHERE producto_empleado_mina.estado_subido = '$estado' AND producto_empleado_mina.anho = '$dropdownValue' "
        " GROUP BY producto_empleado_mina.estado_subido, producto_empleado_mina.id_empleado "
    );

    return responseRead.length;
  }


  Future <List<void>> RequestDataIncMensualPrueba(String sede) async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_grp_Estad_Incidente_Mensual?fb_uea_pe_id=1&anho=2020';
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


  Future <List<void>> RequestAYCnivel(String sede) async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_grp_ayc_nivel_riesgo?fb_uea_pe_id=1&Anno=2020';
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




  //=====SEVERIDAD
  Future <List<void>> RequestDataIndSeveridad(String sede) async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_ws_ind_severidad?fb_uea_pe_id=1&anno=2020';
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
    (datos.map((e) => indice_severidad_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createIndiceSeveridad(emp);
    }).toList();
    return result;
  }

  //===FRECUENCIA
  Future <List<void>> RequestDataIndFrecuencia(String sede) async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_ws_ind_frecuencia?fb_uea_pe_id=1&anno=2020';
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
    (datos.map((e) => indice_frecuencia_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createIndiceFrecuencia(emp);
    }).toList();
    return result;
  }



  Future <List<void>> RequestPlanAccion(String anho) async {
    final user = await authController.getUserFromStorage();
    //${widget.sede}
    var url = '${user!.urlApp}/ws/null/pr_ws_estado_plan?sede=GOLDEN&anno=$anho';
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
    (datos.map((e) => plan_accion_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createPlanAccion(emp);
    }).toList();
    return result;
  }


  Future <List<void>> RequestDataIndFrecuenciaMTI(String anho) async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_subtipo_incidente_mensual_MTI_v2?uea=1&mes=12&anho=$anho&g_rol_empresa_id=0';
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
    (datos.map((e) => frecuencia_mti_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createIndiceFrecuenciaMTI(emp);
    }).toList();
    return result;
  }

  //======CAPACITACIÓN

  Future <List<void>> RequestRolExpositorCapacitacion() async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_cap_Consulta_Roles?fb_uea_pe_id=1';
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
    (datos.map((e) => RolExpoModel.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createRolExpositor(emp);
    }).toList();
    return result;
  }
  Future <List<void>> RequestModalidadCapacitacion() async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_cap_Consulta_Modalidad?fb_uea_pe_id=1';
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
    (datos.map((e) => ModalidadModel.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createModalidad(emp);
    }).toList();
    return result;
  }

  Future <List<void>> RequestEstadoCursoCapacitacion() async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_cap_Consulta_Estado_Curso?fb_uea_pe_id=1';
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
    (datos.map((e) => EstadoCursoModel.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createEstadoCurso(emp);
    }).toList();
    return result;
  }

}




