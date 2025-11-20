import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetDesviacionesUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetDesviacionesUcImpl
    implements GetDesviacionesUc<List<Desviacion>, dynamic> {
  GetDesviacionesUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<Desviacion>>> call() async =>
      await _repository.getDesviacionesFromApi();
}
