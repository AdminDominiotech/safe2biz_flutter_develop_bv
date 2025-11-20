import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/domain/repositories/repositories.dart';

abstract class SaveSedesLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    List<Sede> sedes,
  );
}

class SaveSedesLocalUcImpl implements SaveSedesLocalUc<bool, dynamic> {
  SaveSedesLocalUcImpl({required SedeLocalRepository repository})
      : _repository = repository;

  final SedeLocalRepository _repository;

  @override
  Future<Either<Failure, bool>> call(
    List<Sede> sedes,
  ) async =>
      await _repository.saveSedesStorage(sedes);
}
