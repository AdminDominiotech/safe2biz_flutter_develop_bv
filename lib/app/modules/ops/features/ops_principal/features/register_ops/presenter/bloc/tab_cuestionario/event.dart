part of 'bloc.dart';

abstract class TabCuestionarioEvent extends Equatable {
  const TabCuestionarioEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends TabCuestionarioEvent {
  const InitEv(this.verificationId);
  final String verificationId;
  @override
  List<Object> get props => [verificationId];
}
