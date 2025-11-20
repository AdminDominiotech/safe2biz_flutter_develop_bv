import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';

abstract class ListaVerificacionLocalRepository {
  Future<Either<Failure, List<RegistroGeneral>>>
      getListaVerificacionFromStorage(
    String sedeId,
    String idListaVerificacion,
  );
  Future<Either<Failure, bool>> editListaVerificacionFromStorage(
      RegistroGeneral registroGeneral);
  Future<Either<Failure, bool>> editStatusListaVerificacionFromStorage(
      String id, String status);
  Future<Either<Failure, bool>> deleteListaVerificacionStorage(String id);
  Future<Either<Failure, bool>> deleteAllListaVerificacionStorage();
  Future<Either<Failure, int>> saveListaVerificacionStorage(
    RegistroGeneral registroGeneral,
  );
  Future<Either<Failure, bool>> saveRegistroResultadoStorage(
    RegistroResultado registroResultado,
  );
  Future<Either<Failure, RegistroResultado>> getRegistroResultadoFromStorage(
    String idGenerales,
    String idCategoria,
    String idSeccion,
    String idPregunta,
  );
  Future<Either<Failure, List<RegistroResultado>>>
      getRegistroResultadoByIdGeneralFromStorage(
    String idGenerales,
  );
  Future<Either<Failure, bool>> editRegistroResultadoFromStorage(
    RegistroResultado registroResultado,
  );

  Future<Either<Failure, bool>> editStatusRegistroGeneralesFromStorage(
    int id,
    String status,
  );
  Future<Either<Failure, bool>> editStatusRegistroResultadoFromStorage(
    int id,
    String status,
  );

  Future<Either<Failure, bool>> deleteRegistroGeneralFromStorage(int id);
  Future<Either<Failure, bool>> deleteRegistroResultadoFromStorage(String id);
}
