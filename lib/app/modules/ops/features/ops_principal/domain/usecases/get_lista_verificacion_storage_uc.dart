import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/registro_general.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/repositories.dart';

abstract class GetListaVerificacionStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(String id, String idListaVerificacion);
}

class GetListaVerificacionStorageUcImpl
    implements GetListaVerificacionStorageUc<List<RegistroGeneral>, dynamic> {
  GetListaVerificacionStorageUcImpl({
    required ListaVerificacionLocalRepository repository,
  }) : _repository = repository;

  final ListaVerificacionLocalRepository _repository;

  @override
  Future<Either<Failure, List<RegistroGeneral>>> call(
          String id, String idListaVerificacion) async =>
      await _repository.getListaVerificacionFromStorage(
          id, idListaVerificacion);
}
