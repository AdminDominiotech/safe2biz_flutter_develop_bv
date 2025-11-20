import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetSeccionesOpsUc<Output, Input> {
  Future<Either<Failure, Output>> call(String userLogin);
}

class GetSeccionesOpsUcImpl
    implements GetSeccionesOpsUc<List<SeccionOps>, dynamic> {
  GetSeccionesOpsUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<SeccionOps>>> call(String userLogin) async =>
      await _repository.getSeccionesOpsFromApi(userLogin);
}
