import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/app_controller.dart';
import 'package:safe2biz/app/global/core/utils/utils.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/planes_accion/data/models/models.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/features/detail_planes_accion/presenter/bloc/detail_sac_bloc.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

class FormDetailSAC extends StatefulWidget {
  FormDetailSAC({
    Key? key,
    required this.planAccion,
  }) : super(key: key);

  final PlanAccion planAccion;

  @override
  State<FormDetailSAC> createState() => _FormDetailSACState();
}

class _FormDetailSACState extends State<FormDetailSAC> {
  final formKey = GlobalKey<FormState>();
  DateTime dateSelected = DateTime.now();
  final empleadoTxt = TextEditingController();
  String idEmpleado = '0';
  String codigo = '';
  String descripcion = '';
  String origen = '';
  String fecha = '';
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
  final file1 = ValueNotifier<File?>(null);
  String? img1;
  String? img1Name;
  late LatLng? currentPosition;

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

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    _initTextControllers();
    // });
    super.initState();
  }

  Future<void> _initTextControllers() async {
    final sac = widget.planAccion;
    codigo = sac.codigo;
    descripcion = sac.detalle;
    origen = sac.origen;
    fecha = sac.fechaEjec;
    descripcionTxt.text = sac.obsRespCorr;
    if (sac.evidenciaNombre.isNotEmpty) {
      print("️ hello ${sac.evidenciaRuta}");
      file1.value = await Utils.stringBase64ToFile(
        image: sac.evidenciaRuta,
        name: sac.evidenciaNombre,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<DetailSACBloc, DetailSACState>(
      buildWhen: (previous, current) => current != previous,
      builder: (context, state) {
        if (state is Loading) {
          return const Center(
            child: LoadingContainer(
              color: S2BColors.white,
            ),
          );
        }

        if (state is Loaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(S2BSpacing.lg),
                child: TextLabel.body(
                  'PLANES DE ACCIÓN',
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
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: S2BSpacing.md,
                    ).copyWith(
                      bottom: S2BSpacing.zero,
                    ),
                    children: [
                      Form(
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
                                  child: Table(
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: IntrinsicColumnWidth(),
                                      1: FlexColumnWidth(),
                                    },
                                    border: TableBorder.all(
                                        color: S2BColors.background,
                                        style: BorderStyle.none,
                                        width: 2),
                                    children: [
                                      TableRow(children: [
                                        Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.all(10.0),
                                            color: S2BColors.background,
                                            child: const Text(
                                              "Código: ",
                                              textAlign: TextAlign.right,
                                            )),
                                        Container(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(codigo)),
                                      ]),
                                      TableRow(children: [
                                        Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.all(10.0),
                                            color: S2BColors.background,
                                            child: const Text(
                                              "Descripción: ",
                                              textAlign: TextAlign.right,
                                            )),
                                        Container(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(descripcion)),
                                      ]),
                                      TableRow(children: [
                                        Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.all(10.0),
                                            color: S2BColors.background,
                                            child: const Text(
                                              "Origen: ",
                                              textAlign: TextAlign.right,
                                            )),
                                        Container(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(origen)),
                                      ]),
                                      TableRow(children: [
                                        Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.all(10.0),
                                            color: S2BColors.background,
                                            child: const Text(
                                              "Fecha: ",
                                              textAlign: TextAlign.right,
                                            )),
                                        Container(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(fecha)),
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: S2BSpacing.md,
                            ),
                            InputTextField(
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
                            ValueListenableBuilder<File?>(
                              valueListenable: file1,
                              builder: (context, img, _) {
                                //FIXME: Imagen no carga cuando editas
                                /*if (img == null) {
                                  return SizedBox.shrink();
                                }*/
                                return ItemPhoto(
                                  title: 'Foto 1',
                                  imageInitial: img,
                                  onChange: (file) {
                                    if (file != null) {
                                      file1.value = file;
                                    }
                                  },
                                  showError: img1 == null ? true : false,
                                );
                              },
                            ),
                            /*const SizedBox(
                              height: S2BSpacing.lg,
                            ),
                            ValueListenableBuilder<File?>(
                              valueListenable: file2,
                              builder: (context, img, _) {
                                return ItemPhoto(
                                  title: 'Foto 2',
                                  imageInitial: img,
                                  onChange: (base64, fileName) {
                                    img2 = base64;
                                    img2Name = fileName;
                                  },
                                  showError: true,
                                );
                              },
                            ),*/
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
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
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

  void _inputChange() {
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '0';

    context.read<DetailSACBloc>().add(
      ChangeDataEv(
        id: widget.planAccion.id,
        codigo: widget.planAccion.codigo,
        fechaEjec: widget.planAccion.fechaEjec,
        responsable: widget.planAccion.responsable,
        origen: widget.planAccion.origen,
        detalle: widget.planAccion.detalle,
        fechaEjecucion: fechaTxt.text,
        obsRespCorr: descripcionTxt.text,
        fechaOrigen: widget.planAccion.fechaOrigen,
        responsableVerificador: widget.planAccion.responsableVerificador,
        estado: '0',
        ueaId: idSede,
      ),
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
    context.read<DetailSACBloc>().add(
      EditPlanAccionEv(
        file1: file1.value!,
      ),
    );
  }

/*void _edit(BuildContext context) async {
    bool isValidate = true;
    if (!formKey.currentState!.validate()) {
      isValidate = false;
    }

    if (file1.value == null) {
      isValidate = false;
    }

    if (!isValidate) {
      return;
    }
    final app = GetIt.I<AppController>();

    final imgResult1 = await app.transformImage(file1.value!);
    img1Name = imgResult1.nameFile;
    img1 = imgResult1.base64;

    final planAccion = PlanesAccionModel(
      id: widget.planAccion.id,
      codigo: widget.planAccion.codigo,
      fechaEjec: widget.planAccion.fechaEjec,
      responsable: widget.planAccion.responsable,
      origen: widget.planAccion.origen,
      detalle: widget.planAccion.detalle,
      fechaEjecucion: fechaTxt.text,
      obsRespCorr: descripcionTxt.text,
      estado: '0',
      ueaId: idSede,
      evidenciaNombre: img1Name ?? '',
      evidenciaRuta: img1 ?? '',
    );

    context.read<DetailSACBloc>().add(
          EditPlanAccionEv(
            planAccion: planAccion,
          ),
        );
  }*/
}

class ItemElement extends StatelessWidget {
  ItemElement({
    Key? key,
    required this.quota,
    required this.onTapOk,
  }) : super(key: key);

  final String quota;
  final void Function(String?) onTapOk;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(quota),
            ],
          ),
        ),
        const Divider(
          color: S2BColors.silver,
        ),
      ],
    );
  }
}