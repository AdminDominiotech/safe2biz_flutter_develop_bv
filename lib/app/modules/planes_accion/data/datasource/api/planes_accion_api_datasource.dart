import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/modules/planes_accion/data/datasource/planes_accion_datasource.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';

abstract class PlanesAccionApiDatasource extends PlanesAccionDatasource {
  Future<bool> savePlanesAccionApi(PlanAccion planAccion, String userId);
}
