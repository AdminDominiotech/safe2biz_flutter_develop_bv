import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityStatus {
  // --- Singleton ---
  ConnectivityStatus._();
  static final ConnectivityStatus _instance = ConnectivityStatus._();
  factory ConnectivityStatus() => _instance;
  static ConnectivityStatus getInstance() => _instance;

  // --- Estado interno ---
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connSub;

  String _lookUpAddress = 'google.com';

  // Stream público para notificar cambios de conectividad real (true/false)
  final StreamController<bool> connectionChangeController =
  StreamController<bool>.broadcast();

  bool hasConnection = true;

  Stream<bool> get connectionChange => connectionChangeController.stream;

  /// Inicializa la suscripción y hace un chequeo inicial.
  Future<void> initialize({String lookUpAddress = 'google.com'}) async {
    _lookUpAddress = lookUpAddress;

    // Evitar múltiples suscripciones
    await _connSub?.cancel();

    _connSub = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) async {
        final hasAnyTransport =
        results.any((r) => r != ConnectivityResult.none);

        if (!hasAnyTransport) {
          hasConnection = false;
          connectionChangeController.add(false);
        } else {
          // Hay alguna interfaz activa: validamos salida a Internet
          await checkConnection();
        }
      },
      onError: (_) {
        hasConnection = false;
        connectionChangeController.add(false);
      },
      cancelOnError: false,
    );

    // Chequeo inicial
    await checkConnection();
  }

  /// Valida salida a Internet con un DNS lookup al host configurado.
  Future<bool> checkConnection() async {
    assert(_lookUpAddress.isNotEmpty, 'lookUpAddress no debe ser vacío');
    try {
      final result = await InternetAddress.lookup(_lookUpAddress);
      hasConnection = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      hasConnection = false;
    }
    connectionChangeController.add(hasConnection);
    return hasConnection;
  }

  /// Cierra recursos.
  Future<void> dispose() async {
    await _connSub?.cancel();
    await connectionChangeController.close();
  }
}
