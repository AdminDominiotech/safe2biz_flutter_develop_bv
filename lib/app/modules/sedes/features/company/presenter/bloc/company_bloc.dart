import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'package:safe2biz/app/modules/sedes/features/company/data/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/company/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/bloc/sincronizar_bloc.dart';
part 'company_event.dart';
part 'company_state.dart';

typedef CompanyEmitter = Emitter<CompanyState>;

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {

  CompanyBloc() : super(Init()) {
    on<InitEv>(_onInitEv);

  }



  Future<void> _onInitEv(InitEv ev, CompanyEmitter emit) async {
    emit(Loading());
    emit(CloseLoading());
    emit(Successful(modules: resultModules));
  }
}
