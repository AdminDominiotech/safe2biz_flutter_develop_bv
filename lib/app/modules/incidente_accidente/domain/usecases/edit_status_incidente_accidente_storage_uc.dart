import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/repositories/repositories.dart';

abstract class EditStatusIncidenteAccidenteStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(int id, String status);
}

class EditStatusIncidenteAccidenteStorageUcImpl
    implements EditStatusIncidenteAccidenteStorageUc<bool, dynamic> {
  EditStatusIncidenteAccidenteStorageUcImpl({
    required IncidentesAccidentesLocalRepository local,
  }) : _local = local;

  final IncidentesAccidentesLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(int id, String status) async =>
      await _local.editStatusIncidenteAccidenteFromStorage(id, status);
}
