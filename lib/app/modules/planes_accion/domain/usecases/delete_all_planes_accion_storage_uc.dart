import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/repositories/planes_accion_local_repository.dart';

abstract class DeleteAllPlanesAccionStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class DeleteAllPlanesAccionStorageUcImpl
    implements DeleteAllPlanesAccionStorageUc<bool, dynamic> {
  DeleteAllPlanesAccionStorageUcImpl({
    required PlanesAccionLocalRepository repository,
  }) : _repository = repository;

  final PlanesAccionLocalRepository _repository;

  @override
  Future<Either<Failure, bool>> call() async =>
      await _repository.deleteAllPlanesAccionStorage();
}
