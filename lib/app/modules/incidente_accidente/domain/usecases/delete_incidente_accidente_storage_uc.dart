import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/repositories/repositories.dart';

abstract class DeleteIncidenteAccidenteStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(int id);
}

class DeleteIncidenteAccidenteStorageUcImpl
    implements DeleteIncidenteAccidenteStorageUc<bool, dynamic> {
  DeleteIncidenteAccidenteStorageUcImpl({
    required IncidentesAccidentesLocalRepository local,
  }) : _local = local;

  final IncidentesAccidentesLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(int id) async =>
      await _local.deleteIncidenteAccidenteStorage(id);
}
