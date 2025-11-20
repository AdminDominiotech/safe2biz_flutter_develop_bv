import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetVerificacionesOpsUc<Output, Input> {
  Future<Either<Failure, Output>> call(String userLogin);
}

class GetVerificacionesOpsUcImpl
    implements GetVerificacionesOpsUc<List<VerificacionOps>, dynamic> {
  GetVerificacionesOpsUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<VerificacionOps>>> call(String userLogin) async =>
      await _repository.getVerificacionesOpsFromApi(userLogin);
}
