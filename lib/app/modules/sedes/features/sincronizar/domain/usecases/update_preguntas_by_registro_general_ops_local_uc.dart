import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class UpdatePreguntasByRegistroGeneralOpsLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(String idGeneral, String idVerificacion);
}

class UpdatePreguntasByRegistroGeneralOpsLocalUcImpl
    implements UpdatePreguntasByRegistroGeneralOpsLocalUc<int, dynamic> {
  UpdatePreguntasByRegistroGeneralOpsLocalUcImpl(
      {required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, int>> call(
    String idGeneral,
    String idVerificacion,
  ) async =>
      await _local.updatePreguntasByRegistroGeneralOpsFromLocal(
        idGeneral,
        idVerificacion,
      );
}
