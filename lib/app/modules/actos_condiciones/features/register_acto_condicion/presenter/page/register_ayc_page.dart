import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/register_acto_condicion/presenter/bloc/bloc.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/register_acto_condicion/presenter/page/register_ayc_body.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

class RegisterAyCPage extends StatelessWidget {
  const RegisterAyCPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterAyCBloc(
        appController: GetIt.I<AppController>(),
        authController: GetIt.I<AuthController>(),
        saveActoCondicionStorageUc: GetIt.I<SaveActoCondicionStorageUcImpl>(),
        getAreasLocalUc: GetIt.I<GetAreasLocalUcImpl>(),
        getGerenciasLocalUc: GetIt.I<GetGerenciasLocalUcImpl>(),
        getEmpresasEspLocalUc: GetIt.I<GetEmpresasEspLocalUcImpl>(),
        getDesviacionesLocalUc: GetIt.I<GetDesviacionesLocalUcImpl>(),
        getTipoEventosLocalUc: GetIt.I<GetTipoEventosLocalUcImpl>(),
        getNivelRiesgosLocalUc: GetIt.I<GetNivelesRiesgosLocalUcImpl>(),
        getEmpleadosLocalUc: GetIt.I<GetEmpleadosLocalUcImpl>(),
      ),
      child: RegisterAyCBody(),
    );
  }
}
