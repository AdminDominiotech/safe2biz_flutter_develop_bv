import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/modules/epp/data/models/EntregaApiDatasource.dart';
import 'package:safe2biz/app/modules/epp/data/models/entrega_repository.dart';

class EntregaApiRepositoryImpl
    implements EntregaApiRepository {
  EntregaApiRepositoryImpl({required this.remoteDatasource});
  final EntregaApiDatasource remoteDatasource;

  @override
  Future<Either<Failure, bool>> saveEntregas() async {
    try {
      return Right(
          await remoteDatasource.
          saveEntregaApi() );
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