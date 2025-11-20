import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/domain/repositories/repositories.dart';

abstract class GetSedesUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    String userId,
  );
}

class GetSedesUcImpl implements GetSedesUc<List<Sede>, dynamic> {
  GetSedesUcImpl({required SedeApiRepository repository})
      : _repository = repository;

  final SedeApiRepository _repository;

  @override
  Future<Either<Failure, List<Sede>>> call(
    String userId,
  ) async =>
      await _repository.getSedesFromApi(userId);
}
