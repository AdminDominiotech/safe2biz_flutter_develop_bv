import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetPotencialesPerdidasLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetPotencialesPerdidasLocalUcImpl
    implements GetPotencialesPerdidasLocalUc<List<PotencialPerdida>, dynamic> {
  GetPotencialesPerdidasLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<PotencialPerdida>>> call() async =>
      await _local.getPotencialesPerdidasFromLocal();
}
