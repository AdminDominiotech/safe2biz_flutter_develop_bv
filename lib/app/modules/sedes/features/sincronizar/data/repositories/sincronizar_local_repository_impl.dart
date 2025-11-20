import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

class SincronizarLocalRepositoryImpl implements SincronizarLocalRepository {
  SincronizarLocalRepositoryImpl({required this.localDatasource});
  final SincronizarLocalDatasource localDatasource;

  @override
  Future<Either<Failure, List<Area>>> getAreasFromLocal() async {
    try {
      return Right(await localDatasource.getAreasFromLocal());
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
  Future<Either<Failure, List<Desviacion>>> getDesviacionesFromLocal() async {
    try {
      return Right(await localDatasource.getDesviacionesFromLocal());
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
  Future<Either<Failure, List<Empleado>>> getEmpleadosFromLocal() async {
    try {
      return Right(await localDatasource.getEmpleadosFromLocal());
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
  Future<Either<Failure, List<EmpresaEsp>>>
      getEmpresasEspecializadasFromLocal() async {
    try {
      return Right(await localDatasource.getEmpresasEspecializadasFromLocal());
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
  Future<Either<Failure, List<Gerencia>>> getGerenciasFromLocal() async {
    try {
      return Right(await localDatasource.getGerenciasFromLocal());
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
  Future<Either<Failure, List<NivelRiesgo>>>
      getNivelesRiesgosFromLocal() async {
    try {
      return Right(await localDatasource.getNivelesRiesgosFromLocal());
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
  Future<Either<Failure, List<TipoEvento>>> getTiposEventosFromLocal() async {
    try {
      return Right(await localDatasource.getTiposEventosFromLocal());
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
      getDetallesPerdidasFromLocal() async {
    try {
      return Right(await localDatasource.getDetallesPerdidasFromLocal());
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
  Future<Either<Failure, List<PotencialPerdida>>>
      getPotencialesPerdidasFromLocal() async {
    try {
      return Right(await localDatasource.getPotencialesPerdidasFromLocal());
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
      getSubTiposReportesFromLocal() async {
    try {
      return Right(await localDatasource.getSubTiposReportesFromLocal());
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
  Future<Either<Failure, List<TipoReporte>>> getTiposReportesFromLocal() async {
    try {
      return Right(await localDatasource.getTiposReportesFromLocal());
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
  Future<Either<Failure, bool>> saveAreasToLocal(List<Area> areas) async {
    try {
      return Right(await localDatasource.saveAreasToLocal(areas));
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
  Future<Either<Failure, bool>> saveDesviacionesToLocal(
    List<Desviacion> desviaciones,
  ) async {
    try {
      return Right(
        await localDatasource.saveDesviacionesToLocal(desviaciones),
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
  Future<Either<Failure, bool>> saveEmpleadosToLocal(
    List<Empleado> empleados,
  ) async {
    try {
      return Right(await localDatasource.saveEmpleadosToLocal(empleados));
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
  Future<Either<Failure, bool>> saveEmpresasEspecializadasToLocal(
    List<EmpresaEsp> empresaEsps,
  ) async {
    try {
      return Right(
          await localDatasource.saveEmpresasEspecializadasToLocal(empresaEsps));
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
  Future<Either<Failure, bool>> saveGerenciasToLocal(
    List<Gerencia> gerencias,
  ) async {
    try {
      return Right(await localDatasource.saveGerenciasToLocal(gerencias));
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
  Future<Either<Failure, bool>> saveNivelRiesgoToLocal(
    List<NivelRiesgo> nivelRiesgos,
  ) async {
    try {
      return Right(await localDatasource.saveNivelRiesgoToLocal(nivelRiesgos));
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
  Future<Either<Failure, bool>> saveTipoEventoToLocal(
    List<TipoEvento> tipoEventos,
  ) async {
    try {
      return Right(await localDatasource.saveTipoEventoToLocal(tipoEventos));
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
  Future<Either<Failure, bool>> saveDetallesPerdidasToLocal(
      List<DetallePerdida> detallesPerdidas) async {
    try {
      return Right(
        await localDatasource.saveDetallesPerdidasToLocal(detallesPerdidas),
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
  Future<Either<Failure, bool>> savePotencialesPerdidasToLocal(
      List<PotencialPerdida> potencialPerdida) async {
    try {
      return Right(
        await localDatasource.savePotencialesPerdidasToLocal(potencialPerdida),
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
  Future<Either<Failure, List<PlanAccion>>> getSacFromLocal() async {
    try {
      return Right(await localDatasource.getSacFromLocal());
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
  Future<Either<Failure, bool>> saveSubTiposReportesToLocal(
      List<SubTipoReporte> subTipoReportes) async {
    try {
      return Right(
        await localDatasource.saveSubTiposReportesToLocal(subTipoReportes),
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
  Future<Either<Failure, bool>> saveTiposReportesToLocal(
      List<TipoReporte> tipoReportes) async {
    try {
      return Right(
        await localDatasource.saveTiposReportesToLocal(tipoReportes),
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
  Future<Either<Failure, bool>> saveSacToLocal(
      List<PlanAccion> sac, String companyId) async {
    try {
      return Right(await localDatasource.saveSacToLocal(sac, companyId));
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
  Future<Either<Failure, List<CategoriaOps>>>
      getCategoriasOpsFromLocal() async {
    try {
      return Right(await localDatasource.getCategoriasOpsFromLocal());
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
  Future<Either<Failure, List<VerificacionOps>>>
      getVerificacionesOpsFromLocal() async {
    try {
      return Right(await localDatasource.getVerificacionesOpsFromLocal());
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
  Future<Either<Failure, List<SeccionOps>>> getSeccionesOpsFromLocal() async {
    try {
      return Right(await localDatasource.getSeccionesOpsFromLocal());
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
  Future<Either<Failure, List<PreguntaOps>>> getPreguntasOpsFromLocal() async {
    try {
      return Right(await localDatasource.getPreguntasOpsFromLocal());
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
  Future<Either<Failure, List<Turno>>> getTurnosOpsFromLocal() async {
    try {
      return Right(await localDatasource.getTurnosOpsFromLocal());
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
  Future<Either<Failure, bool>> saveVerificacionesOpsToLocal(
      List<VerificacionOps> verificacionOps) async {
    try {
      return Right(
          await localDatasource.saveVerificacionesOpsToLocal(verificacionOps));
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
  Future<Either<Failure, bool>> saveCategoriasOpsToLocal(
      List<CategoriaOps> categoriaOps) async {
    try {
      return Right(
          await localDatasource.saveCategoriasOpsToLocal(categoriaOps));
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
  Future<Either<Failure, bool>> saveSeccionesOpsToLocal(
      List<SeccionOps> seccionOps) async {
    try {
      return Right(await localDatasource.saveSeccionesOpsToLocal(seccionOps));
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
  Future<Either<Failure, bool>> savePreguntasOpsToLocal(
      List<PreguntaOps> preguntaOps) async {
    try {
      return Right(await localDatasource.savePreguntasOpsToLocal(preguntaOps));
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
  Future<Either<Failure, bool>> saveTurnosOpsToLocal(List<Turno> turnos) async {
    try {
      return Right(await localDatasource.saveTurnoOpsToLocal(turnos));
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
  Future<Either<Failure, List<ResultadoOps>>> getResultadoOpsFromLocal() async {
    try {
      return Right(await localDatasource.getResultadoOpsFromLocal());
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
  Future<Either<Failure, bool>> saveResultadoOpsToLocal(
    List<ResultadoOps> resultadoOps,
  ) async {
    try {
      return Right(await localDatasource.saveResultadoOpsToLocal(resultadoOps));
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
  Future<Either<Failure, int>> updatePreguntasByRegistroGeneralOpsFromLocal(
      String idGeneral, String idVerificacion) async {
    try {
      return Right(
          await localDatasource.updatePreguntasByRegistroGeneralOpsFromLocal(
              idGeneral, idVerificacion));
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
