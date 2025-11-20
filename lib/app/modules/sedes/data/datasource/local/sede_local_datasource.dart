import 'package:safe2biz/app/modules/sedes/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/data/models/models.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';

abstract class SedeLocalDatasource extends SedeDatasource {
  Future<List<SedeModel>> getSedesFromStorage();
  Future<bool> saveSedesStorage(List<Sede> companies);
}
