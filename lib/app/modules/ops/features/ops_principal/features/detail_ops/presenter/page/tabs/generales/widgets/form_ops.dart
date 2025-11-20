import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/bloc/tab_generales/bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/models/page_arguments.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/ui/module_ui.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../../../../../../InformacionSST/presenter/page/DatosTrabajador.dart';
import '../../../../../../../../../../capacitacion/presenter/page/SearchPage.dart';

class FormOPS extends StatefulWidget {
  final int? ops_tipo_checklist_id;

  FormOPS({
    Key? key,
    required this.registroGeneral,
    this.ops_tipo_checklist_id
  }) : super(key: key);

  final RegistroGeneral registroGeneral;


  @override
  State<FormOPS> createState() => _FormOPSState();
}

class _FormOPSState extends State<FormOPS> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final _sizedBoxKey = GlobalKey();
  final _scrollCtrl = ScrollController();
  DateTime dateSelected = DateTime.now();
  final LocalSqlite _localDb = LocalSqlite();
  final areaTxt = TextEditingController();

  String idArea = '';

  final empresaTxt = TextEditingController();


  String idEmpresa = '';

  final fechaTxt = TextEditingController(text: DateTime
      .now()
      .formatLocalFech);

  final turnoTxt = TextEditingController();

  String idTurno = '';

  late LatLng? currentPosition;

  // -------------------------------------------
  List<Option<Area>> listAreasOp = [];

  List<Option<EmpresaEsp>> listEmpresasOp = [];

  List<Option<Turno>> listTurnos = [];

  String idRegistro = '0';
  String area = '';
  String empresa = '';
  String turno = '';
  String fecha = '';

  final subTipoTxt = TextEditingController();
  String idSubTipo = '';
  List<Option<Map<String,String>>> listSubTiposOp = [];
  List<Map<String,String>> _subTipos = [];



  final responsableTxt = TextEditingController();
  String idResponsable = '';

  final List<Map<String, String>> tmp = [];
  List<Map<String,String>> _responsables = [];

  final alcanceTxt = TextEditingController();
  final criterioTxt = TextEditingController();

  // Tipo (combo)
  final tipoTxt = TextEditingController();
  String idTipoInspeccion = '';
  List<Option<Map<String,String>>> listTiposOp = [];

// Alcance de inspección (combo)
  final alcanceInsTxt = TextEditingController();
  String idAlcanceInspeccion = '';
  List<Option<Map<String,String>>> listAlcancesOp = [];

  // Personas
  final verificadorTxt = TextEditingController();
  String idVerificador = '';

  final auditorTxt = TextEditingController();
  String idAuditor = '';

// TextAreas
  final involucradosTxt = TextEditingController();
  final inspectoresTxt  = TextEditingController();

  // NUEVOS CAMPOS
  final contratistaTxt = TextEditingController();
  String idContratista = '';

  final tipoServicioTxt = TextEditingController();     // texto simple
  final equipoAuditorTxt = TextEditingController();    // textarea
  final personalAuditadoTxt = TextEditingController(); // textarea




  // Reglas por Subtipo
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

// Conjunto visible según Subtipo; si no hay subtipo, mostramos solo fecha y tipo.
// Ojo: el campo "Subtipo" se deja SIEMPRE visible en el build.


  Set<String> _visibleKeys() {
    final sid = int.tryParse(idSubTipo);
    return sid == null
        ? const {'fecha','tipo'}
        : (_fieldRules[sid] ??
        const {'fecha','tipo'}); // fallback por seguridad
  }
  bool _show(String k) => _visibleKeys().contains(k);

// Validar solo si está visible
  String? _reqIfVisible(String field, String? v) =>
      _show(field) && (v == null || v.isEmpty) ? 'Seleccione' : null;

// Limpiar lo que se oculta al cambiar subtipo (recomendado)
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

  String _gtoWhereClause({String? keepId}) {
    final isChecklist4 = (widget.ops_tipo_checklist_id ?? 0) == 4;

    // Regla base:
    //  - id=4  ⇒ g_tipo_origen_id = '22'
    //  - !=4   ⇒ g_tipo_origen_id <> '22' (incluye nulos/vacíos)
    final base = isChecklist4
        ? "TRIM(IFNULL(g_tipo_origen_id, '')) = '22'"
        : "TRIM(IFNULL(g_tipo_origen_id, '')) <> '22'";

    // En edición: asegura incluir el subtipo ya guardado (si hubiera)
    if (keepId != null && keepId.isNotEmpty) {
      return "AND ( $base OR TRIM(ops_sub_tipo_id) = '$keepId' )";
    }
    return "AND $base";
  }





  Future<void> _hydrateContratistaNameById(String id) async {
    try {
      // 1) Intento por BD (ajusta nombre de tabla/columna si difiere)
      final rows = await LocalSqlite().readData(
          'SELECT razon_social AS n '
              'FROM ${LocalSqlite.TABLE_FB_EMPRESA_ESPECIALIZADA} '
              'WHERE TRIM(fb_empresa_especializada_id) = "$id" '
              'LIMIT 1;'
      );

      if (rows.isNotEmpty) {
        final nombre = (rows.first['n'] ?? '').toString().trim();
        if (mounted && nombre.isNotEmpty) {
          setState(() => contratistaTxt.text = nombre);
        }
        return; // listo
      }

      // 2) Fallback: buscar en la lista en memoria (SIN orElse)
      Option<EmpresaEsp>? match;
      for (final op in listEmpresasOp) {
        final opId = (op.value.id ?? '').toString().trim();
        if (opId == id) {
          match = op;
          break;
        }
      }

      if (mounted && match != null) {
        // según tu clase Option, label suele ser String no nulo
        final label = (match.label ?? '').toString().trim();
        if (label.isNotEmpty) {
          setState(() => contratistaTxt.text = label);
        }
      }
    } catch (e) {
      debugPrint('[_hydrateContratistaNameById] $e');
    }
  }



  @override
  void initState() {
    initTextControllers();
    _initAsync();
    super.initState();
  }

  void _initAsync() async {
    await _listarVerificaciones();
    await _loadTiposFromDb();
    await _loadAlcancesFromDb();
    await _loadSubTiposFromDb();
    await _loadResponsablesFromDb();
    await _hydrateMissingNames();
    if (mounted) setState(() {}); // <- aplica _show con idSubTipo ya cargado
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void initTextControllers() {
    final regGeneral = widget.registroGeneral;

    areaTxt.text = regGeneral.fbAreaNombre;
    idArea = regGeneral.fbAreaId;

    empresaTxt.text = regGeneral.fbEmpresaEspecializadaNombre;
    idEmpresa = regGeneral.fbEmpresaEspecializadaId;

    turnoTxt.text = regGeneral.turnoNombre;
    idTurno = regGeneral.turno;


    alcanceTxt.text = regGeneral.alcance;
    criterioTxt.text = regGeneral.criterio;


    idResponsable = (regGeneral.fbEmpleadoId ?? '').toString().trim();
    responsableTxt.text = (regGeneral.fbEmpleadoNombreCompleto ?? '').toString().trim();


    // Tipo
    idTipoInspeccion    = (regGeneral.idOpsTipoInspeccion ?? '').toString();
    tipoTxt.text        = (regGeneral.OpsTipoInspeccionText ?? '').toString();

    // Subtipo (ya lo tenías)
    idSubTipo           = (regGeneral.idOpsSubTipoInspeccion ?? '').toString();
    subTipoTxt.text     = (regGeneral.OpsSubTipoInspeccionText ?? '').toString();

    // Alcance de inspección (combo)
    idAlcanceInspeccion = (regGeneral.idOpsAlcanceInspeccion ?? '').toString();
    alcanceInsTxt.text  = (regGeneral.OpsAlcanceInspeccionText ?? '').toString();

    // Responsable (lo tuyo)
    idResponsable       = (regGeneral.fbEmpleadoId ?? '').toString().trim();
    responsableTxt.text = (regGeneral.fbEmpleadoNombreCompleto ?? '').toString().trim();

    idVerificador          = (regGeneral.fbVerificadorId ?? '').toString().trim();
    verificadorTxt.text    = (regGeneral.verificadorNombre ?? '').toString().trim();

    idAuditor              = (regGeneral.fbAuditorId ?? '').toString().trim();
    auditorTxt.text        = (regGeneral.auditorNombre ?? '').toString().trim();

    // NUEVOS: TextAreas
    involucradosTxt.text   = (regGeneral.involucrados ?? '').toString();
    inspectoresTxt.text    = (regGeneral.inspectores  ?? '').toString();

    idContratista            = (regGeneral.opsContratistaId ?? '').toString().trim();
    contratistaTxt.text      = (regGeneral.contratistaNombre ?? '').toString().trim();
    tipoServicioTxt.text     = (regGeneral.tipoServicioNombre ?? '').toString().trim();
    equipoAuditorTxt.text    = (regGeneral.equipoAuditor ?? '').toString();
    personalAuditadoTxt.text = (regGeneral.personalAuditado ?? '').toString();
    // Si hay ID pero no nombre, lo hidratamos desde SQLite (misma tabla RESPONSABLE)
    if (responsableTxt.text.isEmpty && idResponsable.isNotEmpty) {
      _hydratePersonaNameById(idResponsable, responsableTxt);
    }
    if (verificadorTxt.text.isEmpty && idVerificador.isNotEmpty) {
      _hydratePersonaNameById(idVerificador, verificadorTxt);
    }
    if (auditorTxt.text.isEmpty && idAuditor.isNotEmpty) {
      _hydratePersonaNameById(idAuditor, auditorTxt);
    }


    // Fecha (si te guardan fecha/hora aparte)
    if ((regGeneral.fechaOps ?? '').isNotEmpty) {
      fechaTxt.text = regGeneral.fechaOps!;
    }


    if (responsableTxt.text.isEmpty && idResponsable.isNotEmpty) {
      _hydrateResponsableNameById(idResponsable);
    }

    if (responsableTxt.text.isEmpty && idResponsable.isNotEmpty) {
      _hydratePersonaNameById(idResponsable, responsableTxt);
    }
    if (verificadorTxt.text.isEmpty && idVerificador.isNotEmpty) {
      _hydratePersonaNameById(idVerificador, verificadorTxt);
    }
    if (auditorTxt.text.isEmpty && idAuditor.isNotEmpty) {
      _hydratePersonaNameById(idAuditor, auditorTxt);
    }
    if (contratistaTxt.text.isEmpty && idContratista.isNotEmpty) {
      _hydrateContratistaNameById(idContratista); // ← usa la tabla de empresas
    }

  }

  Future<void> _hydratePersonaNameById(String id, TextEditingController target) async {
    try {
      final rows = await LocalSqlite().readData(
          'SELECT nombre_responsable FROM ${LocalSqlite.TABLE_RESPONSABLE} '
              'WHERE fb_empleado_id = "$id" LIMIT 1;'
      );
      if (rows.isNotEmpty) {
        final nombre = (rows.first['nombre_responsable'] ?? '').toString().trim();
        if (mounted && nombre.isNotEmpty) setState(() => target.text = nombre);
      }
    } catch (e) { debugPrint('[_hydratePersonaNameById] $e'); }
  }


  Future<void> _hydrateMissingNames() async {
    if (tipoTxt.text.trim().isEmpty && idTipoInspeccion.isNotEmpty) {
      final n = await _nameById(
        table: LocalSqlite.TABLE_OPS_TIPO,
        idField: 'ops_tipo_inspeccion_id',
        nameField: 'nombre',
        id: idTipoInspeccion,
      );
      if (n != null) tipoTxt.text = n;
    }
    if (subTipoTxt.text.trim().isEmpty && idSubTipo.isNotEmpty) {
      final n = await _nameById(
        table: LocalSqlite.TABLE_OPS_SUB_TIPO,
        idField: 'ops_sub_tipo_id',
        nameField: 'nombre',
        id: idSubTipo,
      );
      if (n != null) subTipoTxt.text = n;
    }
    if (alcanceInsTxt.text.trim().isEmpty && idAlcanceInspeccion.isNotEmpty) {
      final n = await _nameById(
        table: LocalSqlite.TABLE_OPS_ALCANCE,
        idField: 'ops_alcance_inspeccion_id',
        nameField: 'nombre',
        id: idAlcanceInspeccion,
      );
      if (n != null) alcanceInsTxt.text = n;
    }
    if (responsableTxt.text.isEmpty && idResponsable.isNotEmpty) {
      await _hydrateResponsableNameById(idResponsable); // ya la tienes
    }
  }

  Future<String?> _nameById({
    required String table,
    required String idField,
    required String nameField,
    required String id,
  }) async {
    final rows = await localSqliteInstance.readData(
      'SELECT $nameField AS n FROM $table WHERE $idField = ? LIMIT 1;',
    );
    if (rows.isNotEmpty) return (rows.first['n'] ?? '').toString().trim();
    return null;
  }


  Future<void> _hydrateResponsableNameById(String id) async {
    try {
      // Si tu readData no admite whereArgs, interpolamos (id es un texto corto)
      final rows = await LocalSqlite().readData(
          'SELECT nombre_responsable '
              'FROM ${LocalSqlite.TABLE_RESPONSABLE} '
              'WHERE fb_empleado_id = "$id" '
              'LIMIT 1;'
      );

      if (rows.isNotEmpty) {
        final nombre = (rows.first['nombre_responsable'] ?? '').toString().trim();
        if (mounted && nombre.isNotEmpty) {
          setState(() => responsableTxt.text = nombre);
        }
      }
    } catch (e) {
      // Depuración opcional
      debugPrint('[_hydrateResponsableNameById] error: $e');
    }
  }


  Future<void> _listarVerificaciones() async {
    // 1) Construye la consulta
    final sql = '''
    SELECT ops_lista_verificacion_id
    FROM ${LocalSqlite.TABLE_OPS_REGISTRO_GENERALES}
  ''';

    // 2) Debug: imprime la consulta
    print('▶️ Consulta para listar IDs: $sql');

    // 3) Ejecuta la consulta cruda
    final resultados = await LocalSqlite().readData(sql);

    // 4) Imprime el array de resultados
    print('🗒️ Lista de ops_lista_verificacion_id: $resultados');
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final min = size.height * 0.35;
    final max = size.height * 0.60;
    return BlocConsumer<TabGeneralDetailOpsBloc, TabGeneralDetailOpsState>(
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
            padding: const EdgeInsets.symmetric(
              horizontal: S2BSpacing.md,
            ),
            controller: _scrollCtrl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
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

                    Column(
                      children: [
                        InputTextField(
                          key: const ValueKey('subtipo'),
                          controller: subTipoTxt,
                          readOnly: true,
                          onTap: () => _selectSubTipo(context),
                          validator: (value) => value.isEmpty ? 'Seleccione' : null,
                          placeholder: "SubTipo de inspección",
                        ),
                        const SizedBox(height: S2BSpacing.lg,),
                      ],
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
                  ],
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      S2BSpacing.md,
                    ),
                  ),
                  child: MapView(
                    onChangePlace: (position) {
                      currentPosition = position;
                    },
                    maxHeight: max,
                    minHeight: min,
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
                if (widget.registroGeneral.estado != '1')
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: S2BSpacing.lg,
                    ),
                    child: BtnDefault(
                      UiValues.guardar,
                      onTap: () => _edit(context),
                    ),
                  ),
              ],
            ),
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
          gTipoOrigenId   = item['g_tipo_origen_id'] ?? '';
          _clearHiddenFields();
        });
        Navigator.pop(context);
      },
      itemBuilder: (_, it) => ItemSelect(it['nombre'] ?? ''),
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
        setState(() {
          tipoTxt.text = item['nombre'] ?? value;
          idTipoInspeccion = item['id'] ?? '';
        });
        Navigator.pop(context);
      },
      itemBuilder: (_, it) => ItemSelect(it['nombre'] ?? ''),
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
        setState(() {
          alcanceInsTxt.text = item['nombre'] ?? value;
          idAlcanceInspeccion = item['id'] ?? '';
        });
        Navigator.pop(context);
      },
      itemBuilder: (_, it) => ItemSelect(it['nombre'] ?? ''),
    );
  }

  Future<void> _selectVerificador(BuildContext context) async {
    if (_responsables.isEmpty) await _loadResponsablesFromDb();
    if (_responsables.isEmpty) { Toast.show(description:'No hay verificadores', toastType: ToastType.info); return; }

    final picked = await showModalBottomSheet<Map<String,String>>(
      context: context, isScrollControlled:true, backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _RespPickerMap(items: _responsables),
    );

    if (picked != null) {
      setState(() { idVerificador = picked['id']!; verificadorTxt.text = picked['nombre']!; });
    }
  }

  Future<void> _selectAuditor(BuildContext context) async {
    if (_responsables.isEmpty) await _loadResponsablesFromDb();
    if (_responsables.isEmpty) { Toast.show(description:'No hay auditores', toastType: ToastType.info); return; }

    final picked = await showModalBottomSheet<Map<String,String>>(
      context: context, isScrollControlled:true, backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _RespPickerMap(items: _responsables),
    );

    if (picked != null) {
      setState(() { idAuditor = picked['id']!; auditorTxt.text = picked['nombre']!; });
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


  Future<void> _edit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final rg0 = widget.registroGeneral; // original
    final registroGeneral = RegistroGeneral(
      id: rg0.id, // IMPORTANTE: en edición no es 0
      fbUeaPeId: rg0.fbUeaPeId,
      codigo: rg0.codigo,
      gTipoOrigenId: (widget.ops_tipo_checklist_id).toString(),

      fechaOps: fechaTxt.text,
      horaOps: "",
      turno: idTurno,
      fbAreaId: idArea,
      alcance: alcanceTxt.text,
      criterio: criterioTxt.text,

      fbEmpleadoId: idResponsable,
      fbEmpleadoNombreCompleto: responsableTxt.text,

      gRolEmpresaId: rg0.gRolEmpresaId,
      fbEmpresaEspecializadaId: idEmpresa,

      opsListaVerificacionId: rg0.opsListaVerificacionId,
      opsTipoResultadoId: rg0.opsTipoResultadoId,

      latitud: currentPosition != null ? '${currentPosition!.latitude}' : '0',
      longitud: currentPosition != null ? '${currentPosition!.longitude}' : '0',
      fbAreaNombre: areaTxt.text,
      turnoNombre: turnoTxt.text,
      fbEmpresaEspecializadaNombre: empresaTxt.text,

      idGeneradoSyncronizacion: rg0.idGeneradoSyncronizacion,
      estado: rg0.estado,
      flag: rg0.flag,

      idOpsTipoInspeccion: idTipoInspeccion,
      idOpsSubTipoInspeccion: idSubTipo,
      idOpsAlcanceInspeccion: idAlcanceInspeccion,

      OpsTipoInspeccionText: tipoTxt.text,
      OpsSubTipoInspeccionText: subTipoTxt.text,
      OpsAlcanceInspeccionText: alcanceInsTxt.text,

      fbVerificadorId: idVerificador,
      verificadorNombre: verificadorTxt.text,
      fbAuditorId: idAuditor,
      auditorNombre: auditorTxt.text,
      involucrados: involucradosTxt.text,
      inspectores: inspectoresTxt.text,

      // nuevos
      personalAuditado: personalAuditadoTxt.text,
      tipoServicioNombre: tipoServicioTxt.text,
      opsContratistaId: idContratista,
      contratistaNombre: contratistaTxt.text,
      equipoAuditor: equipoAuditorTxt.text,
    );

    try {
      final updId = await _upsertRegistroGeneralLocal(registroGeneral);
      Toast.show(description: 'Actualizado con éxito');

      if (!mounted) return;
      Navigator.pop(context, true) ; // ✅ vuelve y avisa que hubo cambios
    } catch (e) {
      Toast.show(description: 'Error al actualizar: $e', toastType: ToastType.error);
    }
  }


  Future<int> _upsertRegistroGeneralLocal(RegistroGeneral r) async {
    final db = await LocalSqlite().database;

    // Mapear el modelo a la fila (columnas EXACTAS de la tabla)
    final row = <String, Object?>{
      if ((r.id ?? 0) > 0) 'ops_registro_generales_id': r.id, // para UPDATE
      'fb_uea_pe_id'                   : r.fbUeaPeId,
      'codigo'                         : r.codigo,
      'g_tipo_origen_id'               : r.gTipoOrigenId,
      'fecha_ops'                      : r.fechaOps,
      'hora_ops'                       : r.horaOps,
      'turno'                          : r.turno,
      'fb_area_id'                     : r.fbAreaId,
      'alcance'                        : r.alcance,
      'criterio'                       : r.criterio,
      'g_rol_empresa_id'               : r.gRolEmpresaId,
      'fb_empresa_especializada_id'    : r.fbEmpresaEspecializadaId,
      'fb_empleado_id'                 : r.fbEmpleadoId,
      'ops_lista_verificacion_id'      : r.opsListaVerificacionId,
      'ops_tipo_resultado_id'          : r.opsTipoResultadoId,
      'latitud'                        : r.latitud,
      'longitud'                       : r.longitud,
      'fb_area_nombre'                 : r.fbAreaNombre,
      'turno_nombre'                   : r.turnoNombre,
      'fb_empresa_especializada_nombre': r.fbEmpresaEspecializadaNombre,
      'fb_empleado_nombre_completo'    : r.fbEmpleadoNombreCompleto,
      'id_generado_syncronizacion'     : r.idGeneradoSyncronizacion,

      // Combos (ids + textos)
      'ops_sub_tipo_inspeccion_id'     : r.idOpsSubTipoInspeccion,
      'ops_tipo_inspeccion_id'         : r.idOpsTipoInspeccion,
      'ops_alcance_inspeccion_id'      : r.idOpsAlcanceInspeccion,
      'ops_sub_tipo_inspeccion_text'   : r.OpsSubTipoInspeccionText,
      'ops_tipo_inspeccion_text'       : r.OpsTipoInspeccionText,
      'ops_alcance_inspeccion_text'    : r.OpsAlcanceInspeccionText,

      // Personas (ids + textos)
      'fb_auditor_id'                  : r.fbAuditorId,
      'auditor_nombre'                 : r.auditorNombre,
      'fb_verificador_id'              : r.fbVerificadorId,
      'verificador_nombre'             : r.verificadorNombre,

      // TextAreas (nombres correctos en la tabla)
      'ops_involucrados'               : r.involucrados,
      'ops_inspectores'                : r.inspectores,

      // Contratista + extras
      'ops_contratista_id'             : r.opsContratistaId,
      'contratista_nombre'             : r.contratistaNombre,
      'tipo_servicio_nombre'           : r.tipoServicioNombre,
      'equipo_auditor'                 : r.equipoAuditor,
      'personal_auditado'              : r.personalAuditado,

      'estado'                         : r.estado,
      'flag'                           : r.flag,
    }..removeWhere((_, v) => v == null);

    // INSERT si id <= 0, UPDATE si id > 0
    if ((r.id ?? 0) <= 0) {
      row.remove('ops_registro_generales_id'); // autoincrement
      return await db.insert(
        LocalSqlite.TABLE_OPS_REGISTRO_GENERALES,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.update(
        LocalSqlite.TABLE_OPS_REGISTRO_GENERALES,
        row,
        where: 'ops_registro_generales_id = ?',
        whereArgs: [r.id],
      );
      return r.id!;
    }
  }


  Future<void> _loadSubTipos() async {
    final whereGto = _gtoWhereClause(keepId: idSubTipo);
    final rows = await localSqliteInstance.readData(
        'SELECT ops_sub_tipo_id, nombre, IFNULL(g_tipo_origen_id, "") AS g_tipo_origen_id '
            'FROM ${LocalSqlite.TABLE_OPS_SUB_TIPO} '
            'WHERE TRIM(nombre) <> "" '
            '$whereGto '
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

      tmp.add(Option<Map<String,String>>(nom, {
        'id': id,
        'nombre': nom,
        'g_tipo_origen_id': gto,
      }));
    }
    if (mounted) setState(() => listSubTiposOp = tmp);
  }



  Future<void> _loadSubTiposFromDb() async {
    final whereGto = _gtoWhereClause(keepId: idSubTipo);
    final rows = await localSqliteInstance.readData(
        'SELECT ops_sub_tipo_id, nombre, IFNULL(g_tipo_origen_id, "") AS g_tipo_origen_id '
            'FROM ${LocalSqlite.TABLE_OPS_SUB_TIPO} '
            'WHERE TRIM(nombre) <> "" '
            '$whereGto '
            'ORDER BY nombre COLLATE NOCASE;'
    );

    final vistos = <String>{};
    final tmp = <Map<String,String>>[];

    for (final r in rows) {
      final id  = (r['ops_sub_tipo_id'] ?? '').toString().trim();
      final nom = (r['nombre'] ?? '').toString().trim();
      final gto = (r['g_tipo_origen_id'] ?? '').toString().trim();
      if (id.isEmpty || nom.isEmpty) continue;
      if (vistos.add(id)) {
        tmp.add({'id': id, 'nombre': nom, 'g_tipo_origen_id': gto});
      }
    }
    if (mounted) setState(() => _subTipos = tmp);
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
