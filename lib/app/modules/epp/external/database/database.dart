import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/capacitacion_empleado.dart';
import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/capacitacion_empleado_model.dart';
import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/enfermedades_empleado_model.dart';
import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/examen_medico_empleado_model.dart';
import 'package:safe2biz/app/modules/capacitacion/domain/entities/estado_curso.dart';
import 'package:safe2biz/app/modules/capacitacion/domain/entities/estado_curso_model.dart';
import 'package:safe2biz/app/modules/capacitacion/domain/entities/modalidad_model.dart';
import 'package:safe2biz/app/modules/capacitacion/domain/entities/rol_expo_model.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/empleado_model.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/incidente_subtipo.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/incidente_subtipo_model.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/listaEntregaEpp_model.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/pendientes_aprobar_gerencia_model.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/producto_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/ayc_nivel_riesgo_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/inc_mensuales_tipo_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_frecuencia_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/horas_trabajadas_mes_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/incidentes_seguridad_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/severidad_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/plan_accion_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/frecuencia_lti_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/frecuencia_mti_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/frecuencia_fai_model.dart';
import 'dart:developer' as dev;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {

  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    }
    else {
      return _db;
    }
  }

  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, "codigos.db");
    Database mydb = await openDatabase(path, onCreate: onCreate, version: 4, onUpgrade: _onUpgrade);
    return mydb;
  }


  _onUpgrade(Database db, int oldversion, int newversion){

    print("onUpgrade =========");
  }

  /// Consulta parametrizada (SEGURA). Usa `?` y pasa los args en orden.
  Future<List<Map<String, Object?>>?> readDataRaw(String sql, [List<Object?> args = const []]) async {
    final d = await db;
    dev.log('📥 SQL: $sql | args=$args', name: 'SqlDb');
    try {
      final res = await d?.rawQuery(sql, args);
      dev.log('📤 Filas: ${res?.length}', name: 'SqlDb');
      return res;
    } catch (e, st) {
      dev.log('💥 SQLite error en readDataRaw: $e', stackTrace: st, name: 'SqlDb');
      rethrow; // deja pasar el error real de SQLite
    }
  }

  // (opcional) utilidades para diagnóstico
  Future<void> debugListTables() async {
    final d = await db;
    final t = await d?.rawQuery("SELECT name FROM sqlite_master WHERE type='table' ORDER BY 1");
    dev.log('📚 Tablas: $t', name: 'SqlDb');
  }

  Future<void> debugCountProductoMina() async {
    final d = await db;
    final c = await d?.rawQuery("SELECT COUNT(*) as c FROM productoMina");
    dev.log('🔢 productoMina rows: ${c!.isNotEmpty ? c?.first["c"] : "?"}', name: 'SqlDb');
  }


  onCreate(Database db, int version) async {



    /*EMPLEADO JSON ---- SQLite*/

    await db.execute('''
    CREATE TABLE "empleadoMina"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "fb_empleado_id" INTEGER NOT NULL,
    "fb_uea_pe_id" INTEGER NOT NULL,
    "nombreCompleto" TEXT,
    "numero_documento" TEXT,
    "fb_cargo_id" INTEGER,
    "cargo_codigo"  TEXT,
    "cargo_nombre" TEXT,
    "gerencia_nombre" TEXT,
    "fb_area_id" INTEGER,
    "area_codigo" TEXT,
    "area_nombre" TEXT,
    "puesto_trabajo_codigo" TEXT,
    "puesto_trabajo_nombre" TEXT,
    "fb_puesto_trabajo_id" INTEGER,
    "empresa" TEXT,
    "nombre_rol" TEXT,
    "codigo_rol" TEXT,
    "epp_rol_epp_id" INTEGER,
    "fb_empresa_especializada" TEXT,
    "foto" TEXT
        
    )
    ''');


    await db.execute('''
       CREATE TABLE "productoMina"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    
    "epp_producto_id" INTEGER NOT NULL,
    "epp_equipo_id" INTEGER NOT NULL,
    "fb_empleado_id" INTEGER,
    "equipo_nombre" TEXT,
    "equipo_descripcion" TEXT,
    "tipo_equipo_nombre" TEXT,
    "codigo" TEXT,
    "nombre_proveedor" TEXT,
    "marca" TEXT,
    "modelo" TEXT,
    "foto_prod" TEXT,
    "observacion" TEXT,
    "tipo_equipo_codigo" TEXT,
    "equipo_codigo" TEXT,
    "costo" REAL,
    "tiempo_recambio" INTEGER,
    "tipo_equipo_id" INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE "producto_empleado_mina"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_empleado" INTEGER NOT NULL,
    "id_producto" INTEGER NOT NULL,
     
    "cantidad" INTEGER NOT NULL,
    "estado_subido" TEXT NOT NULL,
    "fecha_entrega" TEXT,
    "fecha_vigencia" TEXT,
    "hora_entrega" TEXT,
    "foto_evidencia" TEXT,
    "tipo_equipo_nombre" TEXT,
    "anho" TEXT,
    "motivo" TEXT,
      
    FOREIGN KEY (id_empleado) REFERENCES empleadoMina (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    
    FOREIGN KEY (id_producto) REFERENCES productoMina (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
    

    
    
    )
    ''');


    //=========ENTREGA EPP
    await db.execute('''
       CREATE TABLE "EntregaEpp"(
    "epp_entrega_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_emp" INTEGER,
    "fb_empleado_id" INTEGER NOT NULL,
    "hora_entrega" TEXT,
    "dni" TEXT,
    "nombreCompleto" TEXT,
    "fb_area_id" TEXT,
   
    "identify" INTEGER,
    "area_codigo" TEXT,
    "area_nombre" TEXT,
    "fb_cargo_id" INTEGER,
    "cargo_codigo" TEXT,
    "cargo_nombre" TEXT,
    "fb_puesto_trabajo_id" INTEGER,
    "puesto_trabajo_codigo" TEXT,
    "puesto_trabajo_nombre" TEXT,
    "epp_rol_epp_id" INTEGER,
    "nombre_rol" TEXT,
    "codigo_rol" TEXT,
    "fb_uea_pe_id" INTEGER,
    "epp_ficha_entrega_id" INTEGER,
    "fecha_entrega" TEXT,
    "ficha_entrega_codigo" TEXT,
    "foto_evidencia" BLOB,

    "estado" INTEGER,
    "created" TEXT,
    "created_by" INTEGER,
    "updated" TEXT,
    "updated_by" INTEGER,
    "owner_id" INTEGER,
    "is_deleted" INTEGER,
    "id_carga" INTEGER
    

    
    )
    ''');

    //=======ENTREGA DETALLE EPP

    await db.execute('''
       CREATE TABLE "EntregaDetalleEpp"(
    "epp_entrega_detalle_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_emp" INTEGER NOT NULL,
    
    "identify" INTEGER,
    "hora_entrega" TEXT,
    
    "epp_entrega_id" INTEGER NOT NULL,
    "epp_ficha_entrega_id" INTEGER,
    "epp_tipo_equipo_id" INTEGER,
    "tipo_equipo_nombre" TEXT,
    "epp_equipo_id" INTEGER,
    "equipo_codigo" TEXT,
    "equipo_nombre" TEXT,
    "cantidad" INTEGER,
    "epp_producto_id" INTEGER,
    "producto_codigo" TEXT,
    "producto_marca" TEXT,
    "producto_modelo" TEXT,
    "producto_costo" INTEGER,
    "epp_motivo_entrega_id" INTEGER,
    "tiempo_recambio" INTEGER,
    "flag_pertenece_rol" TEXT,
    "fecha_entrega" TEXT,
    "fecha_fin_vigencia" TEXT,
    "cantidad_dias_vigente" INTEGER,
    "flag_uso" INTEGER,
    "estado_vigencia" INTEGER, 
    "codigo_almacen_entrega" TEXT,
    "epp_almacen_temp_id" INTEGER,
    "fb_uea_pe_id" INTEGER,
    "estado" INTEGER,
   
   "tipo_equipo_codigo" TEXT,
   
    "created" TEXT,
    "created_by" INTEGER,
    "updated" TEXT,
    "updated_by" INTEGER,
    "owner_id" INTEGER,
    "is_deleted" INTEGER,
    "id_carga" INTEGER,
    "dni_empleado" TEXT,
    
    FOREIGN KEY (id_emp) REFERENCES EntregaEpp (fb_empleado_id)
    ON DELETE NO ACTION
    
    
    )
    ''');


    await db.execute('''
       CREATE TABLE "pr_inc_inf_por_aprobar_gerencia"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "gerencia" TEXT NOT NULL,
    "cantidad" INTEGER NOT NULL
    )
    ''');

    await db.execute('''
       CREATE TABLE "subtipo_incidente_anual"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nombre" TEXT NOT NULL,
    "cantidad" INTEGER NOT NULL
    )
    ''');


    await db.execute('''
     
     CREATE TABLE "EntregasEppTipo"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nombre" TEXT NOT NULL,
    "cantidad" INTEGER NOT NULL
    )
    ''');



    await db.execute('''
     
      CREATE TABLE "EntregasEppEstado"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nombre" TEXT NOT NULL,
    "cantidad" INTEGER NOT NULL
    )
    ''');

    //ESTADO BLOC fixme: corregir;
    await db.execute('''
      CREATE TABLE "ListaEntregasEpp"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "epp_entrega_id" INTEGER,
    "fb_empleado_id" INTEGER,
    "estado_bloc" INTEGER )
    ''');

    await db.execute('''
     
     CREATE TABLE "IncidentesMensualesTipo"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "TipoIncidente" TEXT,
    "ene" INTEGER,
    "feb" INTEGER,
    "mar" INTEGER,
    "abr" INTEGER,
    "may" INTEGER,
    "jun" INTEGER,
    "jul" INTEGER,
    "ago" INTEGER,
    "set" INTEGER,
    "oct" INTEGER,
    "nov" INTEGER,
    "dic" INTEGER
    )
    ''');


    await db.execute('''
      CREATE TABLE "NivelesRiesgoAyC"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nombre" TEXT,
    "ene" INTEGER,
    "feb" INTEGER,
    "mar" INTEGER,
    "abr" INTEGER,
    "may" INTEGER,
    "jun" INTEGER,
    "jul" INTEGER,
    "ago" INTEGER,
    "sep" INTEGER,
    "oct" INTEGER,
    "nov" INTEGER,
    "dic" INTEGER
    
    )
    ''');

    await db.execute(''' 
    CREATE TABLE "IndiceSeveridad"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "anho" INTEGER,
    "nombre" TEXT,
    "indicador" REAL
    )
    ''');

    await db.execute('''
      CREATE TABLE "IndiceFrecuencia"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "mes" TEXT,
    "rol" TEXT,
    "accidentes" INTEGER
    )
    ''');

    await db.execute('''
     
      CREATE TABLE "frecuenciaMTI"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "anho" INTEGER,
    "nombre" TEXT,
    "indicador" REAL

    
    )
    ''');

    await db.execute('''
     
      CREATE TABLE "frecuenciaLTI"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "anho" INTEGER,
    "nombre" TEXT,
    "indicador" REAL
    )
    ''');

    await db.execute('''
     
      CREATE TABLE "frecuenciaFAI"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "anho" INTEGER,
    "nombre" TEXT,
    "indicador" REAL
    )
    ''');

    await db.execute('''
     
      CREATE TABLE "PlanAccion"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nombre" TEXT,
    "ene" INTEGER,
    "feb" INTEGER,
    "mar" INTEGER,
    "abr" INTEGER,
    "may" INTEGER,
    "jun" INTEGER,
    "jul" INTEGER,
    "ago" INTEGER,
    "sep" INTEGER,
    "oct" INTEGER,
    "nov" INTEGER,
    "dic" INTEGER
    
    )
    ''');


    await db.execute('''
     
      CREATE TABLE "IncidentesSeguridad"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "Accidente" TEXT,
    "Enero" INTEGER,
    "Febrero" INTEGER,
    "Marzo" INTEGER,
    "Abril" INTEGER,
    "Mayo" INTEGER,
    "Junio" INTEGER,
    "Julio" INTEGER,
    "Agosto" INTEGER,
    "Septiembre" INTEGER,
    "Octubre" INTEGER,
    "Noviembre" INTEGER,
    "Diciembre" INTEGER
    
    )
    ''');



    await db.execute('''
    CREATE TABLE "HorasTrabajadas"(
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "rol" TEXT,
        "Enero" INTEGER,
        "Febrero" INTEGER,
        "Marzo" INTEGER,
        "Abril" INTEGER,
        "Mayo" INTEGER,
        "Junio" INTEGER,
        "Julio" INTEGER,
        "Agosto" INTEGER,
        "Setiembre" INTEGER,
        "Octubre" INTEGER,
        "Noviembre" INTEGER,
        "Diciembre" INTEGER
    )
    ''');

    //=======CAPACITACIÓN
    await db.execute('''
    CREATE TABLE "cap_curso"(
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "codigo" TEXT,
        "nombre" INTEGER,
        "institucion" INTEGER,
        "expositor" INTEGER,
        "fecha_inicio" INTEGER,
        "fecha_final" INTEGER,
        "puntaje_curso" INTEGER,
        "puntaje_aprobatorio" INTEGER,
        "costo" INTEGER,
        "horas" INTEGER,
        "cap_curso_estado_id" INTEGER,
        "observacion_anulado" INTEGER,
        "pre_registro_participante" INTEGER,
        "fb_uea_pe_id" INTEGER,
        "cap_curso_modalidad_id" INTEGER,
        "user_id" INTEGER,
        "estado" INTEGER
    )
    ''');

    await db.execute('''
     CREATE TABLE "capacitacion_photo"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_curso" INTEGER,
    "flag_photo" INTEGER
    )
    ''');


    await db.execute('''
     CREATE TABLE "RolExpositorCapacitacion"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "cap_rol_capacitacion_id" INTEGER,
    "rol" TEXT
    )
    ''');


    await db.execute('''
     CREATE TABLE "ModalidadCapacitacion"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "cap_curso_modalidad_id" INTEGER,
    "nombre" TEXT
    )
    ''');

    await db.execute('''
     CREATE TABLE "EstadoCursoCapacitacion"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "cap_curso_estado_id" INTEGER,
    "nombre" TEXT
    )
    ''');

    await db.execute('''
     CREATE TABLE "EstadoBloc"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "estado_bloc" INTEGER
    )
    ''');


    await db.execute('''
     CREATE TABLE "asistencia_check"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "id_curso" INTEGER,
    "fb_empleado_id" INTEGER,
    "flag_asistio" INTEGER
    )
    ''');


    await db.execute('''
     CREATE TABLE "examen_medico"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "fb_empleado_id" INTEGER,
    "examen_medico" TEXT,
    "flag_aptitud" TEXT
    )
    ''');

    await db.execute('''
     CREATE TABLE "enfermedades_ocupacionales"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "fb_empleado_id" INTEGER,
    "enfermedad" TEXT
    )
    ''');

    await db.execute('''
     CREATE TABLE "capacitacion"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "fb_empleado_id" INTEGER,
    "capacitacion" TEXT,
    "flag_aptitud" TEXT
    )
    ''');

    print("onCreate==========");

  }


//
  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }
  readDataString(String sql) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);
    return response;
  }
  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }
  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }
  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
  mydeleteDatabase() async{
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'codigos.db');
    await deleteDatabase(path);
  }
  mydeleteDatabaseProd() async{
    String databasepath = await getDatabasesPath();
    String path2 = join(databasepath, 'productos.db');
    await deleteDatabase(path2);
  }
  getProductPrueba(String cod) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query('producto', where: 'codigo = ?', whereArgs: [cod], );
    return response;
  }
  getProduct(String cod) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query('productoMina', where: 'codigo = ?', whereArgs: [cod], );
    return response;
  }
  getRol(String nom) async{

    Database? mydb = await db;
    List<Map> response = await mydb!.query('RolMina', where: 'codigo = ?', whereArgs: [nom], );
    return response;

  }

  //Get all data from empleadoMinera
  Future<List<EmpleadoModel>> getAllEmployees() async {
    Database? mydb = await db;
    final res = await mydb!.rawQuery("SELECT * FROM empleadoMina");
    List<EmpleadoModel> list =
    res.isNotEmpty ? res.map((c) => EmpleadoModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<void> createEmployees(List<EmpleadoModel> employees) async {
    final db = await _db;
    Batch batch = db!.batch();

    for (EmpleadoModel employee in employees) {
      batch.insert('empleadoMina', employee.toJson());
    }

    await batch.commit(noResult: true);
  }


  Future<void> createExamenesMedicos(List<ExamenMedicoEmpleadoModel> employees) async {
    final db = await _db;
    Batch batch = db!.batch();

    for (ExamenMedicoEmpleadoModel employee in employees) {
      batch.insert('examen_medico', employee.toJson());
    }

    await batch.commit(noResult: true);
  }

  Future<void> createEnfermedadesEmpleado(List<EnfermedadesEmpleadoModel> employees) async {
    final db = await _db;
    Batch batch = db!.batch();

    for (EnfermedadesEmpleadoModel employee in employees) {
      batch.insert('enfermedades_ocupacionales', employee.toJson());
    }

    await batch.commit(noResult: true);
  }


  Future<void> createCapacitacionesEmpleado(List<CapacitacionEmpleadoModel> employees) async {
    final db = await _db;
    Batch batch = db!.batch();

    for (CapacitacionEmpleadoModel employee in employees) {
      batch.insert('capacitacion', employee.toJson());
    }

    await batch.commit(noResult: true);
  }


  //Actualizacion
  updateEmployee(EmpleadoModel newEmployee) async {
    final db = await _db;
    final res = await db!.update('empleadoMina', newEmployee.toJson());
    return res;
  }


  Future<void> createProducts(List<ProductoModel> products) async {
    final db = await _db;
    Batch batch = db!.batch();

    for (ProductoModel product in products) {
      batch.insert('productoMina', product.toJson());
    }

    await batch.commit(noResult: true);
  }



  createIncidentesMesTipo(inc_mensuales_tipo_model newProduct) async {
    await deleteAllIncidentesTipomes();
    final db = await _db;
    final res = await db?.insert('IncidentesMensualesTipo', newProduct.toJson());
    return res;
  }

  createAycNivelRiesgo(ayc_nivel_riesgo_model newProduct) async {
    await deleteAllNivelesRiesgo();
    final db = await _db;
    final res = await db?.insert('NivelesRiesgoAyC', newProduct.toJson());
    return res;
  }


  //Plan de Accion

  createPlanAccion(plan_accion_model newProduct) async {
    await deleteAllPlanAccion();
    final db = await _db;
    final res = await db?.insert('PlanAccion', newProduct.toJson());
    return res;
  }


  //INCIDENTES DE SEGURIDAD
  createIncidentesSeguridad(incidentes_seguridad_model newProduct) async {
    await deleteAllIncidentesSeguridad();
    final db = await _db;
    final res = await db?.insert('IncidentesSeguridad', newProduct.toJson());
    return res;
  }


  //HORAS TRABAJADAS SEGUN ROL
  createHorasTrabajadas(horas_trabajadas_mes_model newProduct) async {
    await deleteAllHorasTrabajadas();
    final db = await _db;
    final res = await db?.insert('HorasTrabajadas', newProduct.toJson());
    return res;
  }



  //==SEVERIDAD
  createIndiceSeveridad(severidad_model newProduct) async {
    await deleteAllIndiceSeveridad();
    final db = await _db;
    final res = await db?.insert('IndiceSeveridad', newProduct.toJson());
    return res;
  }

  //==FRECUENCIA

  createIndiceFrecuencia(indice_frecuencia_model newProduct) async {
    await deleteAllIndiceFrecuencia();
    final db = await _db;
    final res = await db?.insert('IndiceFrecuencia', newProduct.toJson());
    return res;
  }

  //FRECUENCIA MTI

  createIndiceFrecuenciaMTI(frecuencia_mti_model frecuencia_mti) async {
    await deleteAllIndiceFrecuenciaMTI();
    final db = await _db;
    final res = await db?.insert('frecuenciaMTI', frecuencia_mti.toJson());
    return res;
  }

  //FRECUENCIA LTI

  createIndiceFrecuenciaLTI(frecuencia_lti_model frecuencia_mti) async {
    await deleteAllIndiceFrecuenciaLTI();
    final db = await _db;
    final res = await db?.insert('frecuenciaLTI', frecuencia_mti.toJson());
    return res;
  }

  //Frecuencia FAI

  createIndiceFrecuenciaFAI(frecuencia_fai_model frecuencia_mti) async {
    await deleteAllIndiceFrecuenciaFAI();
    final db = await _db;
    final res = await db?.insert('frecuenciaFAI', frecuencia_mti.toJson());
    return res;
  }

//====CAPACITACION

  createRolExpositor(RolExpoModel newProduct) async {
    await deleteAllRolExpositor();
    final db = await _db;
    final res = await db?.insert('RolExpositorCapacitacion', newProduct.toJson());
    return res;
  }

  createModalidad(ModalidadModel newProduct) async {
    await deleteAllModalidad();
    final db = await _db;
    final res = await db?.insert('ModalidadCapacitacion', newProduct.toJson());
    return res;
  }


  createEstadoCurso(EstadoCursoModel newProduct) async {
    await deleteAllEstadoCurso();
    final db = await _db;
    final res = await db?.insert('EstadoCursoCapacitacion', newProduct.toJson());
    return res;
  }

  createAsistenciaCheck(EstadoCursoModel newProduct) async {
    await deleteAllAsistenciaCheck();
    final db = await _db;
    final res = await db?.insert('asistencia_check', newProduct.toJson());
    return res;
  }



  createAyc(ayc_nivel_riesgo_model newProduct) async {
    await deleteAllNivelesRiesgo();
    final db = await _db;
    final res = await db?.insert('NivelesRiesgoAyC', newProduct.toJson());
    return res;
  }

  createPendientesAprobarGerencia(PendienteAprobarGerenciaModel newPendienteGerencia) async {
    await deleteAllPendientesAprobarGerencia();
    final db = await _db;
    final res = await db!.insert('pr_inc_inf_por_aprobar_gerencia', newPendienteGerencia.toJson());
    return res;
  }

  createIncidenteSubtipo(IncidenteSubtipoModel newIncidenteSubtipo) async {
    await deleteAllInicidenteSubtipo();
    final db = await _db;
    final res = await db!.insert('subtipo_incidente_anual', newIncidenteSubtipo.toJson());
    return res;
  }


  createListaEntregaEpp(ListaEntregaEppModel newListaEntregaEpp) async {
    await deleteAllListaEntregasEpp();
    final db = await _db;
    final res = await db!.insert('ListaEntregasEpp', newListaEntregaEpp.toJson());
    return res;
  }

  Future<int?> deleteAllEmployees() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM empleadoMina');
    return res;
  }

  Future<int?> deleteAllExamenesMedicos() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM examen_medico');
    return res;
  }

  Future<int?> deleteAllEnfermedadesEmpleado() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM enfermedades_ocupacionales');
    return res;
  }
  Future<int?> deleteAllCapacitacionesEmpleado() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM capacitacion');
    return res;
  }

  Future<int> deleteAllProducts() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM productoMina');
    return res;
  }

  Future<int> deleteAllEntregaEpp() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM EntregaEpp');
    return res;
  }


  Future<int?> deleteAllIncidentesTipomes() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM IncidentesMensualesTipo');
    return res;
  }


  Future<int?> deleteAllNivelesRiesgo() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM NivelesRiesgoAyC');
    return res;
  }

  Future<int> deleteAllEntregaDetalleEpp() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM EntregaDetalleEpp');
    return res;
  }

  Future<int> deleteAllPendientesAprobarGerencia() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM pr_inc_inf_por_aprobar_gerencia');
    return res;
  }


  Future<int> deleteAllInicidenteSubtipo() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM subtipo_incidente_anual');
    return res;
  }

  Future<int> deleteAllListaEntregasEpp() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM ListaEntregasEpp');
    return res;
  }

  //Incidentes Seguridad

  Future<int> deleteAllIncidentesSeguridad() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM IncidentesSeguridad');
    return res;
  }


  //Horas Trabajadas
  Future<int> deleteAllHorasTrabajadas() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM HorasTrabajadas');
    return res;
  }


  //Severidad
  Future<int?> deleteAllIndiceSeveridad() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM IndiceSeveridad');
    return res;
  }

  //Frecuencia

  Future<int?> deleteAllIndiceFrecuencia() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM IndiceFrecuencia');
    return res;
  }

  //Frecuencia MTI
  Future<int?> deleteAllIndiceFrecuenciaMTI() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM frecuenciaMTI');
    return res;
  }

  //Frecuencia LTI
  Future<int?> deleteAllIndiceFrecuenciaLTI() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM frecuenciaLTI');
    return res;
  }

  //Frecuencia FAI
  Future<int?> deleteAllIndiceFrecuenciaFAI() async {
    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM frecuenciaFAI');
    return res;
  }

  Future<int?> deleteAllPlanAccion() async {

    final db = await _db;
    final res = await db?.rawDelete('DELETE FROM PlanAccion');
    return res;

  }

  //Estado bloc
  Future<int> deleteAllEstadoBloc() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM EstadoBloc');
    return res;
  }

  //capacitacion_photo
  Future<int> deleteAllCapacitacionPhoto() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM capacitacion_photo');
    return res;
  }

  //CAPACITACION

  Future<int> deleteAllRolExpositor() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM RolExpositorCapacitacion');
    return res;
  }

  Future<int> deleteAllModalidad() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM ModalidadCapacitacion');
    return res;
  }
  Future<int> deleteAllEstadoCurso() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM EstadoCursoCapacitacion');
    return res;
  }

  Future<int> deleteAllAsistenciaCheck() async {
    final db = await _db;
    final res = await db!.rawDelete('DELETE FROM asistencia_check');
    return res;
  }




}
