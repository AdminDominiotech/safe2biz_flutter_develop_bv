import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/modules/sedes/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/domain/repositories/repositories.dart';

class SedeApiRepositoryImpl implements SedeApiRepository {
  SedeApiRepositoryImpl({required this.remoteDatasource});
  final SedeApiDatasource remoteDatasource;

  @override
  Future<Either<Failure, List<Sede>>> getSedesFromApi(String userId) async {
    try {
      return Right(await remoteDatasource.getSedesFromApi(userId));
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
