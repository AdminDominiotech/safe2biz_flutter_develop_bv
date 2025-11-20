import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/repositories/planes_accion_local_repository.dart';

abstract class EditPlanAccionStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(PlanAccion planAccion);
}

class EditPlanAccionStorageUcImpl
    implements EditPlanAccionStorageUc<bool, dynamic> {
  EditPlanAccionStorageUcImpl({
    required PlanesAccionLocalRepository repository,
  }) : _repository = repository;

  final PlanesAccionLocalRepository _repository;

  @override
  Future<Either<Failure, bool>> call(PlanAccion planAccion) async =>
      await _repository.editPlanAccionStorage(planAccion);
}
