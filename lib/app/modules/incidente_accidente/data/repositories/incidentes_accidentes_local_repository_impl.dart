import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/modules/incidente_accidente/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/incidente_accidente/data/models/models.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/repositories/repositories.dart';

class IncidentesAccidentesLocalRepositoryImpl
    implements IncidentesAccidentesLocalRepository {
  IncidentesAccidentesLocalRepositoryImpl({required this.localDatasource});
  final IncidentesAccidentesLocalDatasource localDatasource;

  @override
  Future<Either<Failure, bool>> deleteAllIncidentesAccidentesStorage() async {
    try {
      return Right(
          await localDatasource.deleteAllIncidentesAccidentesStorage());
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

  @override
  Future<Either<Failure, bool>> deleteIncidenteAccidenteStorage(int id) async {
    try {
      return Right(await localDatasource.deleteIncidenteAccidenteStorage(id));
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

  @override
  Future<Either<Failure, List<IncidenteAccidente>>>
      getIncidentesAccidentesFromStorage(String idSede) async {
    try {
      return Right(
          await localDatasource.getIncidentesAccidentesFromStorage(idSede));
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

  @override
  Future<Either<Failure, bool>> saveIncidenteAccidenteStorage(
    IncidenteAccidente actoCondicion,
  ) async {
    try {
      return Right(
          await localDatasource.saveIncidenteAccidenteStorage(actoCondicion));
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

  @override
  Future<Either<Failure, IncidenteAccidenteModel>>
      getIncidenteAccidenteFromStorage(String id) async {
    try {
      return Right(await localDatasource.getIncidenteAccidenteFromStorage(id));
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

  @override
  Future<Either<Failure, bool>> editIncidenteAccidenteStorage(
      IncidenteAccidente actoCondicion) async {
    try {
      return Right(await localDatasource
          .editIncidenteAccidenteFromStorage(actoCondicion));
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

  @override
  Future<Either<Failure, bool>> editStatusIncidenteAccidenteFromStorage(
      int id, String status) async {
    try {
      return Right(
        await localDatasource.editStatusIncidenteAccidenteFromStorage(
          id,
          status,
        ),
      );
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
