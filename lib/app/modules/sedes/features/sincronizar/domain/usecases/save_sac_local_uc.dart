import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveSacLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<PlanAccion> sac, String companyId);
}

class SaveSacLocalUcImpl implements SaveSacLocalUc<bool, dynamic> {
  SaveSacLocalUcImpl({required SincronizarLocalRepository repository})
      : _repository = repository;

  final SincronizarLocalRepository _repository;

  @override
  Future<Either<Failure, bool>> call(List<PlanAccion> sac, String companyId) async =>
      await _repository.saveSacToLocal(sac, companyId);
}
