import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/resultado_ops.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/seccion_ops.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/pregunta_ops.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/categoria_ops.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/tipo_reporte.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/sub_tipo_reporte.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/potencial_perdida.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/detalle_perdida.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/sac.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/turno.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/verificacion_ops.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

class SincronizarRepositoryImpl implements SincronizarApiRepository {
  SincronizarRepositoryImpl({required this.remoteDatasource});
  final SincronizarApiDatasource remoteDatasource;

  @override
  Future<Either<Failure, List<AreaModel>>> getAreasFromApi() async {
    try {
      return Right(await remoteDatasource.getAreasFromApi());
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
  Future<Either<Failure, List<DesviacionModel>>>
      getDesviacionesFromApi() async {
    try {
      return Right(await remoteDatasource.getDesviacionesFromApi());
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
  Future<Either<Failure, List<EmpleadoModel>>> getEmpleadosFromApi(
      String userId) async {
    try {
      return Right(await remoteDatasource.getEmpleadosFromApi(userId));
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
  Future<Either<Failure, List<EmpresaEspModel>>>
      getEmpresasEspecializadasFromApi() async {
    try {
      return Right(
        await remoteDatasource.getEmpresasEspecializadasFromApi(),
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
  Future<Either<Failure, List<GerenciaModel>>> getGerenciasFromApi() async {
    try {
      return Right(await remoteDatasource.getGerenciasFromApi());
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
  Future<Either<Failure, List<NivelRiesgoModel>>>
      getNivelRiesgoFromApi() async {
    try {
      return Right(await remoteDatasource.getNivelRiesgoFromApi());
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
  Future<Either<Failure, List<TipoEventoModel>>> getTipoEventoFromApi() async {
    try {
      return Right(await remoteDatasource.getTipoEventoFromApi());
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
  Future<Either<Failure, List<DetallePerdida>>>
      getDetallesPerdidasFromApi() async {
    try {
      return Right(await remoteDatasource.getDetallesPerdidasFromApi());
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
  Future<Either<Failure, List<PlanAccion>>> getSacFromApi(
      String companyId, String userId) async {
    try {
      return Right(await remoteDatasource.getSacFromApi(companyId, userId));
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

  // @override
  // Future<Either<Failure, List<CompanyModel>>> getCompany(String userId) async {
  //   try {
  //     return Right(await remoteDatasource.getCompaniesFromApi(userId));
  //   } on ServerException catch (err) {
  //     return Left(
  //       ServerFailure(
  //         message: err.toString(),
  //       ),
  //     );
  //   } catch (error) {
  //     return const Left(
  //       AppException(),
  //     );
  //   }
  // }

  @override
  Future<Either<Failure, List<PotencialPerdida>>>
      getPotencialesPerdidasFromApi() async {
    try {
      return Right(await remoteDatasource.getPotencialesPerdidasFromApi());
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
  Future<Either<Failure, List<SubTipoReporte>>>
      getSubTiposReportesFromApi() async {
    try {
      return Right(await remoteDatasource.getSubTiposReportesFromApi());
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
  Future<Either<Failure, List<TipoReporte>>> getTiposReportesFromApi() async {
    try {
      return Right(await remoteDatasource.getTiposReportesFromApi());
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
  Future<Either<Failure, List<CategoriaOps>>> getCategoriasOpsFromApi(
      String userLogin) async {
    try {
      return Right(await remoteDatasource.getCategoriasOpsFromApi(userLogin));
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
  Future<Either<Failure, List<PreguntaOps>>> getPreguntasOpsFromApi(
      String userLogin) async {
    try {
      return Right(await remoteDatasource.getPreguntasOpsFromApi(userLogin));
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
  Future<Either<Failure, List<SeccionOps>>> getSeccionesOpsFromApi(
      String userLogin) async {
    try {
      return Right(await remoteDatasource.getSeccionesOpsFromApi(userLogin));
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
  Future<Either<Failure, List<VerificacionOps>>> getVerificacionesOpsFromApi(
      String userLogin) async {
    try {
      return Right(
          await remoteDatasource.getVerificacionesOpsFromApi(userLogin));
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
  Future<Either<Failure, List<Turno>>> getTurnoOpsFromApi() async {
    try {
      return Right(await remoteDatasource.getTurnoOpsFromApi());
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
  Future<Either<Failure, List<ResultadoOps>>> getResultadoOpsFromApi() async {
    try {
      return Right(await remoteDatasource.getResultadoOpsFromApi());
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
