import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetVerificacionesOpsLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetVerificacionesOpsLocalUcImpl
    implements GetVerificacionesOpsLocalUc<List<VerificacionOps>, dynamic> {
  GetVerificacionesOpsLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<VerificacionOps>>> call() async =>
      await _local.getVerificacionesOpsFromLocal();
}
