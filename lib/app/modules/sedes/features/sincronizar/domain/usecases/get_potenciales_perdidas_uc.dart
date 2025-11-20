import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class GetPotencialesPerdidasUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetPotencialesPerdidasUcImpl
    implements GetPotencialesPerdidasUc<List<PotencialPerdida>, dynamic> {
  GetPotencialesPerdidasUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<PotencialPerdida>>> call() async =>
      await _repository.getPotencialesPerdidasFromApi();
}
