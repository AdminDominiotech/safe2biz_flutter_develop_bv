import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetEmpresasEspLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetEmpresasEspLocalUcImpl
    implements GetEmpresasEspLocalUc<List<EmpresaEsp>, dynamic> {
  GetEmpresasEspLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<EmpresaEsp>>> call() async =>
      await _local.getEmpresasEspecializadasFromLocal();
}
