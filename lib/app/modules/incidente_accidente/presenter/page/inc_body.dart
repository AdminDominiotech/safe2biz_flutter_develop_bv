import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/register_incidente_accidente/presenter/page/page.dart';
import 'package:safe2biz/app/modules/incidente_accidente/presenter/widgets/widgets.dart';
import 'package:safe2biz/app/modules/incidente_accidente/presenter/bloc/inc_bloc.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:intl/intl.dart' as intl;
class INCBody extends StatefulWidget {

  const INCBody({Key? key}) : super(key: key);
  @override
  _INCBodyState createState() => _INCBodyState();
}

class _INCBodyState extends State<INCBody> {
  List<IncidenteAccidente> incidentesAccidentesOrdenados = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<INCBloc>();
      bloc.stream.listen((state) {
        if (state is Loaded) {
          setState(() {
            incidentesAccidentesOrdenados = List<IncidenteAccidente>.from(state.model.incidentesAccidentes)
              ..sort((a, b) => _parseDateTime(b.fecha, b.hora).compareTo(_parseDateTime(a.fecha, a.hora)));
          });
        }
      });
    });
  }

  DateTime _parseDateTime(String dateStr, String timeStr) {
    try {
      // Combina fecha y hora en un solo DateTime
      return intl.DateFormat("yyyy-MM-dd HH:mm:ss").parse('$dateStr $timeStr');
    } catch (e) {
      // Manejo de excepciones en caso de formato incorrecto
      return DateTime.now(); // Retorna la fecha y hora actual como fallback
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<INCBloc, INCState>(
      listener: (context, state) {
        // Handle different states here
      },
      child: Scaffold(
        backgroundColor: S2BColors.background,
        body: CustomScrollView(
          slivers: [
            _buildPersistentHeader(size),
            _buildList(),
          ],
        ),
      ),
    );
  }

  SliverPersistentHeader _buildPersistentHeader(Size size) {
    return SliverPersistentHeader(
      delegate: SliverBarBack(
        maxExtended: size.height * .190,
        minExtended: kToolbarHeight,
        size: size,
        title: LocalPreferences.prefs?.getString('current_sede') ?? '',
        label: 'Incidentes y Accidentes',
        showAction: incidentesAccidentesOrdenados.any((inc) => inc.estado == '0'),
        onTapAction: _onTapAction,
        onFloatingTap: _onFloatingTap,
      ),
    );
  }

  void _onTapAction() {
    // Define what to do when tap action is triggered
  }

  void _onFloatingTap() async {
    await Nav.go(
      context,
      BlocProvider.value(
        value: context.read<INCBloc>(),
        child: const RegisterINCPage(),
      ),
    );
  }

  Widget _buildList() {
    if (incidentesAccidentesOrdenados.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const EmptyData(),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return ItemINC(incidenteAccidente: incidentesAccidentesOrdenados[index]);
          },
          childCount: incidentesAccidentesOrdenados.length,
        ),
      );
    }
  }
}
