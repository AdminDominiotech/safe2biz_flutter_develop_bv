import 'package:flutter/material.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe2biz/app/global/core/env/env.dart';
import 'package:safe2biz/app/modules/init/app.dart';
import 'package:safe2biz/app/global/core/injection/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void checkForUpdate() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final String currentVersion = packageInfo.version;

  final String? savedVersion = prefs.getString('app_version');
  if (savedVersion == null || savedVersion != currentVersion) {
    // La versión ha cambiado, limpia el caché y los datos antiguos
    await prefs.clear(); // Limpia todas las preferencias guardadas
    // Agrega aquí cualquier otro proceso de limpieza específico

    // Guarda la nueva versión en las preferencias
    await prefs.setString('app_version', currentVersion);
  }
}

Future<void> deleteDatabaseFile() async {
  final String databasesPath = await getDatabasesPath();
  final String path = '$databasesPath/codigos.db'; // Usa el nombre correcto de tu base de datos

  // Eliminar la base de datos
  await deleteDatabase(path);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  checkForUpdate();
  await deleteDatabaseFile();

  // Registrar dependencias (como GetIt)
  setUp();

  final LocalSqlite sqlite = LocalSqlite(); // O usa GetIt.I<LocalSqlite>() si ya lo registraste

  // Accede a la base de datos
  final Database db = await sqlite.database;

  // Verifica si ya existe configuración, si no, inserta la default
  final List<Map<String, Object?>> existing =
  await db.query(LocalSqlite.TABLE_SETTINGS);

  if (existing.isEmpty) {
    await db.insert(
      LocalSqlite.TABLE_SETTINGS,
      {
        'ip': 'https://desafe2biz.buenaventura.pe:7543',
        'name_company': 'BUENAVENTURA',
        'ARROBA_MOVIL': 'buenaventuras2b',
      },
    );
  }

  // Carga el host para Env
  await Env.loadHost(sqlite);

  runApp(const Safe2BizApp());
}
