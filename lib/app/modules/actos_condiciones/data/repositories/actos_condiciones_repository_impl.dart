import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';

class ActosCondicionesApiRepositoryImpl
    implements ActosCondicionesApiRepository {
  ActosCondicionesApiRepositoryImpl({required this.remoteDatasource});
  final ActosCondicionesApiDatasource remoteDatasource;

  @override
  Future<Either<Failure, bool>> saveActosCondiciones(
      ActoCondicion actoCondicion) async {
    try {
      return Right(await remoteDatasource.saveActoCondicionApi(actoCondicion));
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
