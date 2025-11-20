import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';

abstract class IncidentesAccidentesLocalRepository {
  Future<Either<Failure, List<IncidenteAccidente>>>
      getIncidentesAccidentesFromStorage(String idSede);
  Future<Either<Failure, IncidenteAccidente>> getIncidenteAccidenteFromStorage(
    String id,
  );
  Future<Either<Failure, bool>> saveIncidenteAccidenteStorage(
    IncidenteAccidente incidenteAccidente,
  );
  Future<Either<Failure, bool>> editIncidenteAccidenteStorage(
    IncidenteAccidente incidenteAccidente,
  );
  Future<Either<Failure, bool>> deleteAllIncidentesAccidentesStorage();
  Future<Either<Failure, bool>> editStatusIncidenteAccidenteFromStorage(
    int id,
    String status,
  );
  Future<Either<Failure, bool>> deleteIncidenteAccidenteStorage(int id);
}
