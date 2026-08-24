import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_safe2bizapp_connectivity/mobile_safe2bizapp_connectivity.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/register_acto_condicion/presenter/bloc/register_ayc_bloc.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

class FormAyC extends StatefulWidget {
  FormAyC({
    Key? key,
  }) : super(key: key);

  @override
  State<FormAyC> createState() => _FormAyCState();
}

class _FormAyCState extends State<FormAyC> {
  final formKey = GlobalKey<FormState>();
  final _sizedBoxKey = GlobalKey();
  final _sizedBoxSecondKey = GlobalKey();
  final _scrollCtrl = ScrollController();
  DateTime dateSelected = DateTime.now();
  late String _idSede;

  final empleadoTxt = TextEditingController();

  String idEmpleado = '';

  final desviacionTxt = TextEditingController();

  String idDesviacion = '0';

  final gerenciaTxt = TextEditingController();

  String idGerencia = '';

  final areaTxt = TextEditingController();

  String idArea = '';

  final empresaTxt = TextEditingController();

  String idEmpresa = '';

  final fechaTxt = TextEditingController(text: DateTime.now().formatLocalFech);

  final horaTxt = TextEditingController(text: DateTime.now().formatHour);

  final origenSelected = ValueNotifier<int>(1);

  final descripcionTxt = TextEditingController();

  final lugarTxt = TextEditingController();

  String idLugar = '';

  final tipoEventoTxt = TextEditingController();

  String idTipoEvento = '';

  final nivelRiesgoTxt = TextEditingController();

  String idNivelRiesgo = '';

  final accionInmediataTxt = TextEditingController();

  final corrigioSelected = ValueNotifier<int>(1);

  File? file1;

  String? img1;

  String? img1Name;

  File? file2;
  String? img2;

  String? img2Name;

  late LatLng? currentPosition;

  // -------------------------------------------
  List<Option<Area>> listAreasOp = [];

  List<Option<Gerencia>> listGerenciasOp = [];

  List<Option<EmpresaEsp>> listEmpresasOp = [];

  List<Option<Desviacion>> listDesviacionesOp = [];

  List<Option<TipoEvento>> listTipoEventosOp = [];

  List<Option<NivelRiesgo>> listNivelRiesgosOp = [];

  List<Option<Empleado>> listEmpleadosOp = [];
  //==========================CONECTION NETWORK==============================
  ValueNotifier<bool> isNet = ValueNotifier<bool>(false);
  bool _init = true;
  late StreamSubscription<bool> streamConection;
  @override
  void initState() {
    _idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '0';
    try {
      final instanceNet = GetIt.I<ConnectivityStatus>()..initialize();
      streamConection = instanceNet.connectionChange.listen(_checkedConection);
    } catch (e, t) {
      print('Ups algo error $ConnectivityStatus');
    }
    super.initState();
  }




  @override
  void dispose() {
    streamConection.cancel();
    super.dispose();
  }

  void _checkedConection(bool value) {
    if (_init) {
      if (!value) {
        context.read<RegisterAyCBloc>().add(InitEv());
      }
      _init = false;
    }
    if (isNet.value != value) isNet.value = value;
  }

  void _scrollUp() async {
    Scrollable.ensureVisible(
      _sizedBoxKey.currentContext!,
      duration: const Duration(milliseconds: 350),
      curve: Curves.elasticOut,
    );
  }

  void _scrollDown() async {
    Scrollable.ensureVisible(
      _sizedBoxSecondKey.currentContext!,
      duration: const Duration(milliseconds: 350),
      curve: Curves.elasticOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final min = size.height * 0.35;
    final max = size.height * 0.60;
    return BlocBuilder<RegisterAyCBloc, RegisterAyCState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is Loaded) {
          listAreasOp = state.areas.map((e) => Option(e.nombre, e)).toList();
          listGerenciasOp =
              state.gerencias.map((e) => Option(e.nombre, e)).toList();
          listEmpresasOp =
              state.empresas.map((e) => Option(e.razonSocial, e)).toList();
          listDesviacionesOp =
              state.desviaciones.map((e) => Option(e.descripcion, e)).toList();
          listTipoEventosOp =
              state.tipoEventos.map((e) => Option(e.nombre, e)).toList();
          listNivelRiesgosOp =
              state.nivelRiesgos.map((e) => Option(e.nombre, e)).toList();
          listEmpleadosOp =
              state.empleados.map((e) => Option(e.nombreCompleto, e)).toList();
        }
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            controller: _scrollCtrl,
            padding: const EdgeInsets.symmetric(
              horizontal: S2BSpacing.md,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: S2BSpacing.md,
                ),
                InputTextField(
                  controller: empleadoTxt,
                  readOnly: true,
                  onTap: () {
                    _selectEmpleados(context);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Seleccione';
                    }
                    return null;
                  },
                  placeholder: UiValues.quien,
                  trailingIcon: const InputTrailingIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: S2BColors.primaryColor,
                  ),
                ),
                const SizedBox(
                  height: S2BSpacing.sm,
                ),
            ValueListenableBuilder<int>(
              valueListenable: origenSelected,
              builder: (_, value, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Origen'), // UiValues.origen si lo tienes
                    RadioListTile<int>(
                      title: const Text('Acto'),
                      value: 1,
                      groupValue: value,
                      onChanged: (v) {
                        if (v != null) origenSelected.value = v;
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text('Condición'),
                      value: 2,
                      groupValue: value,
                      onChanged: (v) {
                        if (v != null) origenSelected.value = v;
                      },
                    ),
                  ],
                );
              },
            ),


                const SizedBox(
                  height: S2BSpacing.xs,
                ),
                InputTextField(
                  controller: desviacionTxt,
                  readOnly: true,
                  onTap: () {
                    _selectDesviaciones(context);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Seleccione';
                    }
                    return null;
                  },
                  placeholder: UiValues.desviacion,
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
                  placeholder: "Area",
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
                ),
                InputTextField(
                  controller: empresaTxt,
                  readOnly: true,
                  onTap: () {
                    _selectEmpresas(context);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Seleccione';
                    }
                    return null;
                  },
                  placeholder: "Empresa",
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
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
                              initial:
                                  horaTxt.text.isEmpty ? null : horaTxt.text,
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
                InputTextField(
                  controller: tipoEventoTxt,
                  readOnly: true,
                  onTap: () {
                    _selectTipoEvento(context);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Seleccione';
                    }
                    return null;
                  },
                  placeholder: "Tipo de evento",
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
                ),
                InputTextField(
                  controller: nivelRiesgoTxt,
                  readOnly: true,
                  onTap: () {
                    _selectNivelRiesgo(context);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Seleccione';
                    }
                    return null;
                  },
                  placeholder: "Nivel de riesgo",
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
                ),
                InputTextField(
                  controller: accionInmediataTxt,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Requerido';
                    }
                    return null;
                  },
                  placeholder: "Acción inmediata",
                ),
                SizedBox(
                  key: _sizedBoxKey,
                  height: S2BSpacing.sm,
                ),
            ValueListenableBuilder<int>(
              valueListenable: corrigioSelected,
              builder: (_, value, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Se corrigió'),
                    RadioListTile<int>(
                      title: const Text('Sí'),
                      value: 1,
                      groupValue: value,
                      onChanged: (v) {
                        if (v != null) corrigioSelected.value = v;
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text('No'),
                      value: 0,
                      groupValue: value,
                      onChanged: (v) {
                        if (v != null) corrigioSelected.value = v;
                      },
                    ),
                  ],
                );
              },
            ),
                ValueListenableBuilder<bool>(
                  valueListenable: isNet,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: S2BSpacing.xs,
                      ),
                      Align(
                        key: _sizedBoxSecondKey,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: S2BSpacing.md,
                          ),
                          child: TextLabel.labelText(
                            'Ubicación',
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            S2BSpacing.md,
                          ),
                        ),
                        child: MapView(
                          maxHeight: max,
                          minHeight: min,
                          onMapCreated: () {
                            context.read<RegisterAyCBloc>().add(InitEv());
                          },
                          onChangePlace: (position) {
                            currentPosition = position;
                          },
                          onExpanded: (isExpanded) {
                            if (isExpanded) {
                              _scrollDown();
                            } else {
                              _scrollUp();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  builder: (context, hasNet, widget) {
                    if (!hasNet) {
                      return SizedBox.shrink();
                    }
                    return widget!;
                  },
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
                ),
                ItemPhoto(
                  key: Key('foto1'),
                  title: 'Foto 1',
                  onChange: (file) {
                    if (file != null) {
                      file1 = file;
                    }
                  },
                  showError: true,
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
                ),
                ItemPhoto(
                  key: Key('foto2'),
                  title: 'Foto 2',
                  onChange: (file) {
                    if (file != null) {
                      file2 = file;
                    }
                  },
                  showError: true,
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
                ),
                BtnDefault(
                  UiValues.guardar,
                  // paddingH: S2BSpacing.xxsl,
                  onTap: () => _save(context),
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectEmpleados(BuildContext context) async {
    PopupSelect.show<Empleado>(
      title: 'Empleados',
      context: context,
      initialList: listEmpleadosOp,
      filter: true,
      onSelect: (String value, Empleado empleado) {
        empleadoTxt.text = empleado.nombreCompleto;
        idEmpleado = empleado.id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, Empleado item) {
        return ItemSelect(
          item.nombreCompleto,
          label: item.gerenciaNombre,
          subLabel: item.empresa,
        );
      },
    );
  }

  void _selectDesviaciones(BuildContext context) async {
    final ayc = origenSelected.value == 1 ? 'A' : 'C';
    final newList =
        listDesviacionesOp.where((e) => e.value.ayc == ayc).toList();
    PopupSelect.show<Desviacion>(
      title: 'Desviaciones',
      context: context,
      initialList: newList,
      onSelect: (String value, Desviacion item) {
        desviacionTxt.text = item.descripcion;
        idDesviacion = item.id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, Desviacion item) {
        return ItemSelect(item.descripcion);
      },
    );
  }

  void _selectGerencias(BuildContext context) async {
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '0';
    final newList =
        listGerenciasOp.where((e) => e.value.fbUeaPeId == idSede).toList();

    PopupSelect.show<Gerencia>(
      title: 'Gerencias',
      context: context,
      initialList: newList,
      onSelect: (String value, Gerencia item) {
        gerenciaTxt.text = item.nombre;
        idGerencia = item.id;
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

  void _selectEmpresas(BuildContext context) async {
    PopupSelect.show<EmpresaEsp>(
      title: 'Empresas',
      context: context,
      initialList: listEmpresasOp,
      onSelect: (String value, EmpresaEsp item) {
        empresaTxt.text = item.razonSocial;
        idEmpresa = item.id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, EmpresaEsp item) {
        return ItemSelect(item.razonSocial);
      },
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

  void _selectTipoEvento(BuildContext context) async {
    PopupSelect.show<TipoEvento>(
      title: 'Tipos de Eventos',
      context: context,
      initialList: listTipoEventosOp,
      onSelect: (String value, TipoEvento item) {
        tipoEventoTxt.text = item.nombre;
        idTipoEvento = item.id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, TipoEvento item) {
        return ItemSelect(item.nombre);
      },
    );
  }

  void _selectNivelRiesgo(BuildContext context) async {
    PopupSelect.show<NivelRiesgo>(
      title: 'Nivel de riesgo',
      context: context,
      initialList: listNivelRiesgosOp,
      onSelect: (String value, NivelRiesgo item) {
        nivelRiesgoTxt.text = item.nombre;
        idNivelRiesgo = item.id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, NivelRiesgo item) {
        return ItemSelect(item.nombre);
      },
    );
  }

  void _inputChange() {
    context.read<RegisterAyCBloc>().add(
          ChangeDataEv(
            id: 0,
            origen: origenSelected.value == 1 ? 'A' : 'C',
            gTipoCausaId: idDesviacion,
            gTipoCausaNombre: desviacionTxt.text,
            fbGerencia: idGerencia,
            fbGerenciaNombre: gerenciaTxt.text,
            fbAreaId: idArea,
            fbAreaNombre: areaTxt.text,
            descripcion: descripcionTxt.text,
            lugar: lugarTxt.text,
            fecha: fechaTxt.text,
            hora: horaTxt.text,
            corrigio: corrigioSelected.value.toString(),
            tipoEventoId: idTipoEvento,
            tipoEventoNombre: tipoEventoTxt.text,
            nivelRiesgoId: idNivelRiesgo,
            nivelRiesgoNombre: nivelRiesgoTxt.text,
            accionEjec: accionInmediataTxt.text,
            fbEmpresaEspecializadaId: idEmpresa,
            fbEmpresaEspecializadaNombre: empresaTxt.text,
            latitud: !isNet.value
                ? '0'
                : currentPosition != null
                    ? '${currentPosition!.latitude}'
                    : '0',
            longitud: !isNet.value
                ? '0'
                : currentPosition != null
                    ? '${currentPosition!.longitude}'
                    : '0',
            fbEmpleadoId: idEmpleado,
            fbEmpleadoNombre: empleadoTxt.text,
            fbUeaPeId: _idSede, // ID DE LA SEDE ACTUAL
            estado: '0', //
          ),
        );
  }

  void _save(BuildContext context) async {
    bool isValidate = true;
    _inputChange();
    if (!formKey.currentState!.validate()) {
      isValidate = false;
    }

    if (file1 == null || file2 == null) {
      isValidate = false;
    }
    if (!isValidate) {
      return;
    }

    context.read<RegisterAyCBloc>().add(
          SaveActoCondicionEv(
            file1: file1!,
            file2: file2!,
          ),
        );
  }
}
