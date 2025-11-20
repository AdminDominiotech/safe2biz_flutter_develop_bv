import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/repositories/planes_accion_local_repository.dart';

abstract class DeletePlanAccionStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(String id);
}

class DeletePlanAccionStorageUcImpl
    implements DeletePlanAccionStorageUc<bool, dynamic> {
  DeletePlanAccionStorageUcImpl({
    required PlanesAccionLocalRepository local,
  }) : _local = local;

  final PlanesAccionLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(String id) async =>
      await _local.deletePlanAccionStorage(id);
}
