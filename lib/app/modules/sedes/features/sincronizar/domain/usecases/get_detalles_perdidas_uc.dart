import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class GetDetallesPerdidasUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetDetallesPerdidasUcImpl
    implements GetDetallesPerdidasUc<List<DetallePerdida>, dynamic> {
  GetDetallesPerdidasUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<DetallePerdida>>> call() async =>
      await _repository.getDetallesPerdidasFromApi();
}
