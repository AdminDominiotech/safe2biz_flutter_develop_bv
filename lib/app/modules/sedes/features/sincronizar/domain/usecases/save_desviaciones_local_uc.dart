import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveDesviacionesLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<Desviacion> desviaciones);
}

class SaveDesviacionesLocalUcImpl
    implements SaveDesviacionesLocalUc<bool, dynamic> {
  SaveDesviacionesLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(List<Desviacion> desviaciones) async =>
      await _local.saveDesviacionesToLocal(desviaciones);
}
