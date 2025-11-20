import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveEmpresasEspLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<EmpresaEsp> empresas);
}

class SaveEmpresasEspLocalUcImpl
    implements SaveEmpresasEspLocalUc<bool, dynamic> {
  SaveEmpresasEspLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(List<EmpresaEsp> empresas) async =>
      await _local.saveEmpresasEspecializadasToLocal(empresas);
}
