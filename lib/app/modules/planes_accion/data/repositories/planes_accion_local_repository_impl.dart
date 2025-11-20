import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/planes_accion/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/planes_accion/data/models/models.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';

class PlanesAccionLocalRepositoryImpl implements PlanesAccionLocalRepository {
  PlanesAccionLocalRepositoryImpl({required this.remoteDatasource});
  final PlanesAccionLocalDatasource remoteDatasource;

  @override
  Future<Either<Failure, List<PlanesAccionModel>>> getPlanesAccionFromStorage(
      String sedeId) async {
    try {
      return Right(await remoteDatasource.getPlanesAccionFromStorage(sedeId));
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
  Future<Either<Failure, bool>> editPlanAccionStorage(
      PlanAccion planAccion) async {
    try {
      return Right(
          await remoteDatasource.editPlanAccionFromStorage(planAccion));
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
  Future<Either<Failure, bool>> deleteAllPlanesAccionStorage() async {
    try {
      return Right(await remoteDatasource.deleteAllPlanesAccionStorage());
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
  Future<Either<Failure, bool>> deletePlanAccionStorage(String id) async {
    try {
      return Right(await remoteDatasource.deletePlanAccionStorage(id));
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
  Future<Either<Failure, bool>> editStatusPlanAccionFromStorage(
      String id, String status) async {
    try {
      return Right(
        await remoteDatasource.editStatusPlanAccionFromStorage(
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
