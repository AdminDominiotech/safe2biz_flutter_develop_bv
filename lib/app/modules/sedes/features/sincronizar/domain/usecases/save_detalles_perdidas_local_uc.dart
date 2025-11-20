import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveDetallesPerdidasLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<DetallePerdida> detallesPerdidas);
}

class SaveDetallesPerdidasLocalUcImpl
    implements SaveDetallesPerdidasLocalUc<bool, dynamic> {
  SaveDetallesPerdidasLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
          List<DetallePerdida> detallesPerdidas) async =>
      await _local.saveDetallesPerdidasToLocal(detallesPerdidas);
}
