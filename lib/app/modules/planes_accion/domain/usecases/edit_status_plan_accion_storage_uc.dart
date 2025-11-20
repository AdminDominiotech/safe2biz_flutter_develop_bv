import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/repositories/planes_accion_local_repository.dart';

abstract class EditStatusPlanAccionStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(String id, String status);
}

class EditStatusPlanAccionStorageUcImpl
    implements EditStatusPlanAccionStorageUc<bool, dynamic> {
  EditStatusPlanAccionStorageUcImpl({
    required PlanesAccionLocalRepository repository,
  }) : _repository = repository;

  final PlanesAccionLocalRepository _repository;

  @override
  Future<Either<Failure, bool>> call(String id, String status) async =>
      await _repository.editStatusPlanAccionFromStorage(id, status);
}
