// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';
import 'package:safe2biz/app/modules/planes_accion/data/models/plan_accion_model.dart';


class LocalSqlite {
  LocalSqlite._();
  factory LocalSqlite() => _instance;
  static final LocalSqlite _instance = LocalSqlite._();
  Future<List<Map<String, dynamic>>> readData(String sql) async {
    final db = await database;
    return db.rawQuery(sql);
  }

  Future<List<int>> getAllSedesIds() async {
    // aquí TABLE_ACCESOS es visible porque está en la misma clase
    final rows = await readData('SELECT fb_uea_pe_id FROM $TABLE_ACCESOS;');
    return rows
        .map((r) => r['fb_uea_pe_id'] as int)
        .toSet()   // opcional: quita duplicados
        .toList();
  }
  Future<void> insertBatch(
      List<Map<String, dynamic>> items, {
        required String tableName,
      }) async {
    final db = await database;
    final batch = db.batch();
    for (final item in items) {
      batch.insert(
        tableName,
        item,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }




  static const String TABLE_USER = 'user';
  // static const String TABLE_COMPANY = 'compay';
  // static const String TABLE_T_PARAMETRO = 't_parametro';
  static const String TABLE_SETTINGS = 'settings';
  static const String TABLE_FB_UEA_PE = 'FB_UEA_PE';
  //--------------------------------------------
  //----------------- AYC ----------------------
  //--------------------------------------------
  static const String TABLE_AYC_REGISTRO = 'AYC_REGISTRO';
  static const String TABLE_G_TIPO_CAUSA = 'G_TIPO_CAUSA';
  static const String TABLE_G_NIVEL_RIESGO = 'G_NIVEL_RIESGO';
  static const String TABLE_ORIGEN_AYC = 'ORIGEN_AYC';
  static const String TABLE_TIPO_RIESGO_AYC = 'TIPO_RIESGO_AYC';
  static const String TABLE_AYC_EVIDENCIA = 'AYC_EVIDENCIA';
  static const String TABLE_AYC_REPORTANTE = 'AYC_REPORTANTE';
  //--------------------------------------------
  //----------------- INC ----------------------
  //--------------------------------------------
  static const String TABLE_INC_REGISTRO = 'INC_REGISTRO';
  static const String TABLE_INC_TIPO_REPORTE = 'INC_TIPO_REPORTE';
  static const String TABLE_INC_SUB_TIPO_REPORTE = 'INC_SUB_TIPO_REPORTE';
  static const String TABLE_INC_DETALLE_PERDIDA = 'INC_DETALLE_PERDIDA';
  static const String TABLE_INC_POTENCIAL_PERDIDA = 'INC_POTENCIAL_PERDIDA';

  //--------------------------------------------
  //----------------- SAC ----------------------
  //--------------------------------------------
  static const String TABLE_SAC_ACCION_CORRECTIVA = 'SAC_ACCION_CORRECTIVA';
  static const String TABLE_SAC_ACCION_CORRECTIVA_GRISLI = 'SAC_ACCION_CORRECTIVA_GRISLI';


  //--------------------------------------------
  //----------------- OPS ----------------------
  //--------------------------------------------

  static const String TABLE_OPS_REGISTRO_GENERALES = 'OPS_REGISTRO_GENERALES';
  static const String TABLE_OPS_REGISTRO_RESULTADO = 'OPS_REGISTRO_RESULTADO';
  static const String TABLE_OPS_LISTA_VERIFICACION = 'OPS_LISTA_VERIFICACION';

  static const String TABLE_OPS_LISTA_VERIF_CATEGORIA =
      'OPS_LISTA_VERIF_CATEGORIA';
  static const String TABLE_OPS_LISTA_VERIF_SECCION = 'OPS_LISTA_VERIF_SECCION';
  static const String TABLE_OPS_LISTA_VERIF_PREGUNTA =
      'OPS_LISTA_VERIF_PREGUNTA';
  static const String TABLE_OPS_LISTA_VERIF_RESULTADO =
      'OPS_LISTA_VERIF_RESULTADO';
  static const String TABLE_OPS_LISTA_TIPO_RESULTADO =
      'OPS_LISTA_TIPO_RESULTADO';
  static const String TABLE_OPS_TURNOS = 'OPS_TURNOS';
  static const String TABLE_ACCESOS = 'ACCESOS';

  //------------------------------------------------
  //--------------- DATA PARA SINCRONIZAR ----------
  //------------------------------------------------
  static const String TABLE_FB_GERENCIA = 'FB_GERENCIA';
  static const String TABLE_FB_AREA = 'FB_AREA';
  static const String TABLE_FB_EMPRESA_ESPECIALIZADA =
      'FB_EMPRESA_ESPECIALIZADA';


  // ---- OTROS

  static const String TABLE_RESPONSABLE= 'LISTA_RESPONSABLE';

  static const String TABLE_OPS_SUB_TIPO= 'OPS_SUB_TIPO';

  static const String TABLE_OPS_TIPO= 'OPS_TIPO_INSPECCION';
  static const String TABLE_OPS_ALCANCE= 'OPS_ALCANCE_INSPECCION';




  Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<String> getUeaBaseId(String idSede) async {
    final db = await database;
    final results = await db.query(
      TABLE_FB_UEA_PE,
      columns: ['fb_uea_base_id'],
      where: 'fb_uea_pe_id = ?',
      whereArgs: [idSede],
      limit: 1,
    );
    if (results.isNotEmpty && results.first['fb_uea_base_id'] != null) {
      return results.first['fb_uea_base_id'].toString();
    }
    return '';
  }

  Future<Set<String>> getGerenciaIdsForSede(String idSede) async {
    final db = await database;
    final results = await db.query(
      TABLE_FB_GERENCIA,
      columns: ['fb_gerencia_id'],
      where: 'fb_uea_pe_id = ?',
      whereArgs: [idSede],
    );
    return results.map((r) => r['fb_gerencia_id'].toString()).toSet();
  }

  Future<List<Map<String, dynamic>>> getTipoCausa() async {
    final db = await database;
    final results = await db.query(TABLE_G_TIPO_CAUSA);
    return results;
  }


  Future<List<Map<String, dynamic>>> getNivelRiesgo() async {
    final db = await database;
    final results = await db.query(TABLE_G_NIVEL_RIESGO);
    return results;
  }

  Future<List<Map<String, dynamic>>> getAreas() async {
    final db = await database;
    final results = await db.query(TABLE_FB_AREA);
    return results;
  }



  Future<List<Map<String, dynamic>>> getGerencia() async {
    final db = await database;
    final results = await db.query(TABLE_FB_GERENCIA);
    return results;
  }


  Future<List<Map<String, dynamic>>> getDesviaciones() async {
    final db = await database;
    final results = await db.query(TABLE_G_TIPO_CAUSA);
    return results;
  }
  Future<List<Map<String, dynamic>>> getArea() async {
    final db = await database;
    final results = await db.query(TABLE_FB_AREA);
    return results;
  }

  Future<List<Map<String, dynamic>>> getEmpresa() async {
    final db = await database;
    final results = await db.query(TABLE_FB_EMPRESA_ESPECIALIZADA);
    return results;
  }


  Future<int> createListaSAC(List<PlanesAccionModel> listaAcciones) async {
    await deleteAllSAC();
    final db = await _db;
    int count = 0;
    // Insertar cada acción correctiva en la tabla utilizando INSERT OR REPLACE
    for (final accion in listaAcciones) {
      count += await db!.insert(
        '$TABLE_SAC_ACCION_CORRECTIVA',
        accion.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return count;
  }


  Future<int?> deleteAllSAC() async {
  final db = await _db;
  final res = await db?.rawDelete('DELETE FROM $TABLE_SAC_ACCION_CORRECTIVA');
  return res;
}




  // ===========================================================================
  //  AUTO-REPARACION DE ESQUEMA (idempotente, NO destructiva)
  // ---------------------------------------------------------------------------
  //  Se ejecuta en cada apertura de la BD (onOpen). Como todo usa
  //  "IF NOT EXISTS" / verificacion previa, se puede correr siempre sin borrar
  //  datos: solo crea las tablas/columnas/indices que falten cuando el usuario
  //  instala una version nueva del APK sobre una BD antigua. Esto elimina la
  //  necesidad de pedirle que borre la cache/datos de la app.
  //
  //  IMPORTANTE: al agregar una tabla o columna nueva al esquema, agregala
  //  tambien aqui (en _ensureTables / _ensureColumns) para que los usuarios que
  //  ACTUALIZAN la reciban automaticamente (onCreate solo corre en instalaciones
  //  nuevas, no en actualizaciones).
  // ===========================================================================
  Future<void> _ensureSchema(DatabaseExecutor db) async {
    await _ensureTables(db);
    await _ensureColumns(db);
    await _ensureIndexes(db);
  }

  Future<void> _addColumnIfMissing(
    DatabaseExecutor db,
    String table,
    String column,
    String ddl,
  ) async {
    try {
      final info = await db.rawQuery('PRAGMA table_info($table)');
      final exists = info.any(
        (row) => '${row['name']}'.toLowerCase() == column.toLowerCase(),
      );
      if (!exists) {
        await db.execute('ALTER TABLE $table ADD COLUMN $ddl');
      }
    } catch (e) {
      print('### [_addColumnIfMissing] $table.$column ERROR: $e');
    }
  }

  Future<void> _ensureColumns(DatabaseExecutor db) async {
    // Columnas agregadas por migraciones a lo largo del tiempo. Se re-aseguran
    // aqui para usuarios que actualizan y que por alguna razon no las tengan.
    await _addColumnIfMissing(
        db, TABLE_AYC_REGISTRO, 'interior_mina', 'interior_mina TEXT(1)');
    await _addColumnIfMissing(db, TABLE_AYC_REGISTRO, 'interior_mina_nivel',
        'interior_mina_nivel TEXT(100)');
    await _addColumnIfMissing(db, TABLE_AYC_REGISTRO, 'interior_mina_labor',
        'interior_mina_labor TEXT(100)');
    await _addColumnIfMissing(db, TABLE_AYC_REGISTRO,
        'interior_mina_numero_labor', 'interior_mina_numero_labor TEXT(100)');
    await _addColumnIfMissing(
        db, TABLE_FB_UEA_PE, 'fb_uea_base_id', 'fb_uea_base_id TEXT(15)');
    await _addColumnIfMissing(
        db, TABLE_FB_AREA, 'fb_uea_base_id', 'fb_uea_base_id TEXT(15)');
    await _addColumnIfMissing(db, TABLE_FB_AREA, 'flag_mina_interior',
        'flag_mina_interior INTEGER DEFAULT 0');
  }

  Future<void> _ensureIndexes(DatabaseExecutor db) async {
    Future<void> tryIdx(String sql) async {
      try {
        await db.execute(sql);
      } catch (e) {
        // Si hay datos duplicados heredados, un indice UNIQUE puede fallar; no
        // es fatal (la sincronizacion repuebla limpio). Solo se registra.
        print('### [_ensureIndexes] omitido: $e');
      }
    }

    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_gerencia_id_norm ON $TABLE_FB_GERENCIA (TRIM(UPPER(fb_gerencia_id)));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_area_id_uea_norm ON $TABLE_FB_AREA (TRIM(UPPER(fb_area_id)), TRIM(UPPER(COALESCE(fb_uea_base_id,''))));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_empresa_especializada_id_norm ON $TABLE_FB_EMPRESA_ESPECIALIZADA (TRIM(UPPER(fb_empresa_especializada_id)));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_tipo_reporte_id_norm ON $TABLE_INC_TIPO_REPORTE (TRIM(UPPER(inc_tipo_reporte_id)));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_sub_tipo_reporte_id_norm ON $TABLE_INC_SUB_TIPO_REPORTE (TRIM(UPPER(inc_sub_tipo_reporte_id)));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_detalle_perdida_id_norm ON $TABLE_INC_DETALLE_PERDIDA (TRIM(UPPER(inc_segun_tipo_id)));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_potencial_perdida_id_norm ON $TABLE_INC_POTENCIAL_PERDIDA (TRIM(UPPER(inc_potencial_perdida_id)));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_ops_tipo_inspeccion ON $TABLE_OPS_TIPO (ops_tipo_inspeccion_id);");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_ops_alcance_inspeccion ON $TABLE_OPS_ALCANCE (ops_alcance_inspeccion_id);");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_empleado ON $TABLE_RESPONSABLE (fb_empleado_id);");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_tipo_resultado_codigo ON $TABLE_OPS_LISTA_VERIF_RESULTADO (codigo);");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_verificacion_codigo ON $TABLE_OPS_LISTA_VERIFICACION (codigo);");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_categoria_nombre ON $TABLE_OPS_LISTA_VERIF_CATEGORIA (nombre);");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_seccion_verificacion_orden ON $TABLE_OPS_LISTA_VERIF_SECCION (ops_lista_verificacion_id, orden);");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_pregunta_seccion_orden ON $TABLE_OPS_LISTA_VERIF_PREGUNTA (ops_lista_verif_seccion_id, orden);");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_ops_sub_tipo_nombre_norm ON $TABLE_OPS_SUB_TIPO (TRIM(UPPER(nombre)));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_g_tipo_causa_id_norm ON $TABLE_G_TIPO_CAUSA (TRIM(UPPER(g_tipo_causa_id)));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_g_nivel_riesgo_id_norm ON $TABLE_G_NIVEL_RIESGO (TRIM(UPPER(g_nivel_riesgo_id)));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_tipo_riesgo_ayc_id_norm ON $TABLE_TIPO_RIESGO_AYC (TRIM(UPPER(inc_tipo_reporte_id)));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_ayc_evidencia_norm ON $TABLE_AYC_EVIDENCIA (TRIM(UPPER(nombre)), TRIM(UPPER(ruta)), TRIM(ayc_registro_id));");
    await tryIdx(
        "CREATE UNIQUE INDEX IF NOT EXISTS uq_ayc_reportante_emp_uea_norm ON $TABLE_AYC_REPORTANTE (TRIM(UPPER(fb_empleado_id)), TRIM(UPPER(fb_uea_pe_id)));");
  }

  Future<void> _ensureTables(DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_SETTINGS(
      ip TEXT(20),
      name_company TEXT(50),
      ARROBA_MOVIL TEXT(50)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_USER(
      id INTEGER,
      SC_USER_ID INTEGER,
      CODE TEXT(50),
      USER_LOGIN TEXT(50) NOT NULL,
      nombre_empleado TEXT(50) NOT NULL,
      ENTERPRISE TEXT(50),
      userPassword TEXT(50),
      fb_empleado_id TEXT(15),
      URL_EXT TEXT(200),
      URL_APP TEXT(200),
      ARROBA_MOVIL TEXT(50)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_FB_UEA_PE (
      fb_uea_pe_id INTEGER,
      codigo TEXT(50),
      nombre TEXT(50),
      sc_user_id TEXT(15),
      fb_uea_base_id TEXT(15)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_ACCESOS (
      fb_uea_pe_id INTEGER,
      codigo TEXT(50),
      modulos TEXT(50)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_AYC_REGISTRO (
      ayc_registro_id INTEGER primary key,
      origen TEXT(15),
      g_tipo_causa_id TEXT(15),
      g_tipo_causa_nombre TEXT(100),
      fb_gerencia_id TEXT(15),
      fb_gerencia_nombre TEXT(100),
      fb_area_id TEXT(15),
      fb_area_nombre TEXT(100),
      descripcion TEXT(200),
      lugar TEXT(200),
      fecha TEXT(10),
      hora  TEXT(5),
      corrigio TEXT(200),
      tipo_evento_id TEXT(15),
      tipo_evento_nombre TEXT(100),
      nivel_riesgo_id TEXT(15),
      nivel_riesgo_nombre TEXT(100),
      accion_ejec TEXT(200),
      fb_empresa_especializada_id TEXT(15),
      fb_empresa_especializada_nombre TEXT(100),
      latitud TEXT(15),
      longitud TEXT(15),
      foto_pre_evento_nombre TEXT(100),
      foto_pre_evento_ruta TEXT,
      foto_evento_nombre TEXT(100),
      foto_evento_ruta TEXT,
      fb_empleado_id TEXT(15),
      fb_empleado_nombre TEXT(100),
      fb_uea_pe_id TEXT(15),
      inc_bsaf_id TEXT(15),
      tarjeta_roja TEXT(15),
      interior_mina TEXT(1),
      interior_mina_nivel TEXT(100),
      interior_mina_labor TEXT(100),
      interior_mina_numero_labor TEXT(100),
      estado TEXT(1)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_G_TIPO_CAUSA (
      g_tipo_causa_id TEXT(15),
      ayc TEXT(50),
      descripcion TEXT(200)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_G_NIVEL_RIESGO (
      g_nivel_riesgo_id TEXT(15),
      nombre TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_ORIGEN_AYC (
      code TEXT(15) primary key,
      name TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_TIPO_RIESGO_AYC (
      inc_tipo_reporte_id TEXT(15),
      nombre TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_AYC_EVIDENCIA (
      nombre TEXT(100),
      ruta TEXT(500),
      ayc_registro_id TEXT(15)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_AYC_REPORTANTE (
      fb_empleado_id TEXT(15),
      fb_uea_pe_id TEXT(15),
      nombreCompleto TEXT(100),
      numero_documento TEXT(100),
      cargo_nombre TEXT(100),
      gerencia_nombre TEXT(100),
      empresa TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_INC_REGISTRO (
      inc_incidente_id INTEGER primary key,
      fb_empleado_id TEXT(15),
      fb_uea_pe_id TEXT(15),
      inc_tipo_evento TEXT(15),
      inc_tipo_evento_nombre TEXT(100),
      inc_sub_tipo_evento TEXT(15),
      inc_sub_tipo_evento_nombre TEXT(100),
      inc_segun_tipo TEXT(15),
      inc_segun_tipo_nombre TEXT(100),
      inc_potencial_perdida TEXT(15),
      inc_potencial_perdida_nombre TEXT(100),
      fb_gerencia_id TEXT(15),
      fb_gerencia_nombre TEXT(100),
      fb_area TEXT(15),
      fb_area_nombre TEXT(100),
      fecha_evento TEXT(10),
      hora TEXT(5),
      lugar_evento TEXT(100),
      descripcion_evento TEXT(100),
      imagen_pre_evento_nombre TEXT(100),
      imagen_pre_evento_ruta TEXT,
      imagen_evento_nombre TEXT(100),
      imagen_evento_ruta TEXT,
      estado TEXT(1)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_SAC_ACCION_CORRECTIVA (
      sac_accion_correctiva_id TEXT(15),
      codigo_accion_correctiva TEXT(100),
      accion_correctiva_detalle TEXT(100),
      fecha_acordada_ejecucion TEXT(10),
      nombre_responsable_correccion TEXT(100),
      nombre_responsable_verificador TEXT(100),
      fecha_origen TEXT(10),
      origen TEXT(50),
      uea_id TEXT(15),
      fecha_ejecucion TEXT(10),
      evidencia_nombre TEXT(100),
      evidencia_ruta TEXT,
      obs_resp_corr TEXT(100),
      estado TEXT(1)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_RESPONSABLE (
      fb_empleado_id TEXT(15),
      nombre_responsable TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_SUB_TIPO (
      ops_sub_tipo_id TEXT(15),
      nombre TEXT(100),
      g_tipo_origen_id TEXT(15)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_REGISTRO_GENERALES(
      ops_registro_generales_id           INTEGER primary key,
      fb_uea_pe_id                        TEXT(15),
      codigo                              TEXT(50),
      g_tipo_origen_id                    TEXT(15),
      fecha_ops                           TEXT(15),
      hora_ops                            TEXT(15),
      turno                               TEXT(50),
      fb_area_id                          TEXT(15),
      alcance                             TEXT(100),
      criterio                            TEXT(100),
      g_rol_empresa_id                    TEXT(15),
      fb_empresa_especializada_id         TEXT(15),
      fb_empleado_id                      TEXT(15),
      ops_lista_verificacion_id           TEXT(15),
      ops_tipo_resultado_id               TEXT(15),
      latitud                             TEXT(15),
      longitud                            TEXT(15),
      fb_area_nombre                      TEXT(100),
      turno_nombre                        TEXT(100),
      fb_empresa_especializada_nombre     TEXT(100),
      fb_empleado_nombre_completo         TEXT(100),
      id_generado_syncronizacion          TEXT(15),
      ops_sub_tipo_inspeccion_id          TEXT(15),
      ops_tipo_inspeccion_id              TEXT(15),
      ops_alcance_inspeccion_id           TEXT(15),
      fb_auditor_id                       TEXT(15),
      auditor_nombre                      TEXT(100),
      fb_verificador_id                   TEXT(15),
      verificador_nombre                  TEXT(100),
      ops_involucrados                    TEXT(200),
      ops_inspectores                     TEXT(200),
      ops_contratista_id                  TEXT(15),
      contratista_nombre                  TEXT(200),
      tipo_servicio_nombre                TEXT(200),
      equipo_auditor                      TEXT(200),
      personal_auditado                   TEXT(200),
      ops_sub_tipo_inspeccion_text        TEXT(100),
      ops_tipo_inspeccion_text            TEXT(100),
      ops_alcance_inspeccion_text         TEXT(100),
      estado                              TEXT(1),
      flag                                TEXT(1)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_REGISTRO_RESULTADO(
      ops_registro_resultado_id       INTEGER primary key,
      ops_registro_generales_id       TEXT(15),
      ops_lista_verif_pregunta_id     TEXT(15),
      ops_lista_verif_seccion_id      TEXT(15),
      ops_lista_verif_categoria_id    TEXT(15),
      ops_lista_verif_resultado_id    TEXT(15),
      observacion                     TEXT(200),
      ruta_imagen                     TEXT,
      nombre_imagen                   TEXT(100),
      id_generado_syncronizacion      TEXT(15),
      aux_codigo                      TEXT(20),
      estado                          INTEGER
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_FB_GERENCIA (
      fb_gerencia_id TEXT(15),
      fb_uea_pe_id TEXT(15),
      codigo TEXT(50),
      nombre TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_FB_AREA (
      fb_area_id  TEXT(15),
      fb_gerencia_id TEXT(15),
      fb_uea_base_id TEXT(15),
      codigo  TEXT(50),
      nombre  TEXT(100),
      flag_mina_interior INTEGER DEFAULT 0
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_FB_EMPRESA_ESPECIALIZADA (
      fb_empresa_especializada_id TEXT(15),
      razon_social TEXT(100),
      ruc TEXT(20),
      g_rol_empresa_id TEXT(15)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_INC_TIPO_REPORTE (
      inc_tipo_reporte_id TEXT(15),
      nombre TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_INC_SUB_TIPO_REPORTE (
      inc_sub_tipo_reporte_id TEXT(15),
      inc_tipo_reporte_id TEXT(15),
      nombre TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_INC_DETALLE_PERDIDA (
      inc_segun_tipo_id TEXT(15),
      inc_tipo_reporte_id TEXT(15),
      nombre TEXT(500),
      codigo TEXT(500)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_INC_POTENCIAL_PERDIDA (
      inc_potencial_perdida_id TEXT(15),
      nombre TEXT(100),
      codigo TEXT(50)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_LISTA_TIPO_RESULTADO (
      ops_tipo_resultado_id   TEXT(15),
      codigo                  TEXT(20),
      nombre                  TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_LISTA_VERIFICACION (
      ops_lista_verificacion_id TEXT(15),
      ops_tipo_resultado_id     TEXT(15),
      ops_tipo_checklist_id     TEXT(15),
      ops_sub_tipo_inspeccion_id   TEXT(15),
      codigo                    TEXT(20),
      nombre                    TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_LISTA_VERIF_CATEGORIA(
      ops_lista_verif_categoria_id  TEXT(15),
      ops_lista_verificacion_id     TEXT(15),
      nombre                        TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_LISTA_VERIF_SECCION (
      ops_lista_verif_seccion_id    TEXT(15),
      ops_lista_verif_categoria_id  TEXT(15),
      ops_lista_verificacion_id     TEXT(15),
      nombre                        TEXT(100),
      orden                         TEXT(20)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_LISTA_VERIF_PREGUNTA(
      ops_lista_verif_pregunta_id   TEXT(15),
      ops_lista_verif_seccion_id    TEXT(15),
      ops_lista_verif_categoria_id  TEXT(15),
      ops_lista_verificacion_id     TEXT(15),
      nombre                        TEXT(100),
      flag_pregunta                 TEXT(1),
      orden                         TEXT(20),
      aux_codigo                    TEXT(20)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_LISTA_VERIF_RESULTADO(
      ops_lista_verif_resultado_id    TEXT(15),
      ops_tipo_resultado_id           TEXT(15),
      codigo                          TEXT(20),
      nombre                          TEXT(100),
      ops_tipo_checklist_id           TEXT(15)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_TURNOS(
      ops_turno_id    INTEGER primary key,
      codigo          TEXT(20),
      nombre          TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_TIPO (
      ops_tipo_inspeccion_id TEXT(15),
      nombre TEXT(100)
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_OPS_ALCANCE (
      ops_alcance_inspeccion_id TEXT(15),
      nombre TEXT(100)
      );
    ''');
  }

Future<Database> _initDB() async {
    final dbnew = await openDatabase(
      'Safe2BizApp001.db',
      version: 8,
      onDowngrade: (db, oldV, newV) async {
        // NO borres la BD aquí. Solo registra o lanza error en debug.
         print('⚠️ Downgrade intentado: $oldV → $newV. Ignorado.');
        // Si prefieres detectarlo en QA:
        // throw Exception('Downgrade de BD no soportado: $oldV → $newV');
      },
      onCreate: (Database db, int version) async {
        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_SETTINGS(
            ip TEXT(20),
            name_company TEXT(50),
            ARROBA_MOVIL TEXT(50)
            )
          ''');
        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_USER(
            id INTEGER,
            SC_USER_ID INTEGER,
            CODE TEXT(50),
            USER_LOGIN TEXT(50) NOT NULL,
            nombre_empleado TEXT(50) NOT NULL,
            ENTERPRISE TEXT(50),
            userPassword TEXT(50),
            fb_empleado_id TEXT(15),
            URL_EXT TEXT(200),
            URL_APP TEXT(200),
            ARROBA_MOVIL TEXT(50)
            )
          ''');

        await db.execute('''
           CREATE TABLE $TABLE_FB_UEA_PE (
            fb_uea_pe_id INTEGER,
            codigo TEXT(50),
            nombre TEXT(50),
            sc_user_id TEXT(15),
            fb_uea_base_id TEXT(15)
            );
          ''');
        await db.execute('''
           CREATE TABLE $TABLE_ACCESOS (
            fb_uea_pe_id INTEGER,
            codigo TEXT(50),
            modulos TEXT(50)
            );
          ''');


        //--------------------------------------------
        //----------------- AYC ----------------------
        //--------------------------------------------

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_AYC_REGISTRO (
            ayc_registro_id INTEGER primary key,
            origen TEXT(15),
            g_tipo_causa_id TEXT(15),
            g_tipo_causa_nombre TEXT(100),
            fb_gerencia_id TEXT(15),
            fb_gerencia_nombre TEXT(100),
            fb_area_id TEXT(15),
            fb_area_nombre TEXT(100),
            descripcion TEXT(200),
            lugar TEXT(200),
            fecha TEXT(10),
            hora  TEXT(5),
            corrigio TEXT(200),
            tipo_evento_id TEXT(15),
            tipo_evento_nombre TEXT(100),
            nivel_riesgo_id TEXT(15),
            nivel_riesgo_nombre TEXT(100),
            accion_ejec TEXT(200),
            fb_empresa_especializada_id TEXT(15),
            fb_empresa_especializada_nombre TEXT(100),
            latitud TEXT(15),
            longitud TEXT(15),
            foto_pre_evento_nombre TEXT(100),
            foto_pre_evento_ruta TEXT,
            foto_evento_nombre TEXT(100),
            foto_evento_ruta TEXT,
            fb_empleado_id TEXT(15),
            fb_empleado_nombre TEXT(100),
            fb_uea_pe_id TEXT(15),
            inc_bsaf_id TEXT(15),
            tarjeta_roja TEXT(15),
            interior_mina TEXT(1),
            interior_mina_nivel TEXT(100),
            interior_mina_labor TEXT(100),
            interior_mina_numero_labor TEXT(100),
            estado TEXT(1)
            );
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_G_TIPO_CAUSA (
          	g_tipo_causa_id TEXT(15),
            ayc TEXT(50),
            descripcion TEXT(200)
            );
          ''');
        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_G_NIVEL_RIESGO (
            g_nivel_riesgo_id TEXT(15),
            nombre TEXT(100)
            );
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_ORIGEN_AYC (
            code TEXT(15) primary key,
            name TEXT(100)
            );
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_TIPO_RIESGO_AYC (
            inc_tipo_reporte_id TEXT(15),
            nombre TEXT(100)
            );
          ''');
        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_AYC_EVIDENCIA (
            nombre TEXT(100),
            ruta TEXT(500),
            ayc_registro_id TEXT(15)
            );
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_AYC_REPORTANTE (
            fb_empleado_id TEXT(15),
            fb_uea_pe_id TEXT(15),
            nombreCompleto TEXT(100),
            numero_documento TEXT(100),
            cargo_nombre TEXT(100),
            gerencia_nombre TEXT(100),
            empresa TEXT(100)
            );
          ''');

        //--------------------------------------------
        //----------------- INC ----------------------
        //--------------------------------------------

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_INC_REGISTRO (
            inc_incidente_id INTEGER primary key,
            fb_empleado_id TEXT(15),
            fb_uea_pe_id TEXT(15),
            inc_tipo_evento TEXT(15),
            inc_tipo_evento_nombre TEXT(100),
            inc_sub_tipo_evento TEXT(15),
            inc_sub_tipo_evento_nombre TEXT(100),
            inc_segun_tipo TEXT(15),
            inc_segun_tipo_nombre TEXT(100),
            inc_potencial_perdida TEXT(15),
            inc_potencial_perdida_nombre TEXT(100),
            fb_gerencia_id TEXT(15),
            fb_gerencia_nombre TEXT(100),
            fb_area TEXT(15),
            fb_area_nombre TEXT(100),
            fecha_evento TEXT(10),
            hora TEXT(5),
            lugar_evento TEXT(100),
            descripcion_evento TEXT(100),
            imagen_pre_evento_nombre TEXT(100),
            imagen_pre_evento_ruta TEXT,
            imagen_evento_nombre TEXT(100),
            imagen_evento_ruta TEXT,
            estado TEXT(1)
            
            );
          ''');

        //--------------------------------------------
        //----------------- SAC ----------------------
        //--------------------------------------------

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_SAC_ACCION_CORRECTIVA (
            sac_accion_correctiva_id TEXT(15),
            codigo_accion_correctiva TEXT(100),
            accion_correctiva_detalle TEXT(100),
            fecha_acordada_ejecucion TEXT(10),
            nombre_responsable_correccion TEXT(100),
            nombre_responsable_verificador TEXT(100),
            fecha_origen TEXT(10),
            origen TEXT(50),
            uea_id TEXT(15),
            fecha_ejecucion TEXT(10),
            evidencia_nombre TEXT(100),
            evidencia_ruta TEXT,
            obs_resp_corr TEXT(100),
            estado TEXT(1)
            );
          ''');

        
        await db.execute('''
           CREATE TABLE $TABLE_RESPONSABLE (
            fb_empleado_id TEXT(15),
            nombre_responsable TEXT(100)
            );
          ''');

        await db.execute('''
           CREATE TABLE $TABLE_OPS_SUB_TIPO (
            ops_sub_tipo_id TEXT(15),
            nombre TEXT(100),
            g_tipo_origen_id TEXT(15)
            );
          ''');


        //--------------------------------------------
        //----------------- OPS ----------------------
        //--------------------------------------------

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_OPS_REGISTRO_GENERALES(
            ops_registro_generales_id           INTEGER primary key,
            fb_uea_pe_id                        TEXT(15),
            codigo                              TEXT(50),
            g_tipo_origen_id                    TEXT(15),
            fecha_ops                           TEXT(15),
            hora_ops                            TEXT(15),
            turno                               TEXT(50),
            fb_area_id                          TEXT(15),
            alcance                             TEXT(100),
            criterio                            TEXT(100),
            g_rol_empresa_id                    TEXT(15),
            fb_empresa_especializada_id         TEXT(15),
            fb_empleado_id                      TEXT(15),
            ops_lista_verificacion_id           TEXT(15),
            ops_tipo_resultado_id               TEXT(15),
            latitud                             TEXT(15),
            longitud                            TEXT(15),
            fb_area_nombre                      TEXT(100),
            turno_nombre                        TEXT(100),
            fb_empresa_especializada_nombre     TEXT(100),
            fb_empleado_nombre_completo         TEXT(100),
            id_generado_syncronizacion          TEXT(15),
            ops_sub_tipo_inspeccion_id          TEXT(15),
            ops_tipo_inspeccion_id              TEXT(15),
            ops_alcance_inspeccion_id           TEXT(15),
            
            fb_auditor_id                       TEXT(15),
            auditor_nombre                      TEXT(100),  
            fb_verificador_id                   TEXT(15),
            verificador_nombre                  TEXT(100),
            ops_involucrados                    TEXT(200),
            ops_inspectores                     TEXT(200),
               
            ops_contratista_id                  TEXT(15),
            contratista_nombre                  TEXT(200),
            tipo_servicio_nombre                TEXT(200),
            equipo_auditor                      TEXT(200),
            personal_auditado                   TEXT(200),
            
            ops_sub_tipo_inspeccion_text        TEXT(100),
            ops_tipo_inspeccion_text            TEXT(100),
            ops_alcance_inspeccion_text         TEXT(100),
            estado                              TEXT(1),
            flag                                TEXT(1)
          );
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_OPS_REGISTRO_RESULTADO(
            ops_registro_resultado_id       INTEGER primary key,
            ops_registro_generales_id       TEXT(15),
            ops_lista_verif_pregunta_id     TEXT(15),
            ops_lista_verif_seccion_id      TEXT(15),
            ops_lista_verif_categoria_id    TEXT(15),
            ops_lista_verif_resultado_id    TEXT(15),
            observacion                     TEXT(200),
            ruta_imagen                     TEXT,
            nombre_imagen                   TEXT(100),
            id_generado_syncronizacion      TEXT(15),
            aux_codigo                      TEXT(20),
            estado                          INTEGER
            
            );
            ''');

        //--------------------------------------------
        //---------- DATA PARA SINCRONIZAR -----------
        //--------------------------------------------
        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_FB_GERENCIA (
            fb_gerencia_id TEXT(15),
            fb_uea_pe_id TEXT(15),
            codigo TEXT(50),
            nombre TEXT(100)
            );
          ''');
        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_FB_AREA (
            fb_area_id  TEXT(15),
            fb_gerencia_id TEXT(15),
            fb_uea_base_id TEXT(15),
            codigo  TEXT(50),
            nombre  TEXT(100),
            flag_mina_interior INTEGER DEFAULT 0
            );
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_FB_EMPRESA_ESPECIALIZADA (
            fb_empresa_especializada_id TEXT(15),
            razon_social TEXT(100),
            ruc TEXT(20),
            g_rol_empresa_id TEXT(15)
            );
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_INC_TIPO_REPORTE (
            inc_tipo_reporte_id TEXT(15),
            nombre TEXT(100)
            );
          ''');


        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_INC_SUB_TIPO_REPORTE (
            inc_sub_tipo_reporte_id TEXT(15),
	          inc_tipo_reporte_id TEXT(15),
            nombre TEXT(100)
            );
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_INC_DETALLE_PERDIDA (
            inc_segun_tipo_id TEXT(15),
          	inc_tipo_reporte_id TEXT(15),
            nombre TEXT(500),
            codigo TEXT(500)
            );
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_INC_POTENCIAL_PERDIDA (
            inc_potencial_perdida_id TEXT(15),
            nombre TEXT(100),
            codigo TEXT(50)
            );
          ''');

        await db.execute('''
            CREATE TABLE $TABLE_OPS_LISTA_TIPO_RESULTADO (
            ops_tipo_resultado_id   TEXT(15),
            codigo                  TEXT(20),
            nombre                  TEXT(100)
            );    
          ''');

        await db.execute('''
            CREATE TABLE $TABLE_OPS_LISTA_VERIFICACION (
            ops_lista_verificacion_id TEXT(15),
            ops_tipo_resultado_id     TEXT(15),
            ops_tipo_checklist_id     TEXT(15),
            ops_sub_tipo_inspeccion_id   TEXT(15),
            codigo                    TEXT(20),
            nombre                    TEXT(100)
            );
          ''');

        await db.execute('''
            CREATE TABLE $TABLE_OPS_LISTA_VERIF_CATEGORIA(
            ops_lista_verif_categoria_id  TEXT(15),
            ops_lista_verificacion_id     TEXT(15),
            nombre                        TEXT(100)
            );    
          ''');

        await db.execute('''
            CREATE TABLE $TABLE_OPS_LISTA_VERIF_SECCION (
            ops_lista_verif_seccion_id    TEXT(15),
            ops_lista_verif_categoria_id  TEXT(15),
            ops_lista_verificacion_id     TEXT(15),
            nombre                        TEXT(100), 
            orden                         TEXT(20)
            );
          ''');

        await db.execute('''
            CREATE TABLE $TABLE_OPS_LISTA_VERIF_PREGUNTA(
            ops_lista_verif_pregunta_id   TEXT(15),
            ops_lista_verif_seccion_id    TEXT(15),
            ops_lista_verif_categoria_id  TEXT(15),
            ops_lista_verificacion_id     TEXT(15),
            nombre                        TEXT(100),
            flag_pregunta                 TEXT(1),
            orden                         TEXT(20),
            aux_codigo                    TEXT(20)
            );  
          ''');


        await db.execute('''
            CREATE TABLE $TABLE_OPS_LISTA_VERIF_RESULTADO(
            ops_lista_verif_resultado_id    TEXT(15),
            ops_tipo_resultado_id           TEXT(15),
            codigo                          TEXT(20),
            nombre                          TEXT(100),
            ops_tipo_checklist_id           TEXT(15) 
            );
          ''');

        await db.execute('''
            CREATE TABLE $TABLE_OPS_TURNOS(
            ops_turno_id    INTEGER primary key,
            codigo          TEXT(20),
            nombre          TEXT(100)
            );
          ''');


        await db.execute('''
           CREATE TABLE $TABLE_OPS_TIPO (
            ops_tipo_inspeccion_id TEXT(15),
            nombre TEXT(100)
            );
          ''');

        await db.execute('''
           CREATE TABLE $TABLE_OPS_ALCANCE (
            ops_alcance_inspeccion_id TEXT(15),
            nombre TEXT(100)
            );
          ''');

        // ========= onCreate =========
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_gerencia_id_norm
  ON $TABLE_FB_GERENCIA (TRIM(UPPER(fb_gerencia_id)));
''');

        // Un area (fb_area_id) puede pertenecer a varias bases (fb_uea_base_id),
        // por eso la clave unica es la combinacion de ambos, no fb_area_id solo.
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_area_id_uea_norm
  ON $TABLE_FB_AREA (TRIM(UPPER(fb_area_id)), TRIM(UPPER(COALESCE(fb_uea_base_id,''))));
''');

        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_empresa_especializada_id_norm
  ON $TABLE_FB_EMPRESA_ESPECIALIZADA (TRIM(UPPER(fb_empresa_especializada_id)));
''');

        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_tipo_reporte_id_norm
  ON $TABLE_INC_TIPO_REPORTE (TRIM(UPPER(inc_tipo_reporte_id)));
''');

        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_sub_tipo_reporte_id_norm
  ON $TABLE_INC_SUB_TIPO_REPORTE (TRIM(UPPER(inc_sub_tipo_reporte_id)));
''');

        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_detalle_perdida_id_norm
  ON $TABLE_INC_DETALLE_PERDIDA (TRIM(UPPER(inc_segun_tipo_id)));
''');

        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_potencial_perdida_id_norm
  ON $TABLE_INC_POTENCIAL_PERDIDA (TRIM(UPPER(inc_potencial_perdida_id)));
''');


        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_ops_tipo_inspeccion
  ON $TABLE_OPS_TIPO (ops_tipo_inspeccion_id);
''');


        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_ops_alcance_inspeccion
  ON $TABLE_OPS_ALCANCE (ops_alcance_inspeccion_id);
''');


        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_empleado
  ON $TABLE_RESPONSABLE (fb_empleado_id);
''');


        // CÓDIGO ÚNICO EN TIPO_RESULTADO (si lo necesitas)
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_tipo_resultado_codigo
  ON $TABLE_OPS_LISTA_VERIF_RESULTADO (codigo);
''');

// CÓDIGO ÚNICO EN VERIFICACIÓN
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_verificacion_codigo
  ON $TABLE_OPS_LISTA_VERIFICACION (codigo);
''');

// NOMBRE ÚNICO EN CATEGORÍA
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_categoria_nombre
  ON $TABLE_OPS_LISTA_VERIF_CATEGORIA (nombre);
''');

// (verificación_id, orden) ÚNICO EN SECCIÓN
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_seccion_verificacion_orden
  ON $TABLE_OPS_LISTA_VERIF_SECCION (ops_lista_verificacion_id, orden);
''');

// (seccion_id, orden) ÚNICO EN PREGUNTA
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_pregunta_seccion_orden
  ON $TABLE_OPS_LISTA_VERIF_PREGUNTA (ops_lista_verif_seccion_id, orden);
''');



        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_ops_sub_tipo_nombre_norm
  ON $TABLE_OPS_SUB_TIPO (TRIM(UPPER(nombre)));
''');


// G_TIPO_CAUSA: clave única por ID normalizado
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_g_tipo_causa_id_norm
  ON $TABLE_G_TIPO_CAUSA (TRIM(UPPER(g_tipo_causa_id)));
''');

// G_NIVEL_RIESGO: clave única por ID normalizado
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_g_nivel_riesgo_id_norm
  ON $TABLE_G_NIVEL_RIESGO (TRIM(UPPER(g_nivel_riesgo_id)));
''');

// TIPO_RIESGO_AYC: clave única por ID normalizado
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_tipo_riesgo_ayc_id_norm
  ON $TABLE_TIPO_RIESGO_AYC (TRIM(UPPER(inc_tipo_reporte_id)));
''');

// AYC_EVIDENCIA: evitar duplicados por (nombre, ruta, ayc_registro_id) normalizados
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_ayc_evidencia_norm
  ON $TABLE_AYC_EVIDENCIA (
    TRIM(UPPER(nombre)),
    TRIM(UPPER(ruta)),
    TRIM(ayc_registro_id)
  );
''');

// AYC_REPORTANTE: evitar duplicados por empleado + UEA normalizados
        await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_ayc_reportante_emp_uea_norm
  ON $TABLE_AYC_REPORTANTE (
    TRIM(UPPER(fb_empleado_id)),
    TRIM(UPPER(fb_uea_pe_id))
  );
''');






      },
        onUpgrade: (db, oldV, newV) async {
          await db.transaction((txn) async {
            if (oldV < 3) {
              // ====== LIMPIEZA ÚNICA (con misma normalización que los índices) ======

              await txn.execute('''
          DELETE FROM LISTA_RESPONSABLE
          WHERE rowid NOT IN (
            SELECT MIN(rowid)
            FROM LISTA_RESPONSABLE
            GROUP BY TRIM(UPPER(fb_empleado_id))
          );
        ''');

              await txn.execute('''
          DELETE FROM OPS_LISTA_VERIF_CATEGORIA
          WHERE rowid NOT IN (
            SELECT MIN(rowid)
            FROM OPS_LISTA_VERIF_CATEGORIA
            GROUP BY TRIM(UPPER(nombre))
          );
        ''');

              await txn.execute('''
          DELETE FROM OPS_LISTA_VERIFICACION
          WHERE rowid NOT IN (
            SELECT MIN(rowid)
            FROM OPS_LISTA_VERIFICACION
            GROUP BY TRIM(UPPER(codigo))
          );
        ''');

              await txn.execute('''
          DELETE FROM OPS_LISTA_VERIF_SECCION
          WHERE rowid NOT IN (
            SELECT MIN(rowid)
            FROM OPS_LISTA_VERIF_SECCION
            GROUP BY TRIM(UPPER(ops_lista_verificacion_id)),
                     TRIM(UPPER(COALESCE(orden,'')))
          );
        ''');

              await txn.execute('''
          DELETE FROM OPS_LISTA_VERIF_PREGUNTA
          WHERE rowid NOT IN (
            SELECT MIN(rowid)
            FROM OPS_LISTA_VERIF_PREGUNTA
            GROUP BY TRIM(UPPER(ops_lista_verif_seccion_id)),
                     TRIM(UPPER(COALESCE(orden,'')))
          );
        ''');

              await txn.execute('''
          DELETE FROM OPS_LISTA_VERIF_RESULTADO
          WHERE rowid NOT IN (
            SELECT MIN(rowid)
            FROM OPS_LISTA_VERIF_RESULTADO
            GROUP BY TRIM(UPPER(codigo))
          );
        ''');

              await txn.execute('''
          DELETE FROM OPS_LISTA_TIPO_RESULTADO
          WHERE rowid NOT IN (
            SELECT MIN(rowid)
            FROM OPS_LISTA_TIPO_RESULTADO
            GROUP BY TRIM(UPPER(codigo))
          );
        ''');


              await txn.execute('''
          DELETE FROM OPS_TIPO_INSPECCION
          WHERE rowid NOT IN (
            SELECT MIN(rowid)
            FROM OPS_TIPO_INSPECCION
            GROUP BY TRIM(UPPER(ops_tipo_inspeccion_id))
          );
        ''');



              await txn.execute('''
          DELETE FROM OPS_ALCANCE_INSPECCION
          WHERE rowid NOT IN (
            SELECT MIN(rowid)
            FROM OPS_ALCANCE_INSPECCION
            GROUP BY TRIM(UPPER(ops_alcance_inspeccion_id))
          );
        ''');


              // ====== (RE)CREAR ÍNDICES ÚNICOS NORMALIZADOS ======

              await db.execute('''
          CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_empleado
          ON $TABLE_RESPONSABLE (fb_empleado_id);
        ''');


              await txn.execute('''
          CREATE UNIQUE INDEX IF NOT EXISTS uq_tipores_codigo_norm
          ON OPS_LISTA_TIPO_RESULTADO ( TRIM(UPPER(codigo)) );
        ''');

              await txn.execute('''
          CREATE UNIQUE INDEX IF NOT EXISTS uq_verif_codigo_norm
          ON OPS_LISTA_VERIFICACION ( TRIM(UPPER(codigo)) );
        ''');

              await txn.execute('''
          CREATE UNIQUE INDEX IF NOT EXISTS uq_categoria_nombre_norm
          ON OPS_LISTA_VERIF_CATEGORIA ( TRIM(UPPER(nombre)) );
        ''');

              await txn.execute('''
          CREATE UNIQUE INDEX IF NOT EXISTS uq_seccion_verificacion_orden_norm
          ON OPS_LISTA_VERIF_SECCION (
            TRIM(UPPER(ops_lista_verificacion_id)),
            TRIM(UPPER(COALESCE(orden,'')))
          );
        ''');

              await txn.execute('''
          CREATE UNIQUE INDEX IF NOT EXISTS uq_pregunta_seccion_orden_norm
          ON OPS_LISTA_VERIF_PREGUNTA (
            TRIM(UPPER(ops_lista_verif_seccion_id)),
            TRIM(UPPER(COALESCE(orden,'')))
          );
        ''');

              await txn.execute('''
          CREATE UNIQUE INDEX IF NOT EXISTS uq_resultado_codigo_norm
          ON OPS_LISTA_VERIF_RESULTADO ( TRIM(UPPER(codigo)) );
        ''');

                  await db.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS uq_ops_tipo_nombre_norm
      ON $TABLE_OPS_TIPO (TRIM(UPPER(ops_tipo_inspeccion_id)));
    ''');

                  await db.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS uq_ops_alcance_nombre_norm
      ON $TABLE_OPS_ALCANCE (TRIM(UPPER(ops_alcance_inspeccion_id)));
    ''');

                  await db.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS uq_ops_sub_tipo_nombre_norm
      ON $TABLE_OPS_SUB_TIPO (TRIM(UPPER(nombre)));
    ''');

              // G_TIPO_CAUSA: limpiar duplicados por ID normalizado y crear índice único
              await txn.execute('''
  DELETE FROM $TABLE_G_TIPO_CAUSA
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_G_TIPO_CAUSA
    GROUP BY TRIM(UPPER(g_tipo_causa_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_g_tipo_causa_id_norm
  ON $TABLE_G_TIPO_CAUSA (TRIM(UPPER(g_tipo_causa_id)));
''');

// G_NIVEL_RIESGO
              await txn.execute('''
  DELETE FROM $TABLE_G_NIVEL_RIESGO
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_G_NIVEL_RIESGO
    GROUP BY TRIM(UPPER(g_nivel_riesgo_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_g_nivel_riesgo_id_norm
  ON $TABLE_G_NIVEL_RIESGO (TRIM(UPPER(g_nivel_riesgo_id)));
''');

// TIPO_RIESGO_AYC
              await txn.execute('''
  DELETE FROM $TABLE_TIPO_RIESGO_AYC
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_TIPO_RIESGO_AYC
    GROUP BY TRIM(UPPER(inc_tipo_reporte_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_tipo_riesgo_ayc_id_norm
  ON $TABLE_TIPO_RIESGO_AYC (TRIM(UPPER(inc_tipo_reporte_id)));
''');

// AYC_EVIDENCIA (nombre + ruta + ayc_registro_id)
              await txn.execute('''
  DELETE FROM $TABLE_AYC_EVIDENCIA
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_AYC_EVIDENCIA
    GROUP BY TRIM(UPPER(nombre)),
             TRIM(UPPER(ruta)),
             TRIM(ayc_registro_id)
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_ayc_evidencia_norm
  ON $TABLE_AYC_EVIDENCIA (
    TRIM(UPPER(nombre)),
    TRIM(UPPER(ruta)),
    TRIM(ayc_registro_id)
  );
''');

// AYC_REPORTANTE (empleado + uea)
              await txn.execute('''
  DELETE FROM $TABLE_AYC_REPORTANTE
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_AYC_REPORTANTE
    GROUP BY TRIM(UPPER(fb_empleado_id)),
             TRIM(UPPER(fb_uea_pe_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_ayc_reportante_emp_uea_norm
  ON $TABLE_AYC_REPORTANTE (
    TRIM(UPPER(fb_empleado_id)),
    TRIM(UPPER(fb_uea_pe_id))
  );
''');

              await txn.execute('''
  DELETE FROM $TABLE_FB_GERENCIA
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_FB_GERENCIA
    GROUP BY TRIM(UPPER(fb_gerencia_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_gerencia_id_norm
  ON $TABLE_FB_GERENCIA (TRIM(UPPER(fb_gerencia_id)));
''');

              await txn.execute('''
  DELETE FROM $TABLE_FB_AREA
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_FB_AREA
    GROUP BY TRIM(UPPER(fb_area_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_area_id_norm
  ON $TABLE_FB_AREA (TRIM(UPPER(fb_area_id)));
''');

              await txn.execute('''
  DELETE FROM $TABLE_FB_EMPRESA_ESPECIALIZADA
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_FB_EMPRESA_ESPECIALIZADA
    GROUP BY TRIM(UPPER(fb_empresa_especializada_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_empresa_especializada_id_norm
  ON $TABLE_FB_EMPRESA_ESPECIALIZADA (TRIM(UPPER(fb_empresa_especializada_id)));
''');

              await txn.execute('''
  DELETE FROM $TABLE_INC_TIPO_REPORTE
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_INC_TIPO_REPORTE
    GROUP BY TRIM(UPPER(inc_tipo_reporte_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_tipo_reporte_id_norm
  ON $TABLE_INC_TIPO_REPORTE (TRIM(UPPER(inc_tipo_reporte_id)));
''');

              await txn.execute('''
  DELETE FROM $TABLE_INC_SUB_TIPO_REPORTE
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_INC_SUB_TIPO_REPORTE
    GROUP BY TRIM(UPPER(inc_sub_tipo_reporte_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_sub_tipo_reporte_id_norm
  ON $TABLE_INC_SUB_TIPO_REPORTE (TRIM(UPPER(inc_sub_tipo_reporte_id)));
''');

              await txn.execute('''
  DELETE FROM $TABLE_INC_DETALLE_PERDIDA
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_INC_DETALLE_PERDIDA
    GROUP BY TRIM(UPPER(inc_segun_tipo_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_detalle_perdida_id_norm
  ON $TABLE_INC_DETALLE_PERDIDA (TRIM(UPPER(inc_segun_tipo_id)));
''');

              await txn.execute('''
  DELETE FROM $TABLE_INC_POTENCIAL_PERDIDA
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_INC_POTENCIAL_PERDIDA
    GROUP BY TRIM(UPPER(inc_potencial_perdida_id))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_inc_potencial_perdida_id_norm
  ON $TABLE_INC_POTENCIAL_PERDIDA (TRIM(UPPER(inc_potencial_perdida_id)));
''');

            }
            if (oldV < 4) {
              await txn.execute(
                  'ALTER TABLE $TABLE_AYC_REGISTRO ADD COLUMN interior_mina TEXT(1)');
              await txn.execute(
                  'ALTER TABLE $TABLE_AYC_REGISTRO ADD COLUMN interior_mina_nivel TEXT(100)');
              await txn.execute(
                  'ALTER TABLE $TABLE_AYC_REGISTRO ADD COLUMN interior_mina_labor TEXT(100)');
              await txn.execute(
                  'ALTER TABLE $TABLE_AYC_REGISTRO ADD COLUMN interior_mina_numero_labor TEXT(100)');
            }
            if (oldV < 5) {
              try {
                await txn.execute(
                    'ALTER TABLE $TABLE_FB_UEA_PE ADD COLUMN fb_uea_base_id TEXT(15)');
              } catch (_) {}
            }
            if (oldV < 6) {
              try {
                await txn.execute(
                    'ALTER TABLE $TABLE_FB_AREA ADD COLUMN fb_uea_base_id TEXT(15)');
              } catch (_) {}
            }
            if (oldV < 7) {
              // El indice unico previo era solo sobre fb_area_id, pero un area
              // puede repetirse para varias bases (fb_uea_base_id). Se reemplaza
              // por un indice compuesto (fb_area_id, fb_uea_base_id).
              await txn.execute('DROP INDEX IF EXISTS uq_fb_area_id_norm');
              await txn.execute('''
  DELETE FROM $TABLE_FB_AREA
  WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM $TABLE_FB_AREA
    GROUP BY TRIM(UPPER(fb_area_id)),
             TRIM(UPPER(COALESCE(fb_uea_base_id,'')))
  );
''');
              await txn.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_area_id_uea_norm
  ON $TABLE_FB_AREA (TRIM(UPPER(fb_area_id)), TRIM(UPPER(COALESCE(fb_uea_base_id,''))));
''');
            }
            if (oldV < 8) {
              // Nueva columna del SP pr_movil_FB_AREA: flag_mina_interior.
              try {
                await txn.execute(
                    'ALTER TABLE $TABLE_FB_AREA ADD COLUMN flag_mina_interior INTEGER DEFAULT 0');
              } catch (_) {}
            }
          });
        },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (db) async {
        // Auto-reparacion NO destructiva del esquema en CADA apertura: crea las
        // tablas y columnas que falten tras instalar una version nueva del APK
        // sobre una BD antigua, SIN borrar datos. Asi el usuario ya no necesita
        // borrar cache/datos de la app para evitar conflictos de version.
        await _ensureSchema(db);

        // Saneamiento defensivo de indices de FB_AREA: en algunos dispositivos
        // el indice unico viejo (solo fb_area_id) quedo vivo y, con
        // ConflictAlgorithm.replace, colapsaba las 277 filas a 1 por fb_area_id.
        // Esto se ejecuta en cada apertura y es idempotente.
        try {
          await db.execute('DROP INDEX IF EXISTS uq_fb_area_id_norm');
          await db.execute('''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_fb_area_id_uea_norm
  ON $TABLE_FB_AREA (TRIM(UPPER(fb_area_id)), TRIM(UPPER(COALESCE(fb_uea_base_id,''))));
''');
          final idx = await db.rawQuery(
            "SELECT name, sql FROM sqlite_master "
            "WHERE type='index' AND tbl_name='$TABLE_FB_AREA';",
          );
          print('### [FB_AREA indices tras saneo]: $idx');
        } catch (e) {
          print('### [FB_AREA saneo indices] ERROR: $e');
        }
      },


    );
    return dbnew;
  }


}
