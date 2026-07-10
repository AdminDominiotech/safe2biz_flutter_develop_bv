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
import 'package:safe2biz/app/modules/actos_condiciones/data/models/bsaf.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/models/bsaf_model.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/register_acto_condicion/presenter/bloc/register_ayc_bloc.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/area_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/desviacion_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/empresa_esp_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/gerencia_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/nivel_riesgo_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/page/sincronizar_page.dart';
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

  final ValueNotifier<int> tarjetaRojaSelected = ValueNotifier<int>(1);

  final ValueNotifier<int> interiorMinaSelected = ValueNotifier<int>(1);
  final interiorMinaNivelTxt = TextEditingController();
  final interiorMinaLaborTxt = TextEditingController();
  final interiorMinaNumeroLaborTxt = TextEditingController();
  // Visibilidad de los campos de Interior Mina segun flag_mina_interior del area.
  bool _esInteriorMina = false;

  File? file1;

  String? img1;

  String? img1Name;

  File? file2;
  String? img2;

  String? img2Name;

  late LatLng? currentPosition;

  final bsafTxt = TextEditingController();
  String idBsaf = '';

  Items<Bsaf> listBsafOp = <Option<Bsaf>>[
    Option<Bsaf>('Manipulación de objetos/herramientas', BsafModel(inc_bsaf_id: '1', nombre: 'Manipulación de objetos/herramientas')),
    Option<Bsaf>('Peatonal', BsafModel(inc_bsaf_id: '2', nombre: 'Peatonal')),
    Option<Bsaf>('Lesión Ojo/Cuerpo cto sustancia/particular', BsafModel(inc_bsaf_id: '3', nombre: 'Lesión Ojo/Cuerpo cto sustancia/particular')),
    Option<Bsaf>('Músculo Esquelético', BsafModel(inc_bsaf_id: '4', nombre: 'Músculo Esquelético')),
    Option<Bsaf>('Otros', BsafModel(inc_bsaf_id: '5', nombre: 'Otros')),
  ];


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
    currentPosition = LatLng(0, 0);
    _idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '0';
    //_idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '0';
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


  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final min = size.height * 0.35;
    final max = size.height * 0.60;
    return BlocConsumer<RegisterAyCBloc, RegisterAyCState>(
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
                  context.read<RegisterAyCBloc>().add(InitEv());
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
        return Expanded(
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
                      height: S2BSpacing.md,
                    ),

                    /*
                    InputTextField(
                      controller: desviacionTxt,
                      readOnly: true,
                      onTap: () {
                        selectDesviaciones(context);
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
                    */
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
                    /*
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

                    */
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
                                      if (v != null) tarjetaRojaSelected.value = v; // ✅
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
                                      if (v != null) tarjetaRojaSelected.value = v; // ✅
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

                    // Area 603 = Mina Subterranea => es interior mina de forma
                    // implicita, por eso ya no se muestra el radio Si/No.
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
                      showError: false,
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
                      showError: false,
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
            ),
          ),
        );
      },
    );
  }

  Future<void> selectDesviaciones(BuildContext context) async {
    final ayc = origenSelected.value == 1 ? 'A' : 'C';

    if (listDesviacionesOp.isEmpty) {
      try {
        final rows = await LocalSqlite().getDesviaciones();
        final items = rows.map((r) {
          final d = DesviacionModel.fromJson(r);
          return Option<Desviacion>(d.descripcion, d);
        }).toList();

        listDesviacionesOp = items;

        print('Desviaciones cargadas: ${listDesviacionesOp.length}');
      } catch (e, st) {
        print('ERROR cargando desviaciones: $e');
        print(st);
        return;
      }
    }

    // 2) Filtrar
    final newList =
    listDesviacionesOp.where((e) => e.value.ayc == ayc).toList();

    print('Desviaciones filtradas ayc=$ayc: ${newList.length}');

    // 3) Mostrar popup
    PopupSelect.show<Desviacion>(
      title: 'Desviaciones',
      context: context,
      initialList: newList,
      onSelect: (String label, Desviacion item) {
        setState(() {
          desviacionTxt.text = item.descripcion;
          idDesviacion = item.id.toString();
        });
        _inputChange();
        Navigator.of(context).pop();
      },
      itemBuilder: (_, item) => ItemSelect(item.descripcion),
    );
  }


  void _selectGerencias(BuildContext context) async {
    final idSedeStr =
    (LocalPreferences.prefs?.getString('current_sede_id') ?? '0').trim();

    print('current_sede_id = "$idSedeStr"');
    print('listGerenciasOp total (antes) = ${listGerenciasOp.length}');

    if (listGerenciasOp.isEmpty) {
      try {
        final rows = await LocalSqlite().getGerencia();
        print('SQLite getGerencia rows = ${rows.length}');
        if (rows.isNotEmpty) print('Primera fila: ${rows.first}');

        final items = rows.map((r) {
          final g = GerenciaModel.fromJson(r);
          return Option<Gerencia>(g.nombre, g);
        }).toList();

        // ✅ aquí sí llenas la lista en memoria
        listGerenciasOp = items;

        print('listGerenciasOp total (después) = ${listGerenciasOp.length}');
      } catch (e, st) {
        print('ERROR leyendo SQLite gerencias: $e');
        print(st);
        return;
      }
    }

    // Debug: sedes presentes en data
    final sedes = listGerenciasOp
        .map((e) => e.value.fbUeaPeId.trim())
        .toSet()
        .toList();
    print('Sedes presentes en gerencias: $sedes');

    final newList = listGerenciasOp
        .where((e) => e.value.fbUeaPeId.trim() == idSedeStr)
        .toList();

    print('newList filtrada (sede=$idSedeStr) = ${newList.length}');

    PopupSelect.show<Gerencia>(
      title: 'Gerencias',
      context: context,
      initialList: newList,
      onSelect: (String label, Gerencia item) {
        gerenciaTxt.text = item.nombre;
        idGerencia = item.id;
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, Gerencia item) => ItemSelect(item.nombre),
    );
  }

  Future<void> _selectArea(BuildContext context) async {
    debugPrint('=== [_selectArea REGISTER] ===');
    debugPrint('_idSede: $_idSede');

    // ---- DEBUG: volcar contenido de tablas relevantes ----
    try {
      final ueaPeRows = await LocalSqlite()
          .readData('SELECT * FROM ${LocalSqlite.TABLE_FB_UEA_PE};');
      debugPrint('>>> FB_UEA_PE (${ueaPeRows.length} filas):');
      for (final r in ueaPeRows) {
        debugPrint('   $r');
      }

      final areaRows = await LocalSqlite()
          .readData('SELECT * FROM ${LocalSqlite.TABLE_FB_AREA};');
      debugPrint('>>> FB_AREA (${areaRows.length} filas):');
      for (final r in areaRows) {
        debugPrint('   $r');
      }

      // valores distintos de fb_uea_base_id en cada tabla
      final basePe = await LocalSqlite().readData(
          'SELECT DISTINCT fb_uea_base_id FROM ${LocalSqlite.TABLE_FB_UEA_PE};');
      debugPrint('>>> fb_uea_base_id distintos en FB_UEA_PE: $basePe');
      final baseArea = await LocalSqlite().readData(
          'SELECT DISTINCT fb_uea_base_id FROM ${LocalSqlite.TABLE_FB_AREA};');
      debugPrint('>>> fb_uea_base_id distintos en FB_AREA: $baseArea');
    } catch (e) {
      debugPrint('>>> ERROR volcando tablas: $e');
    }
    // ---- FIN DEBUG ----

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
    debugPrint('=== [fin _selectArea REGISTER] ===');

    PopupSelect.show<Area>(
      title: 'Areas',
      context: context,
      initialList: filteredAreas,
      onSelect: (String label, Area item) {
        setState(() {
          areaTxt.text = item.nombre;
          idArea = item.id;
          // Si el area tiene flag_mina_interior = 1 se muestran los campos de
          // Interior Mina. En otra area, ocultamos y limpiamos esos campos para
          // no guardar datos obsoletos.
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
      itemBuilder: (_, Area item) => ItemSelect(item.nombre),
    );
  }

  Future<void> _selectNivelRiesgo(BuildContext context) async {
    print('listNivelRiesgosOp total (antes) = ${listNivelRiesgosOp.length}');

    if (listNivelRiesgosOp.isEmpty) {
      try {
        final rows = await LocalSqlite().getNivelRiesgo();
        print('SQLite getNivelRiesgos() rows = ${rows.length}');
        if (rows.isNotEmpty) print('Primera fila NivelRiesgo: ${rows.first}');

        final items = rows.map((r) {
          final n = NivelRiesgoModel.fromJson(r); // <-- AJUSTA
          return Option<NivelRiesgo>(n.nombre, n);
        }).toList();

        listNivelRiesgosOp = items;
        print('listNivelRiesgosOp total (después) = ${listNivelRiesgosOp.length}');
      } catch (e, st) {
        print('ERROR cargando NivelRiesgo: $e');
        print(st);
        return;
      }
    }

    PopupSelect.show<NivelRiesgo>(
      title: 'Nivel de riesgo',
      context: context,
      initialList: listNivelRiesgosOp,
      onSelect: (String label, NivelRiesgo item) {
        setState(() {
          nivelRiesgoTxt.text = item.nombre;
          idNivelRiesgo = item.id;
        });
        Navigator.pop(context);
      },
      itemBuilder: (_, NivelRiesgo item) => ItemSelect(item.nombre),
    );
  }



  void _selectBsaf(BuildContext context) {
    PopupSelect.show<Bsaf>(
      title: 'BSAF',
      context: context,
      initialList: listBsafOp,
      onSelect: (String label, Bsaf item) {
        setState(() {
          bsafTxt.text = item.nombre;
          idBsaf = item.inc_bsaf_id;
        });
        Navigator.pop(context);
      },
      itemBuilder: (_, Bsaf item) => ItemSelect(item.nombre),
    );
  }

  Future<void> _selectEmpresas(BuildContext context) async {
    print('listEmpresasOp total (antes) = ${listEmpresasOp.length}');

    if (listEmpresasOp.isEmpty) {
      try {
        final rows = await LocalSqlite().getEmpresa();
        print('SQLite getEmpresas() rows = ${rows.length}');
        if (rows.isNotEmpty) print('Primera fila Empresa: ${rows.first}');

        final items = rows.map((r) {
          final e = EmpresaEspModel.fromJson(r); // <-- AJUSTA al model real
          return Option<EmpresaEsp>(e.razonSocial, e);
        }).toList();

        // opcional: ordenar por razón social
        items.sort((a, b) => a.label.compareTo(b.label));

        listEmpresasOp = items;
        print('listEmpresasOp total (después) = ${listEmpresasOp.length}');
      } catch (e, st) {
        print('ERROR cargando Empresas: $e');
        print(st);
        return;
      }
    }

    PopupSelect.show<EmpresaEsp>(
      title: 'Empresas',
      context: context,
      initialList: listEmpresasOp,
      onSelect: (String label, EmpresaEsp item) {
        setState(() {
          empresaTxt.text = item.razonSocial;
          idEmpresa = item.id;
        });
        Navigator.pop(context);
      },
      itemBuilder: (_, EmpresaEsp item) => ItemSelect(item.razonSocial),
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






  void _scrollUp() {
    _scrollCtrl.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.elasticOut,
    );
  }

  void _scrollDown() {
    _scrollCtrl.animateTo(
      _scrollCtrl.position.maxScrollExtent,
      duration: const Duration(milliseconds: 350),
      curve: Curves.elasticOut,
    );
  }

  void _inputChange() {
    final ev = ChangeDataEv(
      id: 0,
      origen: null,
      gTipoCausaId: '0', //idDesviacion,
      gTipoCausaNombre: desviacionTxt.text,
      fbGerencia: '0', //idGerencia,
      fbGerenciaNombre: gerenciaTxt.text,
      fbAreaId: idArea,
      fbAreaNombre: areaTxt.text,
      descripcion: descripcionTxt.text,
      lugar: lugarTxt.text,
      fecha: fechaTxt.text,
      hora: horaTxt.text,
      corrigio: null,
      tipoEventoId: "27",
      tipoEventoNombre: "Seguridad",
      nivelRiesgoId: null,
      nivelRiesgoNombre: null,
      accionEjec: null,
      fbEmpresaEspecializadaId: null,
      fbEmpresaEspecializadaNombre: null,
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
      fbEmpleadoNombre: empleadoTxt.text,
      fbUeaPeId: _idSede,
      bsafID: null,
      tarjetaRoja: tarjetaRojaSelected.value.toString(),
      interiorMina: interiorMinaSelected.value.toString(),
      interiorMinaNivel: interiorMinaNivelTxt.text,
      interiorMinaLabor: interiorMinaLaborTxt.text,
      interiorMinaNumeroLabor: interiorMinaNumeroLaborTxt.text,
      estado: '0',
    );

    debugPrint('*** ChangeDataEv (antes de enviar) ***');
    debugPrint('id=${ev.id}');
    debugPrint('origen=${ev.origen}');
    debugPrint('desviacionId=${ev.gTipoCausaId} | desviacionNombre=${ev.gTipoCausaNombre}');
    debugPrint('gerenciaId=${ev.fbGerencia} | gerenciaNombre=${ev.fbGerenciaNombre}');
    debugPrint('areaId=${ev.fbAreaId} | areaNombre=${ev.fbAreaNombre}');
    debugPrint('empresaId=${ev.fbEmpresaEspecializadaId} | empresaNombre=${ev.fbEmpresaEspecializadaNombre}');
    debugPrint('fecha=${ev.fecha} | hora=${ev.hora}');
    debugPrint('nivelRiesgoId=${ev.nivelRiesgoId} | nivelRiesgoNombre=${ev.nivelRiesgoNombre}');
    debugPrint('tipoEventoId=${ev.tipoEventoId} | tipoEventoNombre=${ev.tipoEventoNombre}');
    debugPrint('corrigio=${ev.corrigio} | tarjetaRoja=${ev.tarjetaRoja} | bsafID=${ev.bsafID}');
    debugPrint('empleadoNombre=${ev.fbEmpleadoNombre} | uea=${ev.fbUeaPeId}');
    debugPrint('lat=${ev.latitud} | lon=${ev.longitud}');
    debugPrint('descripcion=${ev.descripcion}');
    debugPrint('accionEjec=${ev.accionEjec}');
    debugPrint('estado=${ev.estado}');
    debugPrint('*** FIN ChangeDataEv ***');

    context.read<RegisterAyCBloc>().add(ev);
  }

  void _save(BuildContext context) async {
    bool isValidate = true;
    _inputChange();
    if (!formKey.currentState!.validate()) {
      isValidate = true;
    }

    if (file1 == null || file2 == null) {
      isValidate = true;
    }
    if (!isValidate) {
      return;
    }

    context.read<RegisterAyCBloc>().add(
          SaveActoCondicionEv(
            file1: file1,
            file2: file2,
          ),
        );
  }
}


class _RadioOption extends StatelessWidget {
  const _RadioOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<int>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }
}
