import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/components/central_box.dart';
import 'package:mobile_byte_bank/statement/statement.dart';

/// Corpo principal da aplicação (mobile).
class ContentBody extends StatelessWidget {
  final String selectedItem;

  const ContentBody({super.key, required this.selectedItem});

  bool get _showTransaction =>
      selectedItem == 'Início' || selectedItem == 'Transferências';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Largura disponível e altura disponível do body
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: maxWidth,
              minHeight: maxHeight, // força altura mínima igual à tela
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CentralBox(content: 'welcome'),
                CentralBox(
                  content: _showTransaction ? 'transaction' : 'investments',
                  selectedItem: selectedItem,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Statement(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
