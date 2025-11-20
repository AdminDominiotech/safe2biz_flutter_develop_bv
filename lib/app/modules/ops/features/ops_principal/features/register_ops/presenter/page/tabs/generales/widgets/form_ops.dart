import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/bloc/tab_generales/bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

import '../../../../../../../../../../actos_condiciones_bot/presenter/page/actos_condiciones_page.dart';

class FormOPS extends StatefulWidget {
  final int? ops_tipo_checklist_id;
  final int? ops_sub_tipo_id;


  FormOPS({
    Key? key,

    required this.pageArgs,
    this.ops_tipo_checklist_id,
    this.ops_sub_tipo_id
  }) : super(key: key);

  final RegisterOpsPrincipalPageArgs pageArgs;
  final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';

  @override
  State<FormOPS> createState() => _FormOPSState();
}
List<Map<String,String>> _responsables = [];


class _FormOPSState extends State<FormOPS> {


// Mapa de visibilidad por subtipo
  static const Map<int, Set<String>> _fieldRules = {
    7: {'area','fecha','tipo','alcanceIns','responsable','inspectores'},
    1: {'fecha','area','involucrados'},
    2: {'area','fecha','involucrados'},
    3: {'empresa','fecha','verificador','responsable'},
    4: {'empresa','fecha','responsable','auditor'},
    6: {
      'contratista','area','tipoServicio','fecha','alcance','auditor',
      'equipoAuditor','criterio','personalAuditado'
    },
    5: {'fecha','empresa'},
  };

  Set<String> _initialVisible() {
    // Subtipo es SIEMPRE visible en el build; aquí solo devolvemos otros campos.
    return (widget.ops_tipo_checklist_id ?? 0) == 4
        ? const {'fecha', 'tipo'}
        : const {'fecha'};
  }

// === Ajusta _visibleKeys() para usar el "por defecto" anterior ===
  Set<String> _visibleKeys() {
    final sid = int.tryParse(idSubTipo);
    if (sid == null) {
      // Aún no se ha elegido subtipo → usa visibilidad inicial según checklist
      return _initialVisible();
    }
    // Ya hay subtipo → aplica mapa de reglas (y si no hay regla, cae al default)
    return _fieldRules[sid] ?? _initialVisible();
  }

  bool _show(String k) => _visibleKeys().contains(k);




  final formKey = GlobalKey<FormState>();
  final _sizedBoxKey = GlobalKey();
  final _scrollCtrl = ScrollController();
  DateTime dateSelected = DateTime.now();

  final areaTxt = TextEditingController();

  String idArea = '';

  final empresaTxt = TextEditingController();

  String idEmpresa = '';

  final fechaTxt = TextEditingController(text: DateTime.now().formatLocalFech);

  final turnoTxt = TextEditingController();

  String idTurno = '';

  late LatLng? currentPosition;

  final alcanceTxt = TextEditingController();
  final criterioTxt = TextEditingController();

  // -------------------------------------------
  List<Option<Area>> listAreasOp = [];

  List<Option<EmpresaEsp>> listEmpresasOp = [];

  List<Option<Turno>> listTurnos = [];

  final subTipoTxt = TextEditingController();
  String idSubTipo = '';
  bool _subtipoBloqueado = false; // <- NUEVO

  List<Option<Map<String,String>>> listSubTiposOp = [];
  List<Map<String,String>> _subTipos = [];

  final responsableTxt = TextEditingController();
  String idResponsable = '';

  final List<Map<String, String>> tmp = [];
  List<Map<String,String>> _responsables = [];


  // Controllers para los combos
  final tipoTxt = TextEditingController();
  final alcanceInsTxt = TextEditingController();

// IDs seleccionados
  String idTipoInspeccion = '';
  String idAlcanceInspeccion = '';

// Listas para PopupSelect (sin modelos, usamos Map<String,String>)
  List<Option<Map<String,String>>> listTiposOp = [];
  List<Option<Map<String,String>>> listAlcancesOp = [];


  // Nuevo: Verificador
  final verificadorTxt = TextEditingController();
  String idVerificador = '';

  final auditorTxt = TextEditingController();
  String idAuditor = '';

  final involucradosTxt = TextEditingController();
  final inspectoresTxt  = TextEditingController();

  // NUEVOS CAMPOS
  final contratistaTxt = TextEditingController();
  String idContratista = '';

  final tipoServicioTxt = TextEditingController();     // texto simple
  final equipoAuditorTxt = TextEditingController();    // textarea
  final personalAuditadoTxt = TextEditingController(); // textarea



  String _gtoWhereClause({String? keepId}) {
    final isChecklist4 = (widget.ops_tipo_checklist_id ?? 0) == 4;
    final base = isChecklist4
        ? "TRIM(IFNULL(g_tipo_origen_id, '')) = '22'"
        : "TRIM(IFNULL(g_tipo_origen_id, '')) <> '22'";
    return keepId != null && keepId.isNotEmpty
        ? "AND ( $base OR TRIM(ops_sub_tipo_id) = '$keepId' )"
        : "AND $base";
  }

  void _clearHiddenFields() {
    final keep = _visibleKeys();

    if (!keep.contains('fecha')) fechaTxt.clear();
    if (!keep.contains('area')) { areaTxt.clear(); idArea = ''; }
    if (!keep.contains('tipo')) { tipoTxt.clear(); idTipoInspeccion = ''; }
    if (!keep.contains('alcanceIns')) { alcanceInsTxt.clear(); idAlcanceInspeccion = ''; }
    if (!keep.contains('empresa')) { empresaTxt.clear(); idEmpresa = ''; }

    if (!keep.contains('responsable')) { responsableTxt.clear(); idResponsable = ''; }
    if (!keep.contains('verificador')) { verificadorTxt.clear(); idVerificador = ''; }
    if (!keep.contains('auditor')) { auditorTxt.clear(); idAuditor = ''; }

    // Textareas existentes
    if (!keep.contains('alcance'))  alcanceTxt.clear();
    if (!keep.contains('criterio')) criterioTxt.clear();
    if (!keep.contains('involucrados')) involucradosTxt.clear();
    if (!keep.contains('inspectores'))  inspectoresTxt.clear();

    // NUEVOS
    if (!keep.contains('contratista')) { contratistaTxt.clear(); idContratista = ''; }
    if (!keep.contains('tipoServicio')) tipoServicioTxt.clear();
    if (!keep.contains('equipoAuditor')) equipoAuditorTxt.clear();
    if (!keep.contains('personalAuditado')) personalAuditadoTxt.clear();
  }



  Future<void> _loadResponsablesFromDb() async {
    final rows = await localSqliteInstance.readData(
        'SELECT fb_empleado_id, nombre_responsable '
            'FROM ${LocalSqlite.TABLE_RESPONSABLE} '
            'WHERE TRIM(nombre_responsable) <> "" '
            'ORDER BY nombre_responsable COLLATE NOCASE;'
    );

    final vistos = <String>{};
    final tmp = <Map<String,String>>[];

    for (final r in rows) {
      final id  = (r['fb_empleado_id'] ?? '').toString().trim();
      final nom = (r['nombre_responsable'] ?? '').toString().trim();
      if (id.isEmpty || nom.isEmpty) continue;
      if (vistos.add(id)) tmp.add({'id': id, 'nombre': nom});
    }

    setState(() => _responsables = tmp);
  }


  void _scrollUp() async {
    _scrollCtrl.animateTo(
      0.0,
      duration: Duration(
        milliseconds: 350,
      ),
      curve: Curves.elasticIn,
    );
  }

  void _scrollDown() async {
    Scrollable.ensureVisible(
      _sizedBoxKey.currentContext!,
      duration: const Duration(milliseconds: 350),
      curve: Curves.elasticOut,
    );
  }

  @override
  void didUpdateWidget(covariant FormOPS oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ops_sub_tipo_id != widget.ops_sub_tipo_id) {
      final pre = widget.ops_sub_tipo_id ?? 0;
      setState(() {
        if (pre > 0) {
          idSubTipo = pre.toString();
          _subtipoBloqueado = true;
        } else {
          idSubTipo = '';
          _subtipoBloqueado = false;
          subTipoTxt.clear();
        }
      });
      _loadSubTiposFromDb();
      _prefillSubtipoFromParam();
    }
  }

  @override
  void initState() {
    super.initState();

    // 1) Si llega un subtipo por parámetro, lo fijamos y BLOQUEAMOS el campo
    final pre = widget.ops_sub_tipo_id ?? 0;
    if (pre > 0) {
      idSubTipo = pre.toString();
      _subtipoBloqueado = true;
    } else {
      idSubTipo = '';
      _subtipoBloqueado = false;
      subTipoTxt.clear();
    }

    _initPicklists();
    _loadSubTiposFromDb();   // usa keepId=idSubTipo
    _prefillSubtipoFromParam();
  }

  Future<void> _initPicklists() async {
    await _loadTiposFromDb();
    await _loadAlcancesFromDb();
    if (mounted) setState(() {});
  }

  Future<void> _prefillSubtipoFromParam() async {
    if (idSubTipo.isEmpty) return;
    // Usa rawQuery o interpola si tu helper no acepta args
    final rows = await localSqliteInstance.readData(
        'SELECT nombre FROM ${LocalSqlite.TABLE_OPS_SUB_TIPO} '
            'WHERE TRIM(ops_sub_tipo_id) = "$idSubTipo" LIMIT 1;'
    );
    if (rows.isNotEmpty) {
      final nom = (rows.first['nombre'] ?? '').toString().trim();
      if (mounted && nom.isNotEmpty) setState(() => subTipoTxt.text = nom);
    }
  }

  Widget _buildSubtipoField(BuildContext context) {
    // Opción A (simple): anular el onTap si está bloqueado
    return InputTextField(
      key: const ValueKey('subtipo'),
      controller: subTipoTxt,
      readOnly: true,
      onTap: _subtipoBloqueado ? null : () => _selectSubTipo(context),
      validator: (v) => v.isEmpty ? 'Seleccione' : null,
      placeholder: "Subtipo de inspección",

    );


  }

  @override
  Widget build(BuildContext context) {


    print('ops_tipo_checklist_id --- ${widget.ops_tipo_checklist_id}');


    final size = MediaQuery.of(context).size;
    final min = size.height * 0.35;
    final max = size.height * 0.60;
    return BlocConsumer<TabOpsBloc, TabOpsState>(
      listener: (context, state) {
        if (state is Loaded) {
          listTurnos = state.turnos.map((e) => Option(e.nombre, e)).toList();
          listAreasOp = state.areas.map((e) => Option(e.nombre, e)).toList();
          listEmpresasOp =
              state.empresas.map((e) => Option(e.razonSocial, e)).toList();
        }
      },
      builder: (context, state) {
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

              if (_show('fecha'))
        ...[
                InputTextField(
                  key: const ValueKey('fecha'),
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
        ],
                const SizedBox(
                  height: S2BSpacing.lg,
                ),


                _buildSubtipoField(context),

                if (_show('tipo'))
                  ...[
                    InputTextField(
                      key: const ValueKey('tipo'),
                      controller: tipoTxt,
                      readOnly: true,
                      onTap: () => _selectTipo(context),
                      validator: (v) => v.isEmpty ? 'Seleccione' : null,
                      placeholder: "Tipo de inspección",
                    ),

                    const SizedBox(height: S2BSpacing.lg),

                  ],
                const SizedBox(
                  height: S2BSpacing.lg,
                ),

        if (_show('responsable'))
        ...[
                InputTextField(
                  key: const ValueKey('responsable'),
                  controller: responsableTxt,
                  readOnly: true,
                  onTap: () => _selectResponsable(context),
                  validator: (value) => value.isEmpty ? 'Seleccione' : null,
                  placeholder: "Responsable",
                  trailingIcon: const InputTrailingIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: S2BColors.primaryColor,
                  ),
                ),

                const SizedBox(
                  height: S2BSpacing.lg,
                ),
                ],


// Verificador
                if (_show('verificador')) ...[
                  InputTextField(
                    key: const ValueKey('verificador'),
                    controller: verificadorTxt,
                    readOnly: true,
                    onTap: () => _selectVerificador(context),
                    validator: (v) => v.isEmpty ? 'Seleccione' : null,
                    placeholder: "Verificador",
                    trailingIcon: const InputTrailingIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: S2BColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: S2BSpacing.lg),
                ],

                // Contratista (mismo picker que Responsable)
                if (_show('contratista')) ...[
                  InputTextField(
                    key: const ValueKey('contratista'),
                    controller: contratistaTxt,
                    readOnly: true,
                    onTap: () => _selectContratista(context), // usa el picker de responsables
                    validator: (v) => v.isEmpty ? 'Seleccione' : null,
                    placeholder: "Contratista",
                    trailingIcon: const InputTrailingIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: S2BColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: S2BSpacing.lg),
                ],


// Auditor
                if (_show('auditor')) ...[
                  InputTextField(
                    key: const ValueKey('auditor'),
                    controller: auditorTxt,
                    readOnly: true,
                    onTap: () => _selectAuditor(context),
                    validator: (v) => v.isEmpty ? 'Seleccione' : null,
                    placeholder: "Auditor",
                    trailingIcon: const InputTrailingIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: S2BColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: S2BSpacing.lg),
                ],


              if (_show('empresa'))
              ...[
                InputTextField(
                  key: const ValueKey('empresa'),
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
              ],

        if (_show('alcanceIns'))
        ...[
                InputTextField(
                  key: const ValueKey('alcanceIns'),
                  controller: alcanceInsTxt,
                  readOnly: true,
                  onTap: () => _selectAlcanceIns(context),
                  validator: (v) => v.isEmpty ? 'Seleccione' : null,
                  placeholder: "Alcance de inspección",
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
                ),
        ],
        if (_show('area'))
        ...[

                InputTextField(
                  key: const ValueKey('area'),
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
                  placeholder: "Área",
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
                ),
      ],
                // Involucrados
                if (_show('involucrados')) ...[
                  InputTextField(
                    key: const ValueKey('involucrados'),
                    controller: involucradosTxt,
                    minLines: 2,
                    maxLines: 3,
                    validator: (v) => v.isEmpty ? 'Requerido' : null,
                    placeholder: "Involucrados",
                  ),
                  const SizedBox(height: S2BSpacing.lg),
                ],

// Inspectores
                if (_show('inspectores')) ...[
                  InputTextField(
                    key: const ValueKey('inspectores'),
                    controller: inspectoresTxt,
                    minLines: 2,
                    maxLines: 3,
                    validator: (v) => v.isEmpty ? 'Requerido' : null,
                    placeholder: "Inspectores",
                  ),
                  const SizedBox(height: S2BSpacing.lg),
                ],

        /* Tipo Servicio (texto normal)
                        if (_show('tipoServicio')) ...[
                          InputTextField(
                            key: const ValueKey('tipoServicio'),
                            controller: tipoServicioTxt,
                            validator: (v) => v.isEmpty ? 'Requerido' : null,
                            placeholder: "Tipo Servicio",
                          ),
                          const SizedBox(height: S2BSpacing.lg),
                        ],

         */

// Equipo Auditor (textarea)
                if (_show('equipoAuditor')) ...[
                  InputTextField(
                    key: const ValueKey('equipoAuditor'),
                    controller: equipoAuditorTxt,
                    minLines: 2, maxLines: 3,
                    validator: (v) => v.isEmpty ? 'Requerido' : null,
                    placeholder: "Equipo Auditor",
                  ),
                  const SizedBox(height: S2BSpacing.lg),
                ],

// Personal Auditado (textarea)
                if (_show('personalAuditado')) ...[
                  InputTextField(
                    key: const ValueKey('personalAuditado'),
                    controller: personalAuditadoTxt,
                    minLines: 2, maxLines: 3,
                    validator: (v) => v.isEmpty ? 'Requerido' : null,
                    placeholder: "Personal Auditado",
                  ),
                  const SizedBox(height: S2BSpacing.lg),
                ],

                if (_show('alcance')) ...[
                Column(
                  children: [
                    InputTextField(
                      key: const ValueKey('alcance'),
                      controller: alcanceTxt,
                      minLines: 2,
                      maxLines: 3,
                      validator: (v) => v.isEmpty ? 'Requerido' : null,
                      placeholder: "Alcance",
                    ),
                  ],
                ),
                const SizedBox(height: S2BSpacing.lg),
        ],

        if (_show('criterio')) ...[
                Column(
                  children: [
                    InputTextField(
                      key: const ValueKey('criterio'),
                      controller: criterioTxt,
                      minLines: 2,
                      maxLines: 3,
                      validator: (v) => v.isEmpty ? 'Requerido' : null,
                      placeholder: "Criterios de Auditoría",
                    ),
                  ],
                ),
                const SizedBox(
                  height: S2BSpacing.lg,
                ),
        ], const SizedBox(
                  height: S2BSpacing.xs,
                ),
                Align(
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
                if (state is SavedListaVerificacion)
                  BtnDefault(
                    'Editar',
                    // paddingH: S2BSpacing.xxsl,
                    onTap: () => _edit(context, state.idGeneral),
                  )
                else
                  BtnDefault(
                    UiValues.guardar,
                    // paddingH: S2BSpacing.xxsl,
                    onTap: () => _save(context),
                  ),
                SizedBox(
                  key: _sizedBoxKey,
                  height: S2BSpacing.lg,
                ),
              ],
            ),
          ),

        );
      },
    );
  }

  void _selectArea(BuildContext context) async {
    PopupSelect.show<Area>(
      title: 'Areas',
      context: context,
      initialList: listAreasOp,
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





  Future<void> _loadTiposFromDb() async {
    final rows = await localSqliteInstance.readData(
        'SELECT ops_tipo_inspeccion_id, nombre '
            'FROM ${LocalSqlite.TABLE_OPS_TIPO} '
            'WHERE TRIM(nombre) <> "" '
            'ORDER BY nombre COLLATE NOCASE;'
    );

    final vistos = <String>{};
    final tmp = <Option<Map<String,String>>>[];

    for (final r in rows) {
      final id  = (r['ops_tipo_inspeccion_id'] ?? '').toString().trim();
      final nom = (r['nombre'] ?? '').toString().trim();
      if (id.isEmpty || nom.isEmpty) continue;
      if (!vistos.add(id)) continue;

      tmp.add(Option<Map<String,String>>(nom, {'id': id, 'nombre': nom}));
    }
    listTiposOp = tmp;
  }

  Future<void> _loadAlcancesFromDb() async {
    final rows = await localSqliteInstance.readData(
        'SELECT ops_alcance_inspeccion_id, nombre '
            'FROM ${LocalSqlite.TABLE_OPS_ALCANCE} '
            'WHERE TRIM(nombre) <> "" '
            'ORDER BY nombre COLLATE NOCASE;'
    );

    final vistos = <String>{};
    final tmp = <Option<Map<String,String>>>[];

    for (final r in rows) {
      final id  = (r['ops_alcance_inspeccion_id'] ?? '').toString().trim();
      final nom = (r['nombre'] ?? '').toString().trim();
      if (id.isEmpty || nom.isEmpty) continue;
      if (!vistos.add(id)) continue;

      tmp.add(Option<Map<String,String>>(nom, {'id': id, 'nombre': nom}));
    }
    listAlcancesOp = tmp;
  }


  Future<void> _loadSubTiposFromDb() async {
    final whereGto = _gtoWhereClause(keepId: idSubTipo);
    final rows = await localSqliteInstance.readData(
        'SELECT ops_sub_tipo_id, nombre, IFNULL(g_tipo_origen_id,"") AS g_tipo_origen_id '
            'FROM ${LocalSqlite.TABLE_OPS_SUB_TIPO} '
            'WHERE TRIM(nombre) <> "" $whereGto '
            'ORDER BY nombre COLLATE NOCASE;'
    );

    final vistos = <String>{};
    final tmp = <Map<String,String>>[];
    for (final r in rows) {
      final id  = (r['ops_sub_tipo_id'] ?? '').toString().trim();
      final nom = (r['nombre'] ?? '').toString().trim();
      final gto = (r['g_tipo_origen_id'] ?? '').toString().trim();
      if (id.isEmpty || nom.isEmpty) continue;
      if (vistos.add(id)) tmp.add({'id': id, 'nombre': nom, 'g_tipo_origen_id': gto});
    }
    if (mounted) setState(() => _subTipos = tmp);
  }

  Future<void> _loadSubTipos() async {
    final whereGto = _gtoWhereClause(keepId: idSubTipo);
    final rows = await localSqliteInstance.readData(
        'SELECT ops_sub_tipo_id, nombre, IFNULL(g_tipo_origen_id,"") AS g_tipo_origen_id '
            'FROM ${LocalSqlite.TABLE_OPS_SUB_TIPO} '
            'WHERE TRIM(nombre) <> "" $whereGto '
            'ORDER BY nombre COLLATE NOCASE;'
    );

    final vistos = <String>{};
    final tmp = <Option<Map<String,String>>>[];
    for (final r in rows) {
      final id   = (r['ops_sub_tipo_id'] ?? '').toString().trim();
      final nom  = (r['nombre'] ?? '').toString().trim();
      final gto  = (r['g_tipo_origen_id'] ?? '').toString().trim();
      if (id.isEmpty || nom.isEmpty) continue;
      if (!vistos.add(id)) continue;

      tmp.add(Option<Map<String,String>>(nom, {'id': id, 'nombre': nom, 'g_tipo_origen_id': gto}));
    }
    if (mounted) setState(() => listSubTiposOp = tmp);
  }



  String gTipoOrigenId = '';

  void _selectSubTipo(BuildContext context) async {
    if (listSubTiposOp.isEmpty) {
      await _loadSubTipos();
      if (listSubTiposOp.isEmpty) {
        Toast.show(description: 'No hay subtipos', toastType: ToastType.info);
        return;
      }
    }

    PopupSelect.show<Map<String,String>>(
      title: 'Subtipos de inspección',
      context: context,
      initialList: listSubTiposOp,
      onSelect: (String value, Map<String,String> item) {
        setState(() {
          subTipoTxt.text = item['nombre'] ?? value;
          idSubTipo       = item['id'] ?? '';
          _clearHiddenFields(); // aplica tus reglas de visibilidad
        });
        Navigator.pop(context);
      },
      itemBuilder: (_, it) => ItemSelect(it['nombre'] ?? ''),
    );
  }


  void _selectTipo(BuildContext context) {
    if (listTiposOp.isEmpty) {
      Toast.show(description: 'No hay tipos', toastType: ToastType.info);
      return;
    }
    PopupSelect.show<Map<String,String>>(
      title: 'Tipo de inspección',
      context: context,
      initialList: listTiposOp,
      onSelect: (String value, Map<String,String> item) {
        tipoTxt.text = item['nombre'] ?? value;
        idTipoInspeccion = item['id'] ?? '';
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, Map<String,String> item) {
        return ItemSelect(item['nombre'] ?? '');
      },
    );
  }

  void _selectAlcanceIns(BuildContext context) {
    if (listAlcancesOp.isEmpty) {
      Toast.show(description: 'No hay alcances', toastType: ToastType.info);
      return;
    }
    PopupSelect.show<Map<String,String>>(
      title: 'Alcance de inspección',
      context: context,
      initialList: listAlcancesOp,
      onSelect: (String value, Map<String,String> item) {
        alcanceInsTxt.text = item['nombre'] ?? value;
        idAlcanceInspeccion = item['id'] ?? '';
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, Map<String,String> item) {
        return ItemSelect(item['nombre'] ?? '');
      },
    );
  }



  Future<void> _selectResponsable(BuildContext context) async {
    if (_responsables.isEmpty) await _loadResponsablesFromDb();
    if (_responsables.isEmpty) {
      Toast.show(description: 'No hay responsables', toastType: ToastType.info);
      return;
    }

    final picked = await showModalBottomSheet<Map<String,String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _RespPickerMap(items: _responsables),
    );

    if (picked != null) {
      setState(() {
        idResponsable = picked['id']!;
        responsableTxt.text = picked['nombre']!;
      });
    }
  }

  Future<void> _selectVerificador(BuildContext context) async {
    if (_responsables.isEmpty) await _loadResponsablesFromDb();
    if (_responsables.isEmpty) {
      Toast.show(description: 'No hay verificadores', toastType: ToastType.info);
      return;
    }

    final picked = await showModalBottomSheet<Map<String,String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _RespPickerMap(items: _responsables),
    );

    if (picked != null) {
      setState(() {
        idVerificador = picked['id']!;
        verificadorTxt.text = picked['nombre']!;
      });
    }
  }

  Future<void> _selectAuditor(BuildContext context) async {
    if (_responsables.isEmpty) await _loadResponsablesFromDb();
    if (_responsables.isEmpty) {
      Toast.show(description: 'No hay auditores', toastType: ToastType.info);
      return;
    }

    final picked = await showModalBottomSheet<Map<String,String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _RespPickerMap(items: _responsables),
    );

    if (picked != null) {
      setState(() {
        idAuditor = picked['id']!;
        auditorTxt.text = picked['nombre']!;
      });
    }
  }

  Future<void> _selectContratista(BuildContext context) async {
    // Asegura que haya data (se llena en el listener del BLoC)
    if (listEmpresasOp.isEmpty) {
      Toast.show(description: 'No hay empresas', toastType: ToastType.info);
      return;
    }

    PopupSelect.show<EmpresaEsp>(
      title: 'Contratista (Empresas)',
      context: context,
      initialList: listEmpresasOp,
      onSelect: (String value, EmpresaEsp item) {
        setState(() {
          contratistaTxt.text = item.razonSocial; // nombre visible
          idContratista = item.id;                // id para guardar (ops_contratista_id)
        });
        Navigator.pop(context);
      },
      itemBuilder: (BuildContext context, EmpresaEsp item) {
        return ItemSelect(item.razonSocial);
      },
    );
  }



  void _save(BuildContext context) {
    bool isValidate = true;
    if (!formKey.currentState!.validate()) {
      isValidate = false;
    }

    if (!isValidate) {
      return;
    }


    final registroGeneral = RegistroGeneral(
      id: 0,
      fbUeaPeId: widget.idSede,
      codigo: "",
      gTipoOrigenId: (widget.ops_tipo_checklist_id).toString(),
      fechaOps: fechaTxt.text,
      horaOps: "",
      turno: idTurno,
      fbAreaId: idArea,
      alcance: alcanceTxt.text,
      criterio: criterioTxt.text,

      fbEmpleadoId: idResponsable,
      fbEmpleadoNombreCompleto: responsableTxt.text,

      gRolEmpresaId: "",
      fbEmpresaEspecializadaId: idEmpresa,

      opsListaVerificacionId: widget.pageArgs.verificationId,
      opsTipoResultadoId: widget.pageArgs.idResultadoOps,
      latitud: currentPosition != null ? '${currentPosition!.latitude}' : '0',
      longitud: currentPosition != null ? '${currentPosition!.longitude}' : '0',
      fbAreaNombre: areaTxt.text,
      turnoNombre: turnoTxt.text,
      fbEmpresaEspecializadaNombre: empresaTxt.text,

      idGeneradoSyncronizacion: "",
      estado: "0",
      flag: "",
      idOpsAlcanceInspeccion: idAlcanceInspeccion,
      idOpsSubTipoInspeccion: idSubTipo,
      idOpsTipoInspeccion: idTipoInspeccion,

      OpsAlcanceInspeccionText: alcanceInsTxt.text,
      OpsTipoInspeccionText: tipoTxt.text,
      OpsSubTipoInspeccionText:subTipoTxt.text,

      fbAuditorId:  idAuditor,
      auditorNombre: auditorTxt.text,
      involucrados: involucradosTxt.text,
      inspectores:  inspectoresTxt.text,
      fbVerificadorId: idVerificador,
      verificadorNombre: verificadorTxt.text,

      personalAuditado: personalAuditadoTxt.text,
      tipoServicioNombre: tipoServicioTxt.text,
      opsContratistaId: idContratista,

      contratistaNombre: contratistaTxt.text,

      equipoAuditor: equipoAuditorTxt.text,



    );

    context.read<TabOpsBloc>().add(
          SaveListaVerificacionEv(registroGeneral: registroGeneral),
        );

    print(" GUARDADO ! ");
  }

  void _edit(BuildContext context, String id) {

    print(" ID PARA EDITAR: $id");
  }
}


class _RespPickerMap extends StatefulWidget {
  const _RespPickerMap({Key? key, required this.items}) : super(key: key);
  final List<Map<String,String>> items;

  @override
  State<_RespPickerMap> createState() => _RespPickerMapState();
}

class _RespPickerMapState extends State<_RespPickerMap> {
  final _search = TextEditingController();
  late List<Map<String,String>> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _search.addListener(_onSearch);

  }

  @override
  void dispose() {
    _search.removeListener(_onSearch);
    _search.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _norm(_search.text);
    setState(() {
      _filtered = widget.items.where((e) => _norm(e['nombre'] ?? '').contains(q)).toList();
    });
  }

  String _norm(String s) => s
      .toLowerCase()
      .trim()
      .replaceAll('á','a').replaceAll('é','e').replaceAll('í','i')
      .replaceAll('ó','o').replaceAll('ú','u').replaceAll('ñ','n');

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * .75;

    return SafeArea(
      top: false,
      child: SizedBox(
        height: h,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InputTextField(
                controller: _search,
                placeholder: 'Buscar responsable',
                trailingIcon: const InputTrailingIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: S2BColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final it = _filtered[i];
                  return ListTile(
                    dense: true,
                    title: Text(it['nombre'] ?? '', style: const TextStyle(fontSize: 14)),
                    onTap: () => Navigator.pop(context, it),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

