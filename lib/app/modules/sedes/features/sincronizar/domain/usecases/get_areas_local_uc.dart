import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetAreasLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetAreasLocalUcImpl implements GetAreasLocalUc<List<Area>, dynamic> {
  GetAreasLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<Area>>> call() async =>
      await _local.getAreasFromLocal();
}
