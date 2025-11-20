import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';

class Env {
  static String? host;

  static Future<void> loadHost(LocalSqlite sqlite) async {
    final db = await sqlite.database;

    // Imprimir todos los registros de la tabla settings
    final allRecords = await db.query(LocalSqlite.TABLE_SETTINGS);
    print('[Env] Todos los registros en la tabla SETTINGS:');
    for (final record in allRecords) {
      print(record);
    }

    // Tomar el último registro insertado (más reciente)
    final result = await db.query(
      LocalSqlite.TABLE_SETTINGS,
      orderBy: 'ROWID DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      final ip = result.first['ip'] as String;
      host = '$ip/ws/null/';
      print('[Env] Host cargado: $host');
    } else {
      throw Exception('No se encontró configuración en la base de datos');
    }
  }
}
