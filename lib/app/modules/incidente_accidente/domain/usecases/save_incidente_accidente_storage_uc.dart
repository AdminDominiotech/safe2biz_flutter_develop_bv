import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/repositories/repositories.dart';

abstract class SaveIncidenteAccidenteStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    IncidenteAccidente actoCondicion,
  );
}

class SaveIncidenteAccidenteStorageUcImpl
    implements SaveIncidenteAccidenteStorageUc<bool, dynamic> {
  SaveIncidenteAccidenteStorageUcImpl({
    required IncidentesAccidentesLocalRepository local,
  }) : _local = local;

  final IncidentesAccidentesLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
    IncidenteAccidente incidenteAccidente,
  ) async =>
      await _local.saveIncidenteAccidenteStorage(incidenteAccidente);
}
