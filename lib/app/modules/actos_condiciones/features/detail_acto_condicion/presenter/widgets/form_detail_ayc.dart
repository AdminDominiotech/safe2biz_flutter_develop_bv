import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart' hide RadioGroup;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_safe2bizapp_connectivity/mobile_safe2bizapp_connectivity.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/utils/utils.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/models/bsaf.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/detail_acto_condicion/presenter/bloc/detail_ayc_bloc.dart';
import 'package:safe2biz/app/global/core/core.dart' hide RadioGroup;
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/area_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/page/sincronizar_page.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

class FormDetailAyC extends StatefulWidget {
  FormDetailAyC({
    Key? key,
    required this.actoCondicion,
  }) : super(key: key);

  final ActoCondicion actoCondicion;

  @override
  State<FormDetailAyC> createState() => _FormDetailAyCState();
}

class _FormDetailAyCState extends State<FormDetailAyC> {

  final ValueNotifier<int> corrigioSelected = ValueNotifier<int>(0); // 1=Sí, 0=No
  final formKey = GlobalKey<FormState>();
  final _sizedBoxKey = GlobalKey();
  final _sizedBoxSecondKey = GlobalKey();
  final _scrollCtrl = ScrollController();
  final ValueNotifier<int> origenSelected = ValueNotifier<int>(1); // 1=Acto, 2=Condición
  final ValueNotifier<int> tarjetaRojaSelected = ValueNotifier<int>(1);
  final ValueNotifier<int> interiorMinaSelected = ValueNotifier<int>(1);
  final interiorMinaNivelTxt = TextEditingController();
  final interiorMinaLaborTxt = TextEditingController();
  final interiorMinaNumeroLaborTxt = TextEditingController();
  // Visibilidad de los campos de Interior Mina segun flag_mina_interior del area.
  bool _esInteriorMina = false;
  late String _idSede;
  DateTime dateSelected = DateTime.now();
  final empleadoTxt = TextEditingController();
  String idEmpleado = '0';
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
 // final origenSelected = ValueNotifier<int>(1);
  final descripcionTxt = TextEditingController();
  final lugarTxt = TextEditingController();
  String idLugar = '';
  final tipoEventoTxt = TextEditingController();
  String idTipoEvento = '';
  final nivelRiesgoTxt = TextEditingController();
  String idNivelRiesgo = '';
  final accionInmediataTxt = TextEditingController();


  final bsafTxt = TextEditingController();
  String idBsaf = '';

 // final corrigioSelected = ValueNotifier<int>(1);
  String? img1;
  final file1 = ValueNotifier<File?>(null);
  String? img1Name;
  final file2 = ValueNotifier<File?>(null);
  String? img2;
  String? img2Name;
  late LatLng? currentPosition;

  bool _initMap = true;
  //==========================CONECTION NETWORK==============================
  ValueNotifier<bool> isNet = ValueNotifier<bool>(false);
  bool _init = true;
  late StreamSubscription<bool> streamConection;
  // -------------------------------------------
  // --------------- LIST SELECT ---------------
  // -------------------------------------------
  List<Option<Area>> listAreasOp = [];
  List<Option<Gerencia>> listGerenciasOp = [];
  List<Option<EmpresaEsp>> listEmpresasOp = [];
  List<Option<Desviacion>> listDesviacionesOp = [];
  List<Option<TipoEvento>> listTipoEventosOp = [];
  List<Option<NivelRiesgo>> listNivelRiesgosOp = [];
  List<Option<Empleado>> listEmpleadosOp = [];
  List<Option<Bsaf>> listBsafOp = [];


  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    _initTextControllers();
    try {
      final instanceNet = GetIt.I<ConnectivityStatus>()..initialize();
      streamConection = instanceNet.connectionChange.listen(_checkedConection);
    } catch (e, t) {
      print('Ups algo error $ConnectivityStatus');
    }
    // });
    super.initState();
  }

  Future<void> _initTextControllers() async {
    final ayc = widget.actoCondicion;

    debugPrint('=== [FormDetailAyC] actoCondicion cargado desde SQLite ===');
    debugPrint('id:                    ${ayc.id}');
    debugPrint('descripcion:           ${ayc.descripcion}');
    debugPrint('lugar:                 ${ayc.lugar}');
    debugPrint('area:                  ${ayc.fbAreaNombre} (id: ${ayc.fbAreaId})');
    debugPrint('fecha:                 ${ayc.fecha} ${ayc.hora}');
    debugPrint('tarjetaRoja:           ${ayc.tarjetaRoja}');
    debugPrint('interiorMina:          ${ayc.interiorMina}');
    debugPrint('interiorMinaNivel:     "${ayc.interiorMinaNivel}"');
    debugPrint('interiorMinaLabor:     "${ayc.interiorMinaLabor}"');
    debugPrint('interiorMinaNumeroLabor: "${ayc.interiorMinaNumeroLabor}"');
    debugPrint('latitud:               ${ayc.latitud}');
    debugPrint('longitud:              ${ayc.longitud}');
    debugPrint('estado:                ${ayc.estado}');
    debugPrint('=== [FormDetailAyC] fin ===');

    _idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '0';

    currentPosition = LatLng(
      double.tryParse(ayc.latitud) ?? 0.0,
      double.tryParse(ayc.longitud) ?? 0.0,
    );

    empleadoTxt.text = ayc.fbEmpleadoNombre;
    idEmpleado = ayc.fbEmpleadoId;
    tarjetaRojaSelected.value = ayc.tarjetaRoja == '0' ? 0 : 1;
    desviacionTxt.text = ayc.gTipoCausaNombre;
    gerenciaTxt.text = ayc.fbGerenciaNombre;
    idGerencia = ayc.fbGerencia;
    areaTxt.text = ayc.fbAreaNombre;
    idArea = ayc.fbAreaId;
    empresaTxt.text = ayc.fbEmpresaEspecializadaNombre;
    idEmpresa = ayc.fbEmpresaEspecializadaId;
    fechaTxt.text = ayc.fecha;
    horaTxt.text = ayc.hora;
    descripcionTxt.text = ayc.descripcion;
    lugarTxt.text = ayc.lugar;
    tipoEventoTxt.text = ayc.tipoEventoNombre;
    idTipoEvento = ayc.tipoEventoId;
    nivelRiesgoTxt.text = ayc.nivelRiesgoNombre;
    idNivelRiesgo = ayc.nivelRiesgoId;
    accionInmediataTxt.text = ayc.accionEjec;
    interiorMinaSelected.value = ayc.interiorMina == '0' ? 0 : 1;
    // El registro ya trae si es interior mina; mostramos los campos acorde.
    _esInteriorMina = ayc.interiorMina == '1';
    interiorMinaNivelTxt.text = ayc.interiorMinaNivel;
    interiorMinaLaborTxt.text = ayc.interiorMinaLabor;
    interiorMinaNumeroLaborTxt.text = ayc.interiorMinaNumeroLabor;
    corrigioSelected.value = ayc.corrigio == '0' ? 1 : 0;

    if (mounted) setState(() {});

    if (ayc.fotoPreEventoRuta.isNotEmpty) {
      img1 = ayc.fotoPreEventoRuta;
      img1Name = ayc.fotoPreEventoNombre;
      file1.value = await Utils.stringBase64ToFile(
        image: ayc.fotoPreEventoRuta,
        name: ayc.fotoPreEventoNombre,
      );
    }
    if (ayc.fotoEventoRuta.isNotEmpty) {
      img2 = ayc.fotoEventoRuta;
      img2Name = ayc.fotoEventoNombre;
      file2.value = await Utils.stringBase64ToFile(
        image: ayc.fotoEventoRuta,
        name: ayc.fotoEventoNombre,
      );
    }
  }

  void _checkedConection(bool value) {
    if (_init) {
      if (!value) {
        context
            .read<DetailAycBloc>()
            .add(InitEv(actoCondicion: widget.actoCondicion));
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
  void dispose() {
    streamConection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final min = size.height * 0.35;
    final max = size.height * 0.60;

    return BlocConsumer<DetailAycBloc, DetailAycState>(
      listener: (context, state) {
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


          if (state.desviaciones.isEmpty) {
            SyncDataScreen.show(
              context: context,
              onTap: () async {
                final result = await Nav.go(
                  context,
                  const SincronizarPage(),
                );

                if (result != null && result as bool) {
                  Nav.back(context);
                  context
                      .read<DetailAycBloc>()
                      .add(InitEv(actoCondicion: widget.actoCondicion));
                }
              },
              onClosed: () {
                Nav.back(context);
                Nav.back(context);
              },
            );
          }


        }
      },
      buildWhen: (previous, current) => current != previous,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(S2BSpacing.lg),
              child: TextLabel.body(
                'Actos y Condiciones Inseguras',
                color: S2BColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: S2BSpacing.xs,
                ),
                decoration: const BoxDecoration(
                  color: S2BColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      S2BRadius.lg,
                    ),
                  ),
                ),
                child: Form(
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
                          height: S2BSpacing.sm,
                        ),
/*
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
                        */

                        const SizedBox(
                          height: S2BSpacing.sm,
                        ),
                        /*
                        const SizedBox(
                          height: S2BSpacing.lg,
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
                        */

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


                        /*
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
                        */
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
                        SizedBox(
                          key: _sizedBoxKey,
                          height: S2BSpacing.md,
                        ),

                        ValueListenableBuilder<int>(
                          valueListenable: tarjetaRojaSelected,
                          builder: (_, value, __) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('¿Requiere Tarjeta Roja?:'),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<int>(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        title: const Text('Si'),
                                        value: 1,
                                        groupValue: value,
                                        onChanged: (v) {
                                          if (v != null) tarjetaRojaSelected.value = v;
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<int>(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        title: const Text('No'),
                                        value: 0,
                                        groupValue: value,
                                        onChanged: (v) {
                                          if (v != null) tarjetaRojaSelected.value = v;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        // Solo visible cuando el area tiene flag_mina_interior = 1.
                        if (_esInteriorMina) ...[
                          const SizedBox(
                            height: S2BSpacing.xs,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputTextField(
                                controller: interiorMinaNivelTxt,
                                placeholder: 'Interior Mina Nivel',
                              ),
                              const SizedBox(height: S2BSpacing.lg),
                              InputTextField(
                                controller: interiorMinaLaborTxt,
                                placeholder: 'Interior Mina Labor',
                              ),
                              // Campo "Interior Mina Número de Labor" oculto a pedido.
                              /*
                              const SizedBox(height: S2BSpacing.lg),
                              InputTextField(
                                controller: interiorMinaNumeroLaborTxt,
                                placeholder: 'Interior Mina Número de Labor',
                              ),
                              */
                            ],
                          ),
                          const SizedBox(
                            height: S2BSpacing.lg,
                          ),
                        ],

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
                            initPosition: currentPosition,
                            onMapCreated: () {
                              if (_initMap) {
                                _initMap = false;
                                context.read<DetailAycBloc>().add(
                                      InitEv(
                                        actoCondicion: widget.actoCondicion,
                                      ),
                                    );
                              }
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
                        ValueListenableBuilder<File?>(
                          valueListenable: file2,
                          builder: (context, img, _) {
                            return ItemPhoto(
                              title: 'Foto 2',
                              imageInitial: img,
                              onChange: (file) {
                                if (file != null) {
                                  file2.value = file;
                                }
                              },
                              showError: true,
                            );
                          },
                        ),
                        if (widget.actoCondicion.estado != '1')
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: S2BSpacing.lg),
                            child: BtnDefault(
                              UiValues.guardar,
                              onTap: () => _edit(context),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
        return ItemSelect(item.nombreCompleto);
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
    debugPrint('=== [_selectArea DETAIL] ===');
    debugPrint('_idSede: $_idSede');

    if (listAreasOp.isEmpty) {
      try {
        final rows = await LocalSqlite().getAreas();
        debugPrint('Filas crudas en FB_AREA: ${rows.length}');
        if (rows.isNotEmpty) debugPrint('Primera fila Area: ${rows.first}');

        final items = rows.map((r) {
          final a = AreaModel.fromJson(r);
          return Option<Area>(a.nombre, a);
        }).toList();
        items.sort((a, b) => a.label.compareTo(b.label));
        listAreasOp = items;
      } catch (e, st) {
        debugPrint('ERROR cargando Areas: $e\n$st');
        return;
      }
    }

    debugPrint('listAreasOp total: ${listAreasOp.length}');

    final ueaBaseId = await LocalSqlite().getUeaBaseId(_idSede);
    debugPrint('fb_uea_base_id para sede $_idSede: $ueaBaseId');

    final filteredAreas = ueaBaseId.isEmpty
        ? listAreasOp
        : listAreasOp.where((e) => e.value.fb_uea_base_id == ueaBaseId).toList();

    debugPrint('Áreas filtradas por fb_uea_base_id: ${filteredAreas.length}');
    debugPrint('=== [fin _selectArea DETAIL] ===');

    PopupSelect.show<Area>(
      title: 'Areas',
      context: context,
      initialList: filteredAreas,
      onSelect: (String value, Area item) {
        setState(() {
          areaTxt.text = item.nombre;
          idArea = item.id;
          // Si el area tiene flag_mina_interior = 1 se muestran los campos de
          // Interior Mina. En otra area, ocultamos y limpiamos esos campos.
          if (item.flagMinaInterior == '1') {
            _esInteriorMina = true;
            interiorMinaSelected.value = 1;
          } else {
            _esInteriorMina = false;
            interiorMinaSelected.value = 0;
            interiorMinaNivelTxt.clear();
            interiorMinaLaborTxt.clear();
            interiorMinaNumeroLaborTxt.clear();
          }
        });
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



  void _selectBsaf(BuildContext context) async {
    PopupSelect.show<Bsaf>(
      title: 'BSAF',
      context: context,
      initialList: listBsafOp,
      onSelect: (String value, Bsaf item) {
        bsafTxt.text = item.nombre;
        idBsaf = item.inc_bsaf_id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, Bsaf item) {
        return ItemSelect(item.nombre);
      },
    );
  }

  void _inputChange() {
    context.read<DetailAycBloc>().add(
          ChangeDataEv(
            id: widget.actoCondicion.id,
            origen: null,
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
            corrigio: null,
            // TODO: REVISAR ESTO CESAR ESTA QUEMADO
            tipoEventoId: "27",
            tipoEventoNombre: "Seguridad",
            nivelRiesgoId: null,
            nivelRiesgoNombre: null,
            accionEjec: null,
            fbEmpresaEspecializadaId: null,
            fbEmpresaEspecializadaNombre: null,

            latitud:
                currentPosition != null ? '${currentPosition!.latitude}' : '0',
            longitud:
                currentPosition != null ? '${currentPosition!.longitude}' : '0',
            //fbEmpleadoId: idEmpleado,
            fbEmpleadoNombre: empleadoTxt.text,
            fbUeaPeId: _idSede,
            bsafId: null,
            tarjetaRoja: tarjetaRojaSelected.value.toString(),
            interiorMina: interiorMinaSelected.value.toString(),
            interiorMinaNivel: interiorMinaNivelTxt.text,
            interiorMinaLabor: interiorMinaLaborTxt.text,
            interiorMinaNumeroLabor: interiorMinaNumeroLaborTxt.text,
            estado: '0',
          ),
        );
  }

  void _edit(BuildContext context) async {
    _inputChange();
    if (!formKey.currentState!.validate()) {
      return;
    }

    context.read<DetailAycBloc>().add(
          EditActoCondicionEv(
            file1: file1.value,
            file2: file2.value,
          ),
        );
  }
}
