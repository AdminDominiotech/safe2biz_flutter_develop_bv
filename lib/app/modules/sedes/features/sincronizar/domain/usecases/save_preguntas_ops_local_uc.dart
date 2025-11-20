import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SavePreguntasOpsLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<PreguntaOps> preguntasOps);
}

class SavePreguntasOpsLocalUcImpl
    implements SavePreguntasOpsLocalUc<bool, dynamic> {
  SavePreguntasOpsLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
    List<PreguntaOps> preguntasOps,
  ) async =>
      await _local.savePreguntasOpsToLocal(preguntasOps);
}
