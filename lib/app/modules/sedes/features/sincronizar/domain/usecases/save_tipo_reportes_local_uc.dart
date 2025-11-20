import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveTipoReportesLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<TipoReporte> tipoReportes);
}

class SaveTipoReportesLocalUcImpl
    implements SaveTipoReportesLocalUc<bool, dynamic> {
  SaveTipoReportesLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(List<TipoReporte> tipoReportes) async =>
      await _local.saveTiposReportesToLocal(tipoReportes);
}
