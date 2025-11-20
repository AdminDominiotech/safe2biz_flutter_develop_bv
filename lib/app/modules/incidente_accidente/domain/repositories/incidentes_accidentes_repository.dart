import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';

abstract class IncidentesAccidentesApiRepository {
  Future<Either<Failure, bool>> saveIncidentesAccidentes(
    IncidenteAccidente incidenteAccidente,
  );
}
