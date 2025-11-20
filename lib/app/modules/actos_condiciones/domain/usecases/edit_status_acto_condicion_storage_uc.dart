import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class EditStatusActoCondicionStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(int id, String status);
}

class EditStatusActoCondicionStorageUcImpl
    implements EditStatusActoCondicionStorageUc<bool, dynamic> {
  EditStatusActoCondicionStorageUcImpl({
    required ActosCondicionesLocalRepository repository,
  }) : _repository = repository;

  final ActosCondicionesLocalRepository _repository;

  @override
  Future<Either<Failure, bool>> call(int id, String status) async =>
      await _repository.editStatusActoCondicionFromStorage(id, status);
}
