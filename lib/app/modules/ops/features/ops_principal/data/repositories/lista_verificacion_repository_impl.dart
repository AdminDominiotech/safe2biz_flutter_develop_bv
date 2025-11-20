import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/datasource/api/lista_verificacion_api_datasource.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/registro_general.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/registro_resultado.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/lista_verificacion_repository.dart';

class ListaVerificacionApiRepositoryImpl
    implements ListaVerificacionApiRepository {
  ListaVerificacionApiRepositoryImpl({required this.remoteDatasource});
  final ListaVerificacionApiDatasource remoteDatasource;

  @override
  Future<Either<Failure, bool>> savePlanAccion(
    RegistroGeneral registroGeneral,
    String userId,
    String idSede,
  ) {
    // TODO: implement savePlanAccion
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> saveRegistrosGenerales(
    RegistroGeneral registroGeneral,
    String userId,
    String idSede,
  ) async {
    try {
      return Right(
        await remoteDatasource.saveRegistrosGeneralesApi(
          registroGeneral,
          userId,
          idSede,
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

  @override
  Future<Either<Failure, bool>> saveRegistrosResultado(
    RegistroResultado registroResultado,
    String userId,
    String idSede,
  ) async {
    try {
      return Right(
        await remoteDatasource.saveRegistrosResultadoApi(
          registroResultado,
          userId,
          idSede,
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
