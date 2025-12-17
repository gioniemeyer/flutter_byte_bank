import 'package:flutter/material.dart';

/// Componente que exibe as imagens decorativas do formulário de transação (mobile).
/// Assume sempre mobile. Usa assets declarados em pubspec.yaml.
class TransactionImages extends StatelessWidget {
  final String selectedItem; // "Início" | "Transferências" | "Investimentos"

  const TransactionImages({super.key, required this.selectedItem});

  bool get _showIllustration =>
      selectedItem == 'Início' || selectedItem == 'Transferências';

  @override
  Widget build(BuildContext context) {
    // Este widget deve ser usado dentro de um Stack
    return Stack(
      children: [
        // Pixel superior (mobile) — top-left
        Positioned(
          top: 0,
          left: 0,
          width: 146,
          height: 144,
          child: Image.asset('assets/images/pixels3.png', fit: BoxFit.contain),
        ),

        // Pixel inferior (mobile) — bottom-right
        Positioned(
          bottom: 0,
          right: 0,
          width: 146,
          height: 144,
          child: Image.asset('assets/images/pixels2.png', fit: BoxFit.contain),
        ),

        // Ilustração (mobile) — aparece para "Início" e "Transferências"
        if (_showIllustration)
          Positioned(
            bottom: 28,
            right: 16,
            width: 280,
            height: 231,
            child: Image.asset(
              'assets/images/illustration2.png',
              fit: BoxFit.contain,
            ),
          ),
      ],
    );
  }
}
