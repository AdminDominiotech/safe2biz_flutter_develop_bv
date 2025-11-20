import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/planes_accion/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';

class PlanesAccionApiRepositoryImpl implements PlanesAccionApiRepository {
  PlanesAccionApiRepositoryImpl({required this.remoteDatasource});
  final PlanesAccionApiDatasource remoteDatasource;

  @override
  Future<Either<Failure, bool>> savePlanAccion(
      PlanAccion planAccion, String userId) async {
    try {
      return Right(
          await remoteDatasource.savePlanesAccionApi(planAccion, userId));
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

  /*@override
  Future<Either<Failure, bool>> savePlanesAccion(
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
  }*/

}
