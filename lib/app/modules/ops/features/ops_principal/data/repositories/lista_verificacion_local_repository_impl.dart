import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/registro_general.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/registro_resultado.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/lista_verificacion_local_repository.dart';

class ListaVerificacionLocalRepositoryImpl
    implements ListaVerificacionLocalRepository {
  ListaVerificacionLocalRepositoryImpl({required this.remoteDatasource});
  final ListaVerificacionLocalDatasource remoteDatasource;

  @override
  Future<Either<Failure, bool>> deleteAllListaVerificacionStorage() {
    // TODO: implement deleteAllListaVerificacionStorage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteListaVerificacionStorage(String id) {
    // TODO: implement deleteListaVerificacionStorage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> editListaVerificacionFromStorage(
      RegistroGeneral registroGeneral) async {
    try {
      return Right(await remoteDatasource
          .editListaVerificacionFromStorage(registroGeneral));
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
  Future<Either<Failure, bool>> editStatusListaVerificacionFromStorage(
      String id, String status) {
    // TODO: implement editStatusListaVerificacionFromStorage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<RegistroGeneral>>>
      getListaVerificacionFromStorage(
          String sedeId, String idListaVerificacion) async {
    try {
      return Right(await remoteDatasource.getListaVerificacionFromStorage(
          sedeId, idListaVerificacion));
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
  Future<Either<Failure, int>> saveListaVerificacionStorage(
      RegistroGeneral registroGeneral) async {
    try {
      return Right(
          await remoteDatasource.saveListaVerificacionStorage(registroGeneral));
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
  Future<Either<Failure, bool>> saveRegistroResultadoStorage(
      RegistroResultado registroResultado) async {
    try {
      return Right(await remoteDatasource
          .saveRegistroResultadoStorage(registroResultado));
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
  Future<Either<Failure, bool>> editRegistroResultadoFromStorage(
      RegistroResultado registroResultado) async {
    try {
      return Right(
        await remoteDatasource
            .editRegistroResultadoFromStorage(registroResultado),
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
  Future<Either<Failure, RegistroResultado>> getRegistroResultadoFromStorage(
    String idGenerales,
    String idCategoria,
    String idSeccion,
    String idPregunta,
  ) async {
    try {
      return Right(
        await remoteDatasource.getRegistroResultadoFromStorage(
          idGenerales,
          idCategoria,
          idSeccion,
          idPregunta,
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
  Future<Either<Failure, List<RegistroResultado>>>
      getRegistroResultadoByIdGeneralFromStorage(String idGenerales) async {
    try {
      return Right(
        await remoteDatasource.getRegistroResultadoByIdGeneralFromStorage(
          idGenerales,
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
  Future<Either<Failure, bool>> editStatusRegistroGeneralesFromStorage(
      int id, String status) async {
    try {
      return Right(
        await remoteDatasource.editStatusRegistroGeneralesFromStorage(
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

  @override
  Future<Either<Failure, bool>> editStatusRegistroResultadoFromStorage(
    int id,
    String status,
  ) async {
    try {
      return Right(
        await remoteDatasource.editStatusRegistroResultadoFromStorage(
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

  @override
  Future<Either<Failure, bool>> deleteRegistroGeneralFromStorage(
    int id,
  ) async {
    try {
      return Right(
        await remoteDatasource.deleteRegistroGeneralFromStorage(
          id,
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
  Future<Either<Failure, bool>> deleteRegistroResultadoFromStorage(
    String id,
  ) async {
    try {
      return Right(
        await remoteDatasource.deleteRegistroResultadoFromStorage(
          id,
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
