import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/controllers/settings_controller.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/auth/features/login/presenter/page/page.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/sedes/presenter/page/sede_page.dart';
import 'package:safe2biz/app/modules/splash/presenter/bloc/bloc.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/global/core/routing/routing.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({Key? key}) : super(key: key);

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {

  SqlDb sqlDb = SqlDb();

  final apiEntrega = ApiEntregaEpp();

  @override
  void initState(){
    super.initState();
    asyncMethod();
  }


  void asyncMethod() async{
    /*Check registers*/
    List<Map> responseRead = await sqlDb.readData(""
        "SELECT * FROM EmpleadoMina");
    print("Tabla producto_empleado_mina --> $responseRead");

    if(responseRead.isEmpty){
      apiEntrega.getAllEmp();
      apiEntrega.getAllProd();
      apiEntrega.getExamenMedicoEmp();
      apiEntrega.getEnfermedadesEmp();
      apiEntrega.getCapacitacionEmp();

      /*
      apiEntrega.RequestRolExpositorCapacitacion();
      apiEntrega.RequestModalidadCapacitacion();
      apiEntrega.RequestEstadoCursoCapacitacion();
      */

    }else {
      print("=== Ya hubo sincronización ====");
    }

    /*
    //Check Table
    List<Map> responseReadTable = await sqlDb.readData(""
        "SELECT * FROM productoMina");
    print("Tabla productoMina --> $responseReadTable");

    if(responseReadTable.isEmpty){
      apiEntrega.getAllEmp();
      apiEntrega.getAllProd();
      apiEntrega.getExamenMedicoEmp();
      apiEntrega.getEnfermedadesEmp();
      apiEntrega.getCapacitacionEmp();

      /*
      apiEntrega.RequestRolExpositorCapacitacion();
      apiEntrega.RequestModalidadCapacitacion();
      apiEntrega.RequestEstadoCursoCapacitacion();
       */

    }else {
      print("=== Ya hubo sincronización ====");
    }
    */


  }

  @override
  Widget build(BuildContext context) {
    SqlDb sqlDb = SqlDb();
    void asyncMethod() async{
      final apiEntrega = ApiEntregaEpp();

      await apiEntrega.RequestPlanAccion('2020');
      await apiEntrega.RequestDataIndFrecuenciaMTI('2020');

      Future.delayed(const Duration(milliseconds: 500), () {
      });








    }


    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) async {
        if (state is Successful) {
          final header = GetIt.I<DioMicroServices>().msDio.options.headers;
          GetIt.I<DioMicroServices>().msDio.options.headers = {
            ...header,
            'userLogin': '${state.user.userLogin}@${state.user.enterprise}',
            'userPassword': state.user.password,
            'systemRoot': 'safe2biz',
          };

          final auth = GetIt.I<AuthController>();
          String user = '';
          String pass = '';

          if (auth.user.value != null) {
            user = auth.user.value!.userLogin;
            pass = auth.user.value!.password;
          }

          Navigator.of(context).pushReplacement(
            FadePageRoute(
              newPage: LoginPage(user: user, pass: pass,),
              //    newPage:  CompanyBodyIntra(user_login: '${state.user.userLogin}', user_id: '${state.user.uuid}' ,),
            ),
          );
        }
        if (state is FailureNotHaveSetting) {

          Toast.show(
            description: state.error,
            toastType: ToastType.warning,
          );
          Navigator.of(context).pushReplacement(
            FadePageRoute(
              newPage: LoginPage(),
            ),
          );
        }
        if (state is FailureHasSession) {

          Navigator.of(context).pushReplacement(
            FadePageRoute(
              newPage:  LoginPage(),
            ),
          );
        }
      },

      child: Scaffold(
        backgroundColor: S2BColors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              UiValues.safe2BizLogoPng,
              height: 200,
              width: 200,
            ),
            const Spacer(),
            const Center(
              child: CircularProgressIndicator(
                color: S2BColors.primaryColor,
              ),
            ),
            const SizedBox(
              height: S2BSpacing.md,
            ),
            TextLabel.labelText(
              'Cargando ...',
              textAlign: TextAlign.center,
              color: S2BColors.silver,
            ),
            const SizedBox(
              height: S2BSpacing.md,
            ),
          ],
        ),
      ),
    );
  }
}
