part of 'sincronizar_bloc.dart';

abstract class SincronizarState extends Equatable {
  const SincronizarState();

  @override
  List<Object> get props => [];
}

class Init extends SincronizarState {}

class Loading extends SincronizarState {}

class Loaded extends SincronizarState {}

class CloseLoading extends SincronizarState {
  const CloseLoading();
}

class DownloadingModulos extends SincronizarState {}

class DownloadingModuloINC extends SincronizarState {}

class DownloadingModuloAyC extends SincronizarState {}

class DownloadingModuloAC extends SincronizarState {}

class DownloadedModulos extends SincronizarState {
  const DownloadedModulos({required this.total, required this.completed});
  final int total;
  final int completed;
}

class DownloadedModuloINC extends SincronizarState {}

class DownloadedModuloAyC extends SincronizarState {}

class DownloadedModuloAC extends SincronizarState {}
