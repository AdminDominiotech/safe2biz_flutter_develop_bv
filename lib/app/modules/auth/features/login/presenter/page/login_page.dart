import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/controllers/settings_controller.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/auth/features/login/presenter/bloc/login_bloc.dart';
import 'package:safe2biz/app/modules/auth/features/login/presenter/page/login_body.dart';


class LoginPage extends StatefulWidget {
  final String? user;
  final String? pass;
  const LoginPage({Key? key, this.user, this.pass}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

@override
LocalSqlite? sqlite;

final settings = GetIt.I<SettingsController>();
class _LoginPageState extends State<LoginPage> {
  late final DioMicroServices dioMicroServices;


  void initState(){
    super.initState();
    dioMicroServices = DioMicroServices();
    asyncMethod();
  }


  void asyncMethod() async {
    sqlite = LocalSqlite(); // No es necesario el await aquí.
    final db = await sqlite!.database; // Esta línea parece redundante si solo vas a verificar los ajustes y no operar directamente con la base de datos aquí.

  }


  @override
  Widget build(BuildContext context) {

    final auth = GetIt.I<AuthController>();

    String urlExt = '';
    String urlApp = '';
    String arroba = '';
    String id = '';
    String pass = '';
    String fb_emp = '';

    String user = '';
    List<String> modulos = [''];

    if (auth.user.value != null) {
      urlExt = auth.user.value!.urlExt;
      urlApp = auth.user.value!.urlApp;
      arroba = auth.user.value!.arroba;
      id = auth.user.value!.uuid;
      pass = auth.user.value!.password;
      fb_emp = auth.user.value!.fbEmpleadoId;
      user = auth.user.value!.userLogin;

    }
    return BlocProvider(
      create: (context) => LoginBloc(
        loginCheckUc: GetIt.I<LoginCheckUcImpl>(),
        authController: GetIt.I<AuthController>(),
        // getAccesosLocalUc: GetIt.I<GetAccesosLocalUcImpl>(),
        // saveAccesosLocalUc: GetIt.I<SaveAccesosLocalUcImpl>(),
      )..add(
        InitEv(),
      ),
      child: LoginBody(user: user, pass: pass),
    );
  }



}