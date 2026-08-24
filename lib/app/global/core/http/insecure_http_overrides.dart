import 'dart:io';

import 'package:safe2biz/app/global/core/env/env.dart';

/// Centraliza la política de certificados TLS de la app.
///
/// Los servidores de Safe2Biz (de / test / prod) usan certificados emitidos por
/// una CA interna que no está en el trust store de Android/iOS, por lo que el
/// handshake falla con CERTIFICATE_VERIFY_FAILED. Aquí se aceptan esos
/// certificados SOLO para los hosts propios, nunca para cualquier host.
class InsecureHosts {
  InsecureHosts._();

  /// Dominios propios cuyo certificado autofirmado / de CA interna se acepta.
  static const List<String> allowedSuffixes = <String>[
    'buenaventura.pe',
  ];

  /// `true` si se debe aceptar el certificado inválido de [host].
  static bool allows(String host) {
    final String h = host.toLowerCase().trim();

    for (final String suffix in allowedSuffixes) {
      if (h == suffix || h.endsWith('.$suffix')) return true;
    }

    // Host configurado por el usuario en la pantalla de Ajustes
    // (puede ser una IP o un dominio distinto en instalaciones on-premise).
    final String? configured = _configuredHost();
    if (configured != null && configured == h) return true;

    // Desarrollo local.
    if (h == 'localhost' || h == '127.0.0.1' || h == '10.0.2.2') return true;

    return false;
  }

  static String? _configuredHost() {
    final String? raw = Env.host;
    if (raw == null || raw.trim().isEmpty) return null;

    final String normalized =
        raw.startsWith('http://') || raw.startsWith('https://')
            ? raw
            : 'https://$raw';

    return Uri.tryParse(normalized)?.host.toLowerCase();
  }

  /// Callback listo para `HttpClient.badCertificateCallback`.
  static bool badCertificateCallback(
    X509Certificate cert,
    String host,
    int port,
  ) {
    final bool allowed = allows(host);
    print('[TLS] certificado no confiable host=$host port=$port '
        '-> ${allowed ? 'ACEPTADO' : 'RECHAZADO'}');
    return allowed;
  }
}

/// Aplica [InsecureHosts] a TODOS los `HttpClient` de la app (Dio, Image.network,
/// descargas de PDF, etc.), incluso los que no configuran su adapter.
class Safe2BizHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = InsecureHosts.badCertificateCallback;
  }
}
