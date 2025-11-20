import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/lista_verificacion_local_repository.dart';

abstract class SaveRegistrarResultadoStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    RegistroResultado registroResultado,
  );
}

class SaveRegistrarResultadoStorageUcImpl
    implements SaveRegistrarResultadoStorageUc<bool, dynamic> {
  SaveRegistrarResultadoStorageUcImpl(
      {required ListaVerificacionLocalRepository repository})
      : _repository = repository;

  final ListaVerificacionLocalRepository _repository;

  @override
  Future<Either<Failure, bool>> call(
    RegistroResultado registroResultado,
  ) async =>
      await _repository.saveRegistroResultadoStorage(registroResultado);
}
