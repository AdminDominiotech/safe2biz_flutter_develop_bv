import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveVerificacionesOpsLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<VerificacionOps> verificacionesOps);
}

class SaveVerificacionesOpsLocalUcImpl
    implements SaveVerificacionesOpsLocalUc<bool, dynamic> {
  SaveVerificacionesOpsLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
          List<VerificacionOps> verificacionesOps) async =>
      await _local.saveVerificacionesOpsToLocal(verificacionesOps);
}
