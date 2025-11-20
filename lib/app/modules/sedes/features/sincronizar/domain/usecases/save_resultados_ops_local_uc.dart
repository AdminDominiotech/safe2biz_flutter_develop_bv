import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveResultadosOpsLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<ResultadoOps> resultadoOps);
}

class SaveResultadosOpsLocalUcImpl
    implements SaveResultadosOpsLocalUc<bool, dynamic> {
  SaveResultadosOpsLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(List<ResultadoOps> resultadoOps) async =>
      await _local.saveResultadoOpsToLocal(resultadoOps);
}
