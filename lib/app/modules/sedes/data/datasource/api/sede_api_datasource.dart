import 'package:safe2biz/app/modules/sedes/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/data/models/models.dart';

abstract class SedeApiDatasource extends SedeDatasource {
  Future<List<SedeModel>> getSedesFromApi(String userId);
}
