import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';

abstract class ListaVerificacionApiRepository {
  Future<Either<Failure, bool>> savePlanAccion(
    RegistroGeneral registroGeneral,
    String userId,
    String idSede,
  );

  Future<Either<Failure, bool>> saveRegistrosGenerales(
    RegistroGeneral registroGeneral,
    String userId,
    String idSede,
  );
  Future<Either<Failure, bool>> saveRegistrosResultado(
    RegistroResultado registroResultado,
    String userId,
    String idSede,
  );
}
