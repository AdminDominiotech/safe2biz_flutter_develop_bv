import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class EditActoCondicionStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(ActoCondicion actoCondicion);
}

class EditActoCondicionStorageUcImpl
    implements EditActoCondicionStorageUc<bool, dynamic> {
  EditActoCondicionStorageUcImpl({
    required ActosCondicionesLocalRepository repository,
  }) : _repository = repository;

  final ActosCondicionesLocalRepository _repository;

  @override
  Future<Either<Failure, bool>> call(ActoCondicion actoCondicion) async =>
      await _repository.editActoCondicionStorage(actoCondicion);
}
