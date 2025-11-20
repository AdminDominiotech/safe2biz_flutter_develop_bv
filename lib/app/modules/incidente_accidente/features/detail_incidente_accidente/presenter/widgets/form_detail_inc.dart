import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/global/core/utils/utils.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/detail_incidente_accidente/presenter/bloc/detail_inc_bloc.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/page/sincronizar_page.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

class FormDetailINC extends StatefulWidget {
  FormDetailINC({
    Key? key,
    required this.incidenteAccidente,
  }) : super(key: key);

  final IncidenteAccidente incidenteAccidente;

  @override
  State<FormDetailINC> createState() => _FormDetailINCState();
}

class _FormDetailINCState extends State<FormDetailINC> {
  final formKey = GlobalKey<FormState>();

  DateTime dateSelected = DateTime.now();
  late String _idSede;

  final gerenciaTxt = TextEditingController();

  String idGerencia = '';

  final areaTxt = TextEditingController();

  String idArea = '';

  final fechaTxt = TextEditingController(text: DateTime.now().formatLocalFech);

  final horaTxt = TextEditingController(text: DateTime.now().formatHour);

  final origenSelected = ValueNotifier<int>(1);

  final descripcionTxt = TextEditingController();

  final lugarTxt = TextEditingController();

  String idLugar = '';

  final tipoReporteTxt = TextEditingController();

  String idTipoReporte = '';

  final subTipoReporteTxt = TextEditingController();
  final showSubTipo = ValueNotifier<bool>(false);

  String idSubTipoReporte = '';

  final detallePerdidaTxt = TextEditingController();

  String idDetallePerdida = '';

  final potencialPerdidaTxt = TextEditingController();

  String idPotencialPerdida = '';

  final corrigioSelected = ValueNotifier<int>(1);
  final file1 = ValueNotifier<File?>(null);
  String? img1;
  String? img1Name;

  // -------------------------------------------
  List<Option<TipoReporte>> listTipoReportesOp = [];

  List<Option<SubTipoReporte>> listSubTipoReportesOp = [];

  List<Option<DetallePerdida>> listDetallePerdidasOp = [];

  List<Option<PotencialPerdida>> listPotencialPerdidasOp = [];

  List<Option<Area>> listAreasOp = [];

  List<Option<Gerencia>> listGerenciasOp = [];

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    _initTextControllers();
    // });
    super.initState();
  }

  Future<void> _initTextControllers() async {
    final inc = widget.incidenteAccidente;
    _idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '0';
    fechaTxt.text = inc.fecha;
    horaTxt.text = inc.hora;

    tipoReporteTxt.text = inc.incTipoReporteNombre;
    idTipoReporte = inc.incTipoReporte;
    final exist = listSubTipoReportesOp
        .firstWhereOrNull((e) => e.value.tipoReporteId == idTipoReporte);

    showSubTipo.value = exist != null;

    subTipoReporteTxt.text = inc.incSubTipoReporteNombre;

    idSubTipoReporte = inc.incSubTipoReporte;

    detallePerdidaTxt.text = inc.incSegunTipoNombre;
    idDetallePerdida = inc.incSegunTipo;
    potencialPerdidaTxt.text = inc.incPotencialPerdidaNombre;
    idPotencialPerdida = inc.incPotencialPerdida;
    gerenciaTxt.text = inc.fbGerenciaNombre;
    idGerencia = inc.fbGerencia;
    areaTxt.text = inc.fbAreaNombre;
    idArea = inc.fbArea;
    descripcionTxt.text = inc.descripcion;
    lugarTxt.text = inc.lugar;

    if (inc.imagenPreReporteRuta.isNotEmpty) {
      img1 = inc.imagenPreReporteRuta;
      img1Name = inc.imagenPreReporteNombre;
      file1.value = await Utils.stringBase64ToFile(
        image: inc.imagenPreReporteRuta,
        name: inc.imagenPreReporteNombre,
      );
    }
    _inputChange();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailINCBloc, DetailINCState>(
      builder: (context, state) {
        if (state is Loaded) {
          listAreasOp = state.areas.map((e) => Option(e.nombre, e)).toList();
          listGerenciasOp =
              state.gerencias.map((e) => Option(e.nombre, e)).toList();
          listTipoReportesOp =
              state.tipoReportes.map((e) => Option(e.nombre, e)).toList();
          listSubTipoReportesOp =
              state.subTipoReportes.map((e) => Option(e.nombre, e)).toList();
          listDetallePerdidasOp =
              state.detallePerdidas.map((e) => Option(e.nombre, e)).toList();
          listPotencialPerdidasOp =
              state.potencialPerdidas.map((e) => Option(e.nombre, e)).toList();

          if (state.tipoReportes.isEmpty) {
            SyncDataScreen.show(
              context: context,
              onTap: () async {
                final result = await Nav.go(
                  context,
                  const SincronizarPage(),
                );

                if (result != null && result as bool) {
                  context.read<DetailINCBloc>().add(
                        InitEv(
                          incidenteAccidente: widget.incidenteAccidente,
                        ),
                      );
                }
              },
              onClosed: () {
                Nav.back(context);
                Nav.back(context);
              },
            );
          }
        }
        return Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: S2BSpacing.md,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputTextField(
                      controller: fechaTxt,
                      readOnly: true,
                      onTap: () async {
                        _selectDay(context);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Seleccione';
                        }
                        return null;
                      },
                      trailingIcon: const InputTrailingIcon(
                        FontAwesomeIcons.calendar,
                        color: S2BColors.primaryColor,
                      ),
                      placeholder: "Fecha",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InputTextField(
                      controller: horaTxt,
                      readOnly: true,
                      onTap: () async {
                        final selectHour =
                            await showCupertinoModalPopup<String>(
                          context: context,
                          builder: (_) => SelectHour(
                            title: 'Horas',
                            initial: horaTxt.text.isEmpty ? null : horaTxt.text,
                            onTapOk: (value) {
                              Navigator.pop(context, value);
                            },
                          ),
                        );
                        if (selectHour != null) {
                          horaTxt.text = selectHour;
                        }
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Seleccione';
                        }
                        return null;
                      },
                      trailingIcon: const InputTrailingIcon(
                        FontAwesomeIcons.clock,
                        color: S2BColors.primaryColor,
                      ),
                      placeholder: "Hora",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: S2BSpacing.lg,
              ),
              InputTextField(
                controller: tipoReporteTxt,
                readOnly: true,
                onTap: () {
                  _selectTipoReporte(context);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Seleccione';
                  }
                  return null;
                },
                placeholder: "Tipo de Reporte",
              ),
              const SizedBox(
                height: S2BSpacing.lg,
              ),
              InputTextField(
                controller: subTipoReporteTxt,
                readOnly: true,
                onTap: () {
                  _selectSubTipoReporte(context);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Seleccione';
                  }
                  return null;
                },
                placeholder: "SubTipo de evento",
              ),
              const SizedBox(
                height: S2BSpacing.lg,
              ),
              InputTextField(
                controller: detallePerdidaTxt,
                readOnly: true,
                onTap: () {
                  _selectDetallePerdida(context);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Seleccione';
                  }
                  return null;
                },
                placeholder: "Detalle pérdida",
              ),
              const SizedBox(
                height: S2BSpacing.lg,
              ),
              InputTextField(
                controller: potencialPerdidaTxt,
                readOnly: true,
                onTap: () {
                  _selectPotencialPerdida(context);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Seleccione';
                  }
                  return null;
                },
                placeholder: "Potencial pérdida",
              ),
              const SizedBox(
                height: S2BSpacing.lg,
              ),
              InputTextField(
                controller: gerenciaTxt,
                readOnly: true,
                onTap: () {
                  _selectGerencias(context);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Seleccione';
                  }
                  return null;
                },
                placeholder: UiValues.gerencia,
              ),
              const SizedBox(
                height: S2BSpacing.lg,
              ),
              InputTextField(
                controller: areaTxt,
                readOnly: true,
                onTap: () {
                  _selectArea(context);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Seleccione';
                  }
                  return null;
                },
                placeholder: "Area del evento",
              ),
              const SizedBox(
                height: S2BSpacing.lg,
              ),
              InputTextField(
                controller: descripcionTxt,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
                placeholder: "Descripción",
              ),
              const SizedBox(
                height: S2BSpacing.lg,
              ),
              InputTextField(
                controller: lugarTxt,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Seleccione';
                  }
                  return null;
                },
                placeholder: "Lugar",
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
              if (widget.incidenteAccidente.estado != '1')
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: S2BSpacing.lg,
                  ),
                  child: BtnDefault(
                    UiValues.guardar,
                    onTap: () => _save(context),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _inputChange() {
    context.read<DetailINCBloc>().add(
          ChangeDataEv(
            id: widget.incidenteAccidente.id,
            fbGerencia: idGerencia,
            fbGerenciaNombre: gerenciaTxt.text,
            fbArea: idArea,
            fbAreaNombre: areaTxt.text,
            fecha: fechaTxt.text,
            hora: horaTxt.text,
            incTipoReporte: idTipoReporte,
            incTipoReporteNombre: tipoReporteTxt.text,
            incSubTipoReporte: idSubTipoReporte,
            incSubTipoReporteNombre: subTipoReporteTxt.text,
            incSegunTipo: idDetallePerdida,
            incSegunTipoNombre: detallePerdidaTxt.text,
            incPotencialPerdida: idPotencialPerdida,
            incPotencialPerdidaNombre: potencialPerdidaTxt.text,
            descripcion: descripcionTxt.text,
            lugar: lugarTxt.text,
            fbUeaPeId: _idSede,
            estado: '0',
          ),
        );
  }

  Future<void> _selectDay(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.white,
          child: MaterialCalendarWithChild(
            initialDate: dateSelected,
            firstDate: DateTime.now().add(
              const Duration(days: -3650),
            ),
            lastDate: DateTime.now().add(
              const Duration(days: 0),
            ),
            onDateChanged: (d) {
              dateSelected = d;
              fechaTxt.text = d.formatLocalFech;
              Navigator.pop(
                context,
              );
            },
          ),
        );
      },
    );
  }

  void _selectTipoReporte(BuildContext context) async {
    PopupSelect.show<TipoReporte>(
      title: 'Tipos de Reportes',
      context: context,
      initialList: listTipoReportesOp,
      onSelect: (String value, TipoReporte item) {
        tipoReporteTxt.text = item.nombre;
        idTipoReporte = item.id;
        final model = listSubTipoReportesOp
            .firstWhereOrNull((e) => e.value.tipoReporteId == item.id);
        if (model == null) {
          subTipoReporteTxt.text = '';
          idSubTipoReporte = '';
        } else {
          subTipoReporteTxt.text = model.value.nombre;
          idSubTipoReporte = model.value.id;
        }
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, TipoReporte item) {
        return ItemSelect(item.nombre);
      },
    );
  }

  void _selectSubTipoReporte(BuildContext context) async {
    final newList = listSubTipoReportesOp
        .where((e) => e.value.tipoReporteId == idTipoReporte)
        .toList();
    PopupSelect.show<SubTipoReporte>(
      title: 'Sub Tipos de Reportes',
      context: context,
      initialList: newList,
      onSelect: (String value, SubTipoReporte item) {
        subTipoReporteTxt.text = item.nombre;
        idSubTipoReporte = item.id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, SubTipoReporte item) {
        return ItemSelect(item.nombre);
      },
    );
  }

  void _selectDetallePerdida(BuildContext context) async {
    final newList = listDetallePerdidasOp
        .where((e) => e.value.tipoReporteId == idTipoReporte)
        .toList();
    PopupSelect.show<DetallePerdida>(
      title: 'Detalle Perdidas',
      context: context,
      initialList: newList,
      onSelect: (String value, DetallePerdida item) {
        detallePerdidaTxt.text = item.nombre;
        idDetallePerdida = item.id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, DetallePerdida item) {
        return ItemSelect(item.nombre);
      },
    );
  }

  void _selectPotencialPerdida(BuildContext context) async {
    PopupSelect.show<PotencialPerdida>(
      title: 'Potenciales Perdidas',
      context: context,
      initialList: listPotencialPerdidasOp,
      onSelect: (String value, PotencialPerdida item) {
        potencialPerdidaTxt.text = item.nombre;
        idPotencialPerdida = item.id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, PotencialPerdida item) {
        return ItemSelect(item.nombre);
      },
    );
  }

  void _selectGerencias(BuildContext context) async {
    final newList =
        listGerenciasOp.where((e) => e.value.fbUeaPeId == _idSede).toList();

    PopupSelect.show<Gerencia>(
      title: 'Gerencias',
      context: context,
      initialList: newList,
      onSelect: (String value, Gerencia item) {
        gerenciaTxt.text = item.nombre;
        idGerencia = item.id;
        final model = listAreasOp
            .firstWhereOrNull((e) => e.value.fbGerenciaId == item.id);

        if (model == null) {
          areaTxt.text = '';
          idArea = '';
        } else {
          areaTxt.text = model.value.nombre;
          idArea = model.value.id;
        }
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, Gerencia item) {
        return ItemSelect(item.nombre);
      },
    );
  }

  void _selectArea(BuildContext context) async {
    final newList =
        listAreasOp.where((e) => e.value.fbGerenciaId == idGerencia).toList();
    PopupSelect.show<Area>(
      title: 'Areas',
      context: context,
      initialList: newList,
      onSelect: (String value, Area item) {
        areaTxt.text = item.nombre;
        idArea = item.id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, Area item) {
        return ItemSelect(item.nombre);
      },
    );
  }

  void _save(BuildContext context) async {
    bool isValidate = true;
    _inputChange();
    if (!formKey.currentState!.validate()) {
      isValidate = false;
    }

    if (file1.value == null) {
      isValidate = false;
    }
    if (!isValidate) {
      return;
    }
    context.read<DetailINCBloc>().add(
          EditIncidenteAccidenteEv(
            file1: file1.value!,
          ),
        );
  }
}
