import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetTurnosOpsLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetTurnosOpsLocalUcImpl
    implements GetTurnosOpsLocalUc<List<Turno>, dynamic> {
  GetTurnosOpsLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<Turno>>> call() async =>
      await _local.getTurnosOpsFromLocal();
}
