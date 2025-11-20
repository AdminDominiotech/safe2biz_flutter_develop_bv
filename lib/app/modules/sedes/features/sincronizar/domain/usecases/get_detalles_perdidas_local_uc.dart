import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetDetallesPerdidasLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetDetallesPerdidasLocalUcImpl
    implements GetDetallesPerdidasLocalUc<List<DetallePerdida>, dynamic> {
  GetDetallesPerdidasLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<DetallePerdida>>> call() async =>
      await _local.getDetallesPerdidasFromLocal();
}
