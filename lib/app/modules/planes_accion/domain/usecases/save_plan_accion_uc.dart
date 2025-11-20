import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/repositories/repositories.dart';

abstract class SavePlanAccionUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    PlanAccion planAccion,
    String userId,
  );
}

class SavePlanAccionUcImpl implements SavePlanAccionUc<bool, dynamic> {
  SavePlanAccionUcImpl({required PlanesAccionApiRepository repository})
      : _repository = repository;

  final PlanesAccionApiRepository _repository;

  @override
  Future<Either<Failure, bool>> call(
    PlanAccion planAccion,
    String userId,
  ) async =>
      await _repository.savePlanAccion(planAccion, userId);
}
