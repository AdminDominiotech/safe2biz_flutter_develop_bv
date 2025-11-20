import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/global/core/shared_widgets/forms/radio/radio_buton_option.dart';
import 'package:safe2biz/app/global/core/utils/utils.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/features/detail_ops/presenter/bloc/detail_ops_bloc.dart';

import 'package:safe2biz/app/ui/module_ui.dart';

class FormDetail extends StatefulWidget {
  const FormDetail({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String title;
  final String subTitle;

  @override
  State<FormDetail> createState() => _FormDetailState();
}

class _FormDetailState extends State<FormDetail> {
  final formKey = GlobalKey<FormState>();

  final _commentTxt = TextEditingController();
  final file1 = ValueNotifier<File?>(null);
  final _validatedOption = ValueNotifier<bool>(false);
  int _id = 0;
  bool _isEdit = false;
  List<RadioButtonOption> resultadosOps = [];
  RadioButtonOption? optionSelected;
  String? img1;
  String? img1Name;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailOpsBloc, DetailOpsState>(
      listener: (context, state) async {
        if (state is RegistroResultadoLoaded) {
          _initTextControllers(state.registroResultado);
        }

        if (state is Loaded) {
          resultadosOps = state.resultadoOps
              .where((e) => e.opsTipoResultadoId == state.idResultadoOps)
              .map((e) {
            return RadioButtonOption(
              id: e.id,
              code: e.codigo,
              label: e.nombre,

              isChecked:
                  optionSelected != null ? optionSelected!.id == e.id : false,
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
            TextLabel.h6(
              widget.title,
              fontWeight: FontWeight.w700,
              color: Colors.black87
            ),
            const SizedBox(
              height: S2BSpacing.md,
            ),
            TextLabel.body(
              widget.subTitle,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: Colors.grey
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
              },
            ),
            RadioButtonsList(
              items: resultadosOps,
              onTapItem: (RadioButtonOption option) {
                optionSelected = option;
                _inputChange();
              },
            ),
            const SizedBox(
              height: S2BSpacing.md,
            ),
            InputTextField(
              controller: _commentTxt,
              onChanged: (e) => _inputChange(),
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
                _id == 0 ? UiValues.guardar : 'Editar',
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
        colorSelect = S2BColors.black;

        break;
      case 'C':
        colorSelect = S2BColors.black;

        break;
      case 'NC':
        colorSelect = S2BColors.black;

        break;
      case 'NA':
        colorSelect = S2BColors.black;
        break;

      default:
        colorSelect = S2BColors.black;
    }
    return colorSelect;
  }

  Future<void> _initTextControllers(RegistroResultado registroResultado) async {
    _isEdit = registroResultado.id != 0;
    _id = registroResultado.id;
    _commentTxt.text = registroResultado.observacion;
    optionSelected = RadioButtonOption(
      id: registroResultado.opsListaVerifResultadoId,
      code: registroResultado.auxCodigo,
      label: '',
    );
    if (registroResultado.rutaImagen.isNotEmpty) {
      img1 = registroResultado.rutaImagen;
      img1Name = registroResultado.nombreImagen;
      file1.value = await Utils.stringBase64ToFile(
        image: registroResultado.rutaImagen,
        name: img1Name,
      );
    }
    _inputChange();
  }

  void _inputChange() {
    context.read<DetailOpsBloc>().add(
          ChangeDataEv(
            id: _id,
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

    if (_isEdit) {
      context.read<DetailOpsBloc>().add(
            EditRegistroResultadoEv(
              file1: file1.value!,
            ),
          );
    } else {
      context.read<DetailOpsBloc>().add(
            SaveRegistroResultadoEv(
              file1: file1.value!,
            ),
          );
    }
  }
}

class _RadioButton extends StatelessWidget {
  const _RadioButton(
    this.label, {
    Key? key,
    this.selected = false,
  }) : super(key: key);

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RadioButton(
          innerCircleColor: S2BColors.primaryColor,
          innerCircleSize: selected ? 14.4 : 0,
          outerCircleSize: S2BSpacing.lg,
        ),
        TextLabel.body(label, fontWeight: FontWeight.w500),
      ],
    );
  }
}
