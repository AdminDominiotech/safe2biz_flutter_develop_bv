import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/register_incidente_accidente/presenter/bloc/bloc.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/register_incidente_accidente/presenter/page/register_inc_body.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

class RegisterINCPage extends StatelessWidget {
  const RegisterINCPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterINCBloc(
        appController: GetIt.I<AppController>(),
        authController: GetIt.I<AuthController>(),
        saveIncidenteAccidenteStorageUc:
            GetIt.I<SaveIncidenteAccidenteStorageUcImpl>(),
        getTipoReportesLocalUc: GetIt.I<GetTipoReportesLocalUcImpl>(),
        getSubTipoReportesLocalUc: GetIt.I<GetSubTipoReportesLocalUcImpl>(),
        getDetallesPerdidasLocalUc: GetIt.I<GetDetallesPerdidasLocalUcImpl>(),
        getPotencialesPerdidasLocalUc:
            GetIt.I<GetPotencialesPerdidasLocalUcImpl>(),
        getAreasLocalUc: GetIt.I<GetAreasLocalUcImpl>(),
        getGerenciasLocalUc: GetIt.I<GetGerenciasLocalUcImpl>(),
      )..add(
          InitEv(),
        ),
      child: RegisterINCBody(),
    );
  }
}
