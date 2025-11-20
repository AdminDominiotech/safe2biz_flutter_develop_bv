import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';

abstract class PlanesAccionLocalRepository {
  Future<Either<Failure, List<PlanAccion>>> getPlanesAccionFromStorage(
      String sedeId);
  Future<Either<Failure, bool>> editPlanAccionStorage(PlanAccion planAccion);
  Future<Either<Failure, bool>> deleteAllPlanesAccionStorage();
  Future<Either<Failure, bool>> editStatusPlanAccionFromStorage(
    String id,
    String status,
  );
  Future<Either<Failure, bool>> deletePlanAccionStorage(String id);
}
