import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetPreguntasOpsUc<Output, Input> {
  Future<Either<Failure, Output>> call(String userLogin);
}

class GetPreguntasOpsUcImpl
    implements GetPreguntasOpsUc<List<PreguntaOps>, dynamic> {
  GetPreguntasOpsUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<PreguntaOps>>> call(String userLogin) async =>
      await _repository.getPreguntasOpsFromApi(userLogin);
}
