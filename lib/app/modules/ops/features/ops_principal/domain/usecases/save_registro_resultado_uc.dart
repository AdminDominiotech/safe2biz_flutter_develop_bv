import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/repositories.dart';

abstract class SaveRegistroResultadoUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    RegistroResultado registroResultado,
    String userId,
    String idSede,
  );
}

class SaveRegistroResultadoUcImpl
    implements SaveRegistroResultadoUc<bool, dynamic> {
  SaveRegistroResultadoUcImpl({
    required ListaVerificacionApiRepository repository,
  }) : _repository = repository;

  final ListaVerificacionApiRepository _repository;

  @override
  Future<Either<Failure, bool>> call(
    RegistroResultado registroResultado,
    String userId,
    String idSede,
  ) async =>
      await _repository.saveRegistrosResultado(
        registroResultado,
        userId,
        idSede,
      );
}
