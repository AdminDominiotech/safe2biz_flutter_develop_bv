import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetTipoEventosLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetTipoEventosLocalUcImpl
    implements GetTipoEventosLocalUc<List<TipoEvento>, dynamic> {
  GetTipoEventosLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<TipoEvento>>> call() async =>
      await _local.getTiposEventosFromLocal();
}
