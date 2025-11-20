part of 'sede_bloc.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends CompanyEvent {}
