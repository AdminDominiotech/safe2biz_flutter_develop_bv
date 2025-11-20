import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveSeccionesOpsLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<SeccionOps> seccionesOps);
}

class SaveSeccionesOpsLocalUcImpl
    implements SaveSeccionesOpsLocalUc<bool, dynamic> {
  SaveSeccionesOpsLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
    List<SeccionOps> seccionesOps,
  ) async =>
      await _local.saveSeccionesOpsToLocal(seccionesOps);
}
