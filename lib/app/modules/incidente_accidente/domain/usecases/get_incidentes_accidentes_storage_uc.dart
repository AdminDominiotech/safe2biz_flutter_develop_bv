import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/repositories/repositories.dart';

abstract class GetIncidentesAccidentesStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(String idSede);
}

class GetIncidentesAccidentesStorageUcImpl
    implements
        GetIncidentesAccidentesStorageUc<List<IncidenteAccidente>, dynamic> {
  GetIncidentesAccidentesStorageUcImpl({
    required IncidentesAccidentesLocalRepository local,
  }) : _local = local;

  final IncidentesAccidentesLocalRepository _local;

  @override
  Future<Either<Failure, List<IncidenteAccidente>>> call(String idSede) async =>
      await _local.getIncidentesAccidentesFromStorage(idSede);
}
