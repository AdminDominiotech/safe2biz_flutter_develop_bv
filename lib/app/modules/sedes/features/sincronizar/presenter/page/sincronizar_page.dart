import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/bloc/sincronizar_bloc.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/page/sincronizar_body.dart';

class SincronizarPage extends StatelessWidget {
  const SincronizarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SincronizarBloc(
        getEmpleadosUc: GetIt.I<GetEmpleadosUcImpl>(),
        getDesviacionesUc: GetIt.I<GetDesviacionesUcImpl>(),
        getGerenciasUc: GetIt.I<GetGerenciasUcImpl>(),
        getAreasUc: GetIt.I<GetAreasUcImpl>(),
        getTipoEventosUc: GetIt.I<GetTipoEventosUcImpl>(),
        getNivelesRiesgosUc: GetIt.I<GetNivelesRiesgosUcImpl>(),
        getEmpresasEspUc: GetIt.I<GetEmpresasEspUcImpl>(),
        getTipoReportesUc: GetIt.I<GetTipoReportesUcImpl>(),
        getSubTipoReportesUc: GetIt.I<GetSubTipoReportesUcImpl>(),
        getDetallesPerdidasUc: GetIt.I<GetDetallesPerdidasUcImpl>(),
        getPotencialesPerdidasUc: GetIt.I<GetPotencialesPerdidasUcImpl>(),
        getCategoriasOpsUc: GetIt.I<GetCategoriasOpsUcImpl>(),
        getPreguntasOpsUc: GetIt.I<GetPreguntasOpsUcImpl>(),
        getTurnoOpsUc: GetIt.I<GetTurnoOpsUcImpl>(),
        getSeccionesOpsUc: GetIt.I<GetSeccionesOpsUcImpl>(),
        getVerificacionesOpsUc: GetIt.I<GetVerificacionesOpsUcImpl>(),
        saveAreasLocalUc: GetIt.I<SaveAreasLocalUcImpl>(),
        saveDesviacionesLocalUc: GetIt.I<SaveDesviacionesLocalUcImpl>(),
        saveGerenciasLocalUc: GetIt.I<SaveGerenciasLocalUcImpl>(),
        saveEmpresasEspLocalUc: GetIt.I<SaveEmpresasEspLocalUcImpl>(),
        saveNivelRiesgosUc: GetIt.I<SaveNivelRiesgosLocalUcImpl>(),
        saveEmpleadosLocalUc: GetIt.I<SaveEmpleadosLocalUcImpl>(),
        saveTipoEventosLocalUc: GetIt.I<SaveTipoEventosLocalUcImpl>(),
        saveTipoReportesLocalUc: GetIt.I<SaveTipoReportesLocalUcImpl>(),
        saveSubTipoReportesLocalUc: GetIt.I<SaveSubTipoReportesLocalUcImpl>(),
        saveDetallesPerdidasLocalUc: GetIt.I<SaveDetallesPerdidasLocalUcImpl>(),
        savePotencialesPerdidasLocalUc:
            GetIt.I<SavePotencialesPerdidasLocalUcImpl>(),
        getNivelesRiesgosLocalUc: GetIt.I<GetNivelesRiesgosLocalUcImpl>(),
        getSacUc: GetIt.I<GetSacUcImpl>(),
        getResultadosOpsUc: GetIt.I<GetResultadosOpsUcImpl>(),
        saveSacLocalUc: GetIt.I<SaveSacLocalUcImpl>(),
        saveCategoriasOpsLocalUc: GetIt.I<SaveCategoriasOpsLocalUcImpl>(),
        saveSeccionesOpsLocalUc: GetIt.I<SaveSeccionesOpsLocalUcImpl>(),
        saveVerificacionesOpsLocalUc:
            GetIt.I<SaveVerificacionesOpsLocalUcImpl>(),
        savePreguntasOpsLocalUc: GetIt.I<SavePreguntasOpsLocalUcImpl>(),
        saveTurnosOpsLocalUc: GetIt.I<SaveTurnosOpsLocalUcImpl>(),
        saveResultadosOpsLocalUc: GetIt.I<SaveResultadosOpsLocalUcImpl>(),
        authController: GetIt.I<AuthController>(),




      )..add(InitEv()),
      child: SincronizarBody(),
    );
  }
}
