import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class DeleteAllActosCondicionesStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class DeleteAllActosCondicionesStorageUcImpl
    implements DeleteAllActosCondicionesStorageUc<bool, dynamic> {
  DeleteAllActosCondicionesStorageUcImpl({
    required ActosCondicionesLocalRepository repository,
  }) : _repository = repository;

  final ActosCondicionesLocalRepository _repository;

  @override
  Future<Either<Failure, bool>> call() async =>
      await _repository.deleteAllActosCondicionesStorage();
}
