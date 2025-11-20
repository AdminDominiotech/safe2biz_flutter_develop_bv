import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveSubTipoReportesLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<SubTipoReporte> subTipoReportes);
}

class SaveSubTipoReportesLocalUcImpl
    implements SaveSubTipoReportesLocalUc<bool, dynamic> {
  SaveSubTipoReportesLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
          List<SubTipoReporte> subTipoReportes) async =>
      await _local.saveSubTiposReportesToLocal(subTipoReportes);
}
