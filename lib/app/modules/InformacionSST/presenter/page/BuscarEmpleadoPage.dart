import 'package:flutter/material.dart';

/// Pantalla independiente para buscar empleado por DNI.
/// - Muestra AppBar con back.
/// - Caja de búsqueda con campo DNI + botón "play" para ejecutar búsqueda.
/// - Placeholder central "Buscar empleado".
/// - Valida longitud (8) y solo dígitos.
/// - Cierra teclado y evita pantallazos negros en back.
class BuscarEmpleadoPage extends StatefulWidget {
  /// Callback opcional que se invoca al buscar (si no lo pasas, solo muestra SnackBar).
  final Future<void> Function(String dni)? onSearch;

  /// Título del AppBar.
  final String title;

  const BuscarEmpleadoPage({
    super.key,
    this.onSearch,
    this.title = 'GOLDEN',
  });

  @override
  State<BuscarEmpleadoPage> createState() => _BuscarEmpleadoPageState();
}

class _BuscarEmpleadoPageState extends State<BuscarEmpleadoPage> {
  final _dniCtrl = TextEditingController();
  final _dniFocus = FocusNode();

  @override
  void dispose() {
    _dniCtrl.dispose();
    _dniFocus.dispose();
    super.dispose();
  }

  Future<void> _doSearch() async {
    final dni = _dniCtrl.text.trim();

    // Validaciones simples
    final isDigits = RegExp(r'^\d+$').hasMatch(dni);
    if (dni.isEmpty || dni.length != 8 || !isDigits) {
      _showSnack('Ingrese un DNI válido de 8 dígitos');
      return;
    }

    // Cerrar teclado antes de navegar/consultar
    FocusScope.of(context).unfocus();
    await Future<void>.delayed(const Duration(milliseconds: 60));

    if (widget.onSearch != null) {
      await widget.onSearch!(dni);
    } else {
      _showSnack('Buscando DNI $dni ... (implementa onSearch para acción real)');
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Al presionar back (gesto nativo o botón del AppBar)
      canPop: true,
      onPopInvoked: (didPop) async {
        // Cierra IME si está abierto para evitar glitch de insets
        FocusManager.instance.primaryFocus?.unfocus();
        await Future<void>.delayed(const Duration(milliseconds: 40));
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEFF3FB), // un gris azulado suave
        appBar: AppBar(
          backgroundColor: const Color(0xFF0E4C8A), // azul corporativo
          elevation: 0,
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () async {
              // Cierra teclado primero
              FocusManager.instance.primaryFocus?.unfocus();
              await Future<void>.delayed(const Duration(milliseconds: 40));
              if (mounted) Navigator.of(context).maybePop();
            },
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _SearchBar(
                  controller: _dniCtrl,
                  focusNode: _dniFocus,
                  hint: 'Ingresar DNI ...',
                  onSubmit: _doSearch,
                  onTapPlay: _doSearch,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.manage_search_rounded,
                          size: 96, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Buscar empleado',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Ingrese el DNI del empleado para iniciar la búsqueda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Caja de búsqueda redondeada con TextField y botones laterales.
/// (Interna a este archivo para mantener “todo en una sola clase” a nivel de módulo)
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hint;
  final Future<void> Function()? onSubmit;
  final Future<void> Function()? onTapPlay;

  const _SearchBar({
    required this.controller,
    this.focusNode,
    required this.hint,
    this.onSubmit,
    this.onTapPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Colors.black54),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  isDense: true,
                ),
                onSubmitted: (_) async => await onSubmit?.call(),
              ),
            ),
            IconButton(
              tooltip: 'Buscar',
              icon: const Icon(Icons.play_arrow_rounded, color: Colors.black54),
              onPressed: () async => await onTapPlay?.call(),
            ),
            // Ícono decorativo tipo "filtros" como en tu UI original (sin acción)
            const Icon(Icons.tune_rounded, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
