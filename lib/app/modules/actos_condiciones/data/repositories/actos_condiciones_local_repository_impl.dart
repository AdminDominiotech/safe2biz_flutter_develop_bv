import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/models/acto_condicion_model.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';

class ActosCondicionesLocalRepositoryImpl
    implements ActosCondicionesLocalRepository {
  ActosCondicionesLocalRepositoryImpl({required this.remoteDatasource});
  final ActosCondicionesLocalDatasource remoteDatasource;

  @override
  Future<Either<Failure, bool>> deleteAllActosCondicionesStorage() async {
    try {
      return Right(await remoteDatasource.deleteAllActosCondicionesStorage());
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
  Future<Either<Failure, bool>> deleteActoCondicionStorage(int id) async {
    try {
      return Right(await remoteDatasource.deleteActoCondicionStorage(id));
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
  Future<Either<Failure, List<ActoCondicion>>>
      getActosCondicionesFromStorage(String idSede) async {
    try {
      return Right(await remoteDatasource.getActosCondicionesFromStorage(idSede));
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
  Future<Either<Failure, bool>> saveActoCondicionStorage(
    ActoCondicion actoCondicion,
  ) async {
    try {
      return Right(
          await remoteDatasource.saveActoCondicionStorage(actoCondicion));
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
  Future<Either<Failure, ActoCondicionModel>> getActoCondicionFromStorage(
      String id) async {
    try {
      return Right(await remoteDatasource.getActoCondicionFromStorage(id));
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
  Future<Either<Failure, bool>> editActoCondicionStorage(
      ActoCondicion actoCondicion) async {
    try {
      return Right(
          await remoteDatasource.editActoCondicionFromStorage(actoCondicion));
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
  Future<Either<Failure, bool>> editStatusActoCondicionFromStorage(
      int id, String status) async {
    try {
      return Right(
        await remoteDatasource.editStatusActoCondicionFromStorage(
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
