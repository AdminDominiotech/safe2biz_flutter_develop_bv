import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/detail_acto_condicion/presenter/bloc/detail_ayc_bloc.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/detail_acto_condicion/presenter/page/detail_ayc_body.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

class DetailAyCPage extends StatelessWidget {
  const DetailAyCPage({
    Key? key,
    required this.actoCondicion,
  }) : super(key: key);

  final ActoCondicion actoCondicion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailAycBloc(
        appController: GetIt.I<AppController>(),
        authController: GetIt.I<AuthController>(),
        saveActoCondicionUc: GetIt.I<SaveActoCondicionUcImpl>(),
        getAreasLocalUc: GetIt.I<GetAreasLocalUcImpl>(),
        getGerenciasLocalUc: GetIt.I<GetGerenciasLocalUcImpl>(),
        getEmpresasEspLocalUc: GetIt.I<GetEmpresasEspLocalUcImpl>(),
        getDesviacionesLocalUc: GetIt.I<GetDesviacionesLocalUcImpl>(),
        getTipoEventosLocalUc: GetIt.I<GetTipoEventosLocalUcImpl>(),
        getNivelRiesgosLocalUc: GetIt.I<GetNivelesRiesgosLocalUcImpl>(),
        getEmpleadosLocalUc: GetIt.I<GetEmpleadosLocalUcImpl>(),
        editActoCondicionStorageUc: GetIt.I<EditActoCondicionStorageUcImpl>(),
        deleteActoCondicionStorageUc:
            GetIt.I<DeleteActoCondicionStorageUcImpl>(),
        editStatusActoCondicionStorageUc:
            GetIt.I<EditStatusActoCondicionStorageUcImpl>(),
      ),
      // ..add(
      //     InitEv(actoCondicion: actoCondicion),
      //   ),
      child: DetailAyCBody(actoCondicion: actoCondicion),
    );
  }
}
