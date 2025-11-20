import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class GetPlanesAccionStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(String idSede);
}

class GetPlanesAccionStorageUcImpl
    implements GetPlanesAccionStorageUc<List<PlanAccion>, dynamic> {
  GetPlanesAccionStorageUcImpl({
    required PlanesAccionLocalRepository repository,
  }) : _repository = repository;

  final PlanesAccionLocalRepository _repository;

  @override
  Future<Either<Failure, List<PlanAccion>>> call(String idSede) async =>
      await _repository.getPlanesAccionFromStorage(idSede);
}
