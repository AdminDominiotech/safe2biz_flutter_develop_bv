part of 'ops_bloc.dart';

abstract class OpsEvent extends Equatable {
  const OpsEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends OpsEvent {}
