import 'package:safe2biz/app/modules/planes_accion/data/datasource/planes_accion_datasource.dart';
import 'package:safe2biz/app/modules/planes_accion/data/models/plan_accion_model.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';

abstract class PlanesAccionLocalDatasource extends PlanesAccionDatasource {
  Future<List<PlanesAccionModel>> getPlanesAccionFromStorage(String sedeId);
  Future<bool> editPlanAccionFromStorage(PlanAccion planAccion);
  Future<bool> editStatusPlanAccionFromStorage(String id, String status);
  Future<bool> deletePlanAccionStorage(String id);
  Future<bool> deleteAllPlanesAccionStorage();
}
