import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveAreasLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<Area> areas);
}

class SaveAreasLocalUcImpl implements SaveAreasLocalUc<bool, dynamic> {
  SaveAreasLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(List<Area> areas) async =>
      await _local.saveAreasToLocal(areas);
}
