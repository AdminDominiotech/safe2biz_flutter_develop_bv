import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetResultadosOpsUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetResultadosOpsUcImpl
    implements GetResultadosOpsUc<List<ResultadoOps>, dynamic> {
  GetResultadosOpsUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<ResultadoOps>>> call() async =>
      await _repository.getResultadoOpsFromApi();
}
