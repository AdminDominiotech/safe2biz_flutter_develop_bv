import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';

abstract class PlanesAccionApiRepository {
  Future<Either<Failure, bool>> savePlanAccion(
    PlanAccion planAccion,
    String userId,
  );
}
