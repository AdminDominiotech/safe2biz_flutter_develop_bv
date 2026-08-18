import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/auth/features/settings/data/models/setting_model.dart';
import 'package:safe2biz/app/modules/auth/features/settings/presenter/bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final ipTxt =
      TextEditingController(text: 'https://desafe2biz.buenaventura.pe:7543');
  final companyTxt = TextEditingController(text: 'BUENAVENTURA');
  final arrobaTxt = TextEditingController(text: 'buenaventuras2b');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(
        'Configuración'
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is Loaded) {
            if (state.setting != null) {
              final setting = state.setting;
              ipTxt.text = setting!.ip;
              companyTxt.text = setting.nameCompany;
              arrobaTxt.text = setting.arroba;
            }
          }

          if (state is SavedSetting) {
            Toast.show(
              description: 'Configuración actualizada',
              toastType: ToastType.success,
            );
          }
          if (state is FailureSaveSetting) {
            Toast.show(
              description: state.error,
              toastType: ToastType.error,
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: S2BSpacing.lg,
                horizontal: S2BSpacing.md,
              ).copyWith(
                bottom: S2BSpacing.zero,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextLabel.h5(
                      'Configurar la conexión de datos para el servidor',
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: S2BSpacing.lg,
                    ),
                    TextFormField(
                      controller: ipTxt,
                    ),
                    InputTextField(
                      controller: ipTxt,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ip requerido';
                        }
                        return null;
                      },
                      leadingIcon: const InputLeadingIcon(
                        FontAwesomeIcons.server,
                        color: S2BColors.primaryColor,
                      ),
                      placeholder: 'IP o Server domain',
                    ),
                    const SizedBox(
                      height: S2BSpacing.lg,
                    ),
                    InputTextField(
                      controller: companyTxt,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Empresa requerida';
                        }
                        return null;
                      },
                      leadingIcon: const InputLeadingIcon(
                        FontAwesomeIcons.house,
                        color: S2BColors.primaryColor,
                      ),
                      placeholder: 'Empresa',
                    ),
                    const SizedBox(
                      height: S2BSpacing.lg,
                    ),
                    InputTextField(
                      controller: arrobaTxt,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Arroba requerida';
                        }
                        return null;
                      },
                      leadingIcon: const InputLeadingIcon(
                        FontAwesomeIcons.house,
                        color: S2BColors.primaryColor,
                      ),
                      placeholder: 'Arroba',
                    ),

                    const SizedBox(
                      height: S2BSpacing.lg,
                    ),
                    BlocBuilder<SettingsBloc, SettingsState>(
                      buildWhen: (previous, current) =>
                          current is SavingSetting ||
                          current is FailureSaveSetting ||
                          current is SavedSetting,
                      builder: (context, state) {
                        return BtnDefault(
                          'Guardar',
                          // paddingH: S2BSpacing.xxsl,
                          onTap: () {

                            Future.delayed(const Duration(milliseconds: 500), () {
                              Nav.back(context);
                            });

                            _save(context);

                            },
                          loading: state is SavingSetting,
                        );
                      },
                    ),
                    const SizedBox(
                      height: S2BSpacing.lg,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save(BuildContext context) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final setting = SettingModel(ip: ipTxt.text, nameCompany: companyTxt.text, arroba: arrobaTxt.text);
    context.read<SettingsBloc>().add(SaveSettingEv(setting: setting));
  }
}
