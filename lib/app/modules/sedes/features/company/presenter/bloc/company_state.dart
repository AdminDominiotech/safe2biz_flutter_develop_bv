part of 'company_bloc.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object> get props => [];
}

class Init extends CompanyState {}

class Loading extends CompanyState {}

class CloseLoading extends CompanyState {
  const CloseLoading();
}

class Successful extends CompanyState {
  const Successful({required this.modules});
  final List<ItemModule> modules;

  @override
  List<Object> get props => [modules];
}
