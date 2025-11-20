import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/global/core/shared_widgets/forms/radio/radio_buton_option.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/features/register_ops/presenter/bloc/register_ops_bloc.dart';

import 'package:safe2biz/app/ui/module_ui.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String title;
  final String subTitle;
  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final formKey = GlobalKey<FormState>();

  final _commentTxt = TextEditingController();
  final file1 = ValueNotifier<File?>(null);
  final _validatedOption = ValueNotifier<bool>(false);
  List<RadioButtonOption> resultadosOps = [];
  RadioButtonOption? optionSelected;
  String? img1;
  String? img1Name;

  @override
  Widget build(BuildContext context) {
    // return
    // BlocConsumer<DetailINCBloc, DetailINCState>(
    //   listener: (context, state) {

    //   },
    //   builder: (context, state) {

    return BlocListener<RegisterOpsBloc, RegisterOpsState>(
      listener: (context, state) {
        if (state is Loaded) {
          resultadosOps = state.resultadoOps
              .where((e) => e.opsTipoResultadoId == state.idResultadoOps)
              .map((e) {
            return RadioButtonOption(
              id: e.id,
              code: e.codigo,
              label: e.nombre,
              color: showColors(e.codigo),
            );
          }).toList();
        }
      },
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: S2BSpacing.md,
            ),
            TextLabel.h5(
              widget.title,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: S2BSpacing.sm,
            ),
            TextLabel.body(
              widget.subTitle,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: S2BSpacing.md,
            ),
            ValueListenableBuilder<bool>(
                valueListenable: _validatedOption,
                builder: (context, validated, _) {
                  if (!validated) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      TextLabel.labelText(
                        'Debes seleccionar una opción',
                        fontWeight: FontWeight.w400,
                        color: S2BColors.dangerColor,
                      ),
                      const SizedBox(
                        height: S2BSpacing.md,
                      ),
                    ],
                  );
                }),
            RadioButtonsList(
              items: resultadosOps,
              onTapItem: (RadioButtonOption option) {
                optionSelected = option;
              },
            ),
            const SizedBox(
              height: S2BSpacing.md,
            ),
            InputTextField(
              controller: _commentTxt,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Seleccione';
                }
                return null;
              },
              placeholder: "Comentario",
            ),
            const SizedBox(
              height: S2BSpacing.lg,
            ),
            ValueListenableBuilder<File?>(
              valueListenable: file1,
              builder: (context, img, _) {
                return ItemPhoto(
                  title: 'Foto 1',
                  imageInitial: img,
                  onChange: (file) {
                    if (file != null) {
                      file1.value = file;
                    }
                  },
                  showError: true,
                );
              },
            ),
            const SizedBox(
              height: S2BSpacing.lg,
            ),
            Align(
              alignment: Alignment.center,
              child: BtnDefault(
                UiValues.guardar,
                onTap: () => _save(context),
              ),
            ),
            const SizedBox(
              height: S2BSpacing.lg,
            ),
          ],
        ),
      ),
    );
  }

  Color showColors(String code) {
    late Color colorSelect;
    switch (code) {
      case 'CP':
        colorSelect = S2BColors.orange;

        break;
      case 'C':
        colorSelect = S2BColors.green;

        break;
      case 'NC':
        colorSelect = S2BColors.dangerColor;

        break;
      case 'NA':
        colorSelect = S2BColors.black;
        break;

      default:
        colorSelect = S2BColors.black;
    }
    return colorSelect;
  }

  void _inputChange() {
    context.read<RegisterOpsBloc>().add(
          ChangeDataEv(
            observacion: _commentTxt.text,
            opsListaVerifResultadoId:
                optionSelected != null ? optionSelected?.id : '0',
            auxCodigo: optionSelected != null ? optionSelected?.code : '',
          ),
        );
  }

  void _save(BuildContext context) async {
    _validatedOption.value = false;
    bool isValidate = true;
    _inputChange();
    if (!formKey.currentState!.validate()) {
      isValidate = false;
    }

    if (file1.value == null) {
      isValidate = false;
    }

    if (optionSelected == null) {
      _validatedOption.value = true;
      isValidate = false;
    }

    if (!isValidate) {
      return;
    }

    context.read<RegisterOpsBloc>().add(
          SaveRegistroResultadoEv(
            file1: file1.value!,
          ),
        );
  }
}
