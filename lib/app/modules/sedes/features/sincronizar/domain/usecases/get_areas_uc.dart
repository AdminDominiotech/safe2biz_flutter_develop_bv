import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetAreasUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetAreasUcImpl implements GetAreasUc<List<Area>, dynamic> {
  GetAreasUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<Area>>> call() async =>
      await _repository.getAreasFromApi();
}
