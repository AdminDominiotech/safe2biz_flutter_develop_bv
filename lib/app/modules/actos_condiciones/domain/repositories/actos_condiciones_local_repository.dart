import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/models/acto_condicion_model.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class ActosCondicionesLocalRepository {
  Future<Either<Failure, List<ActoCondicion>>> getActosCondicionesFromStorage(
      String idSede);
  Future<Either<Failure, ActoCondicionModel>> getActoCondicionFromStorage(
    String id,
  );
  Future<Either<Failure, bool>> saveActoCondicionStorage(
    ActoCondicion actoCondicion,
  );
  Future<Either<Failure, bool>> editActoCondicionStorage(
    ActoCondicion actoCondicion,
  );
  Future<Either<Failure, bool>> deleteAllActosCondicionesStorage();
  Future<Either<Failure, bool>> editStatusActoCondicionFromStorage(
    int id,
    String status,
  );
  //TODO: ERROR
  Future<Either<Failure, bool>> deleteActoCondicionStorage(int id);
}
