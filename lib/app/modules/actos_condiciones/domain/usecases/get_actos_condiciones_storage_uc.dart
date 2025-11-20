import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class GetActosCondicionesStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(String idSede);
}

class GetActosCondicionesStorageUcImpl
    implements GetActosCondicionesStorageUc<List<ActoCondicion>, dynamic> {
  GetActosCondicionesStorageUcImpl({
    required ActosCondicionesLocalRepository repository,
  }) : _repository = repository;

  final ActosCondicionesLocalRepository _repository;

  @override
  Future<Either<Failure, List<ActoCondicion>>> call(String idSede) async =>
      await _repository.getActosCondicionesFromStorage(idSede);
}
