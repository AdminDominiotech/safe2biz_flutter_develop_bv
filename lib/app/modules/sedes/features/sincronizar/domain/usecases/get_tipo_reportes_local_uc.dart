import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetTipoReportesLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetTipoReportesLocalUcImpl
    implements GetTipoReportesLocalUc<List<TipoReporte>, dynamic> {
  GetTipoReportesLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<TipoReporte>>> call() async =>
      await _local.getTiposReportesFromLocal();
}
