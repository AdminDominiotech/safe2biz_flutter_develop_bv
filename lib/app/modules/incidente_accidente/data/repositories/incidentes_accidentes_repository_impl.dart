import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/modules/incidente_accidente/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/repositories/repositories.dart';

class IncidentesAccidentesApiRepositoryImpl
    implements IncidentesAccidentesApiRepository {
  IncidentesAccidentesApiRepositoryImpl({required this.remoteDatasource});
  final IncidentesAccidentesApiDatasource remoteDatasource;

  @override
  Future<Either<Failure, bool>> saveIncidentesAccidentes(
      IncidenteAccidente incidenteAccidente) async {
    try {
      return Right(
          await remoteDatasource.saveIncidenteAccidenteApi(incidenteAccidente));
    } on ServerException catch (err) {
      return Left(
        ServerFailure(
          message: err.toString(),
        ),
      );
    } catch (error) {
      return const Left(
        AppException(),
      );
    }
  }
}
