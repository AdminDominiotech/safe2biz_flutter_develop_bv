import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class GetActoCondicionStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(String id);
}

class GetActoCondicionStorageUcImpl
    implements GetActoCondicionStorageUc<ActoCondicion, dynamic> {
  GetActoCondicionStorageUcImpl({
    required ActosCondicionesLocalRepository repository,
  }) : _repository = repository;

  final ActosCondicionesLocalRepository _repository;

  @override
  Future<Either<Failure, ActoCondicion>> call(String id) async =>
      await _repository.getActoCondicionFromStorage(id);
}
