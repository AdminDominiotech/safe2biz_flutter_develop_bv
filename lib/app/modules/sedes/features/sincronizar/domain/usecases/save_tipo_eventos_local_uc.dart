import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveTipoEventosLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<TipoEvento> tipoEventos);
}

class SaveTipoEventosLocalUcImpl
    implements SaveTipoEventosLocalUc<bool, dynamic> {
  SaveTipoEventosLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(List<TipoEvento> tipoEventos) async =>
      await _local.saveTipoEventoToLocal(tipoEventos);
}
