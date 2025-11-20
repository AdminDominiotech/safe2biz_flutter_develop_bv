import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveTurnosOpsLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<Turno> turnoOps);
}

class SaveTurnosOpsLocalUcImpl implements SaveTurnosOpsLocalUc<bool, dynamic> {
  SaveTurnosOpsLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(List<Turno> turnoOps) async =>
      await _local.saveTurnosOpsToLocal(turnoOps);
}
