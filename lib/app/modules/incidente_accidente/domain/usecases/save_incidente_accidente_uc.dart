import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/repositories/repositories.dart';

abstract class SaveIncidenteAccidenteUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    IncidenteAccidente incidenteAccidente,
  );
}

class SaveIncidenteAccidenteUcImpl
    implements SaveIncidenteAccidenteUc<bool, dynamic> {
  SaveIncidenteAccidenteUcImpl(
      {required IncidentesAccidentesApiRepository repository})
      : _repository = repository;

  final IncidentesAccidentesApiRepository _repository;

  @override
  Future<Either<Failure, bool>> call(
    IncidenteAccidente incidenteAccidente,
  ) async =>
      await _repository.saveIncidentesAccidentes(incidenteAccidente);
}

