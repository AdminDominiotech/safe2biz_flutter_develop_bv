import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/modules/sedes/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/domain/repositories/repositories.dart';

class SedeLocalRepositoryImpl implements SedeLocalRepository {
  SedeLocalRepositoryImpl({required this.remoteDatasource});
  final SedeLocalDatasource remoteDatasource;

  @override
  Future<Either<Failure, List<Sede>>> getSedesFromStorage() async {
    try {
      return Right(await remoteDatasource.getSedesFromStorage());
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
  Future<Either<Failure, bool>> saveSedesStorage(
    List<Sede> sedes,
  ) async {
    try {
      return Right(await remoteDatasource.saveSedesStorage(sedes));
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
