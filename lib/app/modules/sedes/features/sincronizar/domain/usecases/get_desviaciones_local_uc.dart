import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetDesviacionesLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetDesviacionesLocalUcImpl
    implements GetDesviacionesLocalUc<List<Desviacion>, dynamic> {
  GetDesviacionesLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<Desviacion>>> call() async =>
      await _local.getDesviacionesFromLocal();
}
