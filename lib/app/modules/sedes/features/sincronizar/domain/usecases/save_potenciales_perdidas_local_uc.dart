import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SavePotencialesPerdidasLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(
      List<PotencialPerdida> potencialesPerdidas);
}

class SavePotencialesPerdidasLocalUcImpl
    implements SavePotencialesPerdidasLocalUc<bool, dynamic> {
  SavePotencialesPerdidasLocalUcImpl(
      {required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
          List<PotencialPerdida> potencialesPerdidas) async =>
      await _local.savePotencialesPerdidasToLocal(potencialesPerdidas);
}
