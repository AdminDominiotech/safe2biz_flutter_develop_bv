import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:mobile_safe2bizapp_permission/mobile_safe2bizapp_permission.dart';
import 'package:safe2biz/app/global/controllers/settings_controller.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/auth/features/login/presenter/bloc/login_bloc.dart';
import 'package:safe2biz/app/modules/auth/features/login/presenter/widgets/widgets.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/auth/features/settings/presenter/settings_page.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/sedes/presenter/page/sede_page.dart';
import 'package:safe2biz/app/ui/module_ui.dart';
import 'package:permission_handler/permission_handler.dart';
class LoginBody extends StatefulWidget {
  final String? user;
  final String? pass;
  const  LoginBody({Key? key, this.user, this.pass}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}


class _LoginBodyState extends State<LoginBody> {
  LocalSqlite? sqlite;
  //Conexion Database
  SqlDb sqlDb = SqlDb();

  final formKey = GlobalKey<FormState>();


  late var userTxt =  TextEditingController(text: '${widget.user}');
  late var passTxt = TextEditingController(text: '${widget.pass}');
  //final passTxt = TextEditingController(text: '4321');
  // final userTxt = TextEditingController();


  // final passTxt = TextEditingController();

  @override
  void initState(){
    super.initState();
    asyncMethod();
  }

  void asyncMethod() async {
    sqlite = LocalSqlite(); // No es necesario el await aquí.
    final db = await sqlite!.database; // Esta línea parece redundante si solo vas a verificar los ajustes y no operar directamente con la base de datos aquí.
//    checkAndSaveSettingsIfNeeded();
  }



  @override
  Widget build(BuildContext context) {



    setState(() {

    });

    final size = MediaQuery.of(context).size;
    final spacingLogin = size.height * .15;
    final sizeLogo = size.height * .25;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) => current != previous,
          listener: (context, state) async {
            if (state is Loaded) {
              if (!await AppLocationPermission.checkLocationPermission()) {
                await AppLocationPermission.requestLocationService();
              }
            }
            if (state is Successful) {
              Nav.replace(
                context,
                const SedePage(),
              );
              return;
            }
            if (state is FailureLogin) {
              Toast.show(
                description:'Usuario y/o Contraseña Incorrecta',
                toastType: ToastType.error,
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Stack(
                    children: [
                      const BackgroundEffect(),
                      BtnSettings(
                        onTap: () {
                          Nav.go(
                            context,
                            const SettingsPage(),
                          );
                        },
                      ),
                      Positioned(
                        left: S2BSpacing.zero,

                        right: S2BSpacing.zero,
                        top: spacingLogin,
                        bottom: S2BSpacing.xl,
                        child: Padding(
                          padding: const EdgeInsets.all(S2BSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: PhysicalModel(
                                  color: S2BColors.white,
                                  elevation: S2BElevation.md,
                                  borderRadius:
                                      BorderRadius.circular(S2BRadius.lg),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: S2BSpacing.lg,
                                      horizontal: S2BSpacing.lg,
                                    ).copyWith(
                                      bottom: S2BSpacing.zero,
                                    ),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextLabel.h5(
                                            UiValues.iniciarSesion,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const SizedBox(
                                            height: S2BSpacing.lg,
                                          ),
                                          Image.asset(
                                            UiValues.safe2BizLogoPng,
                                            fit: BoxFit.contain,
                                            height: sizeLogo,
                                          ),
                                          const SizedBox(
                                            height: S2BSpacing.lg,
                                          ),
                                          InputTextField(
                                            controller: userTxt,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Usuario requerido';
                                              }
                                              return null;
                                            },
                                            leadingIcon: const InputLeadingIcon(
                                              FontAwesomeIcons.solidUser,
                                              color: S2BColors.primaryColor,
                                            ),
                                            placeholder: UiValues.usuario,
                                          ),
                                          const SizedBox(
                                            height: S2BSpacing.lg,
                                          ),
                                          InputTextField(
                                            controller: passTxt,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Contraseña requerida';
                                              }
                                              return null;
                                            },
                                            leadingIcon: const InputLeadingIcon(
                                              FontAwesomeIcons.key,
                                              color: S2BColors.primaryColor,
                                            ),
                                            type: InputType.password,
                                            placeholder: UiValues.contrasenia,
                                          ),
                                          const SizedBox(
                                            height: S2BSpacing.lg,
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                foregroundColor: S2BColors.primaryColor, disabledForegroundColor: S2BColors.colorHover.withOpacity(0.38),
                                                backgroundColor:
                                                    S2BColors.background),
                                            onPressed: ()  {



                                              setState(() {
                                                _login(context);
                                              });
                                     //         SettingsController(sqlite: GetIt.instance.get<LocalSqlite>()).saveS2B();


                                            },
                                            child: Text(UiValues.iniciarSesion),

                                          ),

                                      const SizedBox(
                                      height: S2BSpacing.lg,
                                    ),

                                          const SizedBox(
                                            height: S2BSpacing.lg,
                                          ),

                                          const SizedBox(
                                            height: S2BSpacing.lg,
                                          ),

                                              Text('Ver. 1.4.0-20260429', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 11),),




                                          /*BtnDefault(
                                            UiValues.iniciarSesion,
                                            loading: state is Loading,
                                            onTap: () => _login(context),
                                          ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final settings = GetIt.I<SettingsController>();

    if (settings.setting == null) {
      sqlDb.deleteAllEstadoBloc();
      final header = GetIt.I<DioMicroServices>().msDio.options.headers;
      GetIt.I<DioMicroServices>().msDio.options.headers = {
        ...header,
        'userLogin': '${userTxt.text.trim()}@${settings.setting!.arroba}',
        'userPassword': passTxt.text.trim(),
        'systemRoot': '${settings.setting!.nameCompany}',
      };
      context.read<LoginBloc>().add(
        LoginEv(
          user: userTxt.text.trim(),
          password: passTxt.text.trim(),
        ),
      );

      return;
    }else if (settings.setting != null){
      sqlDb.deleteAllEstadoBloc();
      final header = GetIt.I<DioMicroServices>().msDio.options.headers;
      GetIt.I<DioMicroServices>().msDio.options.headers = {
        ...header,
        'userLogin': '${userTxt.text.trim()}@${settings.setting!.arroba}',
        'userPassword': passTxt.text.trim(),
        'systemRoot': '${settings.setting!.nameCompany}',
      };

      context.read<LoginBloc>().add(
        LoginEv(
          user: userTxt.text.trim(),
          password: passTxt.text.trim(),
        ),
      );

    }
  }


}
