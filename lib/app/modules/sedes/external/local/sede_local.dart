import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/data/models/models.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';

class SedeLocal implements SedeLocalDatasource {
  SedeLocal({required this.sqlite});
  final LocalSqlite sqlite;

  @override
  Future<List<SedeModel>> getSedesFromStorage() async {
    try {
      final db = await sqlite.database;

      final results = await db.query(LocalSqlite.TABLE_FB_UEA_PE);
      if (results.isNotEmpty) {
        final sedes =
            List.from(results).map((item) => SedeModel.fromJson(item)).toList();
        return sedes;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }

  @override
  Future<bool> saveSedesStorage(List<Sede> companies) async {
    try {
      final db = await sqlite.database;
      await db.delete(LocalSqlite.TABLE_FB_UEA_PE);

      final batch = db.batch();

      for (final c in companies) {
        batch.insert(LocalSqlite.TABLE_FB_UEA_PE, {
          'fb_uea_pe_id': c.id,
          'codigo': c.code,
          'nombre': c.name,
          'sc_user_id': c.userId,
          'fb_uea_base_id': c.fb_uea_base_id,
        });
      }

      await batch.commit(noResult: true);

      return true;
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }
}
