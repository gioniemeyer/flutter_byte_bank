import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/components/central_box.dart';
import 'package:mobile_byte_bank/components/statement.dart';

/// Corpo principal da aplicação (mobile).
class ContentBody extends StatelessWidget {
  final String selectedItem; // "Início", "Transferências", "Investimentos"

  const ContentBody({super.key, required this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Box de boas-vindas (cor primária)
          const CentralBox(content: 'welcome'),

          // Box de conteúdo central (transaction/investments)
          CentralBox(
            content:
                (selectedItem == 'Início' || selectedItem == 'Transferências')
                ? 'transaction'
                : 'investments',
          ),

          Statement(),
        ],
      ),
    );
  }
}
