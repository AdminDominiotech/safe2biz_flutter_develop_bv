import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveNivelRiesgosLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<NivelRiesgo> niveleRiesgos);
}

class SaveNivelRiesgosLocalUcImpl
    implements SaveNivelRiesgosLocalUc<bool, dynamic> {
  SaveNivelRiesgosLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(List<NivelRiesgo> niveleRiesgos) async =>
      await _local.saveNivelRiesgoToLocal(niveleRiesgos);
}
