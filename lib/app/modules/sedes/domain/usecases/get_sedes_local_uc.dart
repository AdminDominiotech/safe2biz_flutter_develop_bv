import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/domain/repositories/repositories.dart';

abstract class GetSedesLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetSedesLocalUcImpl implements GetSedesLocalUc<List<Sede>, dynamic> {
  GetSedesLocalUcImpl({required SedeLocalRepository repository})
      : _repository = repository;

  final SedeLocalRepository _repository;

  @override
  Future<Either<Failure, List<Sede>>> call() async =>
      await _repository.getSedesFromStorage();
}
