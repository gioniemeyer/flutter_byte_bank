import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/components/welcome.dart';

import 'package:mobile_byte_bank/transactions/transaction_controller.dart';
import 'package:mobile_byte_bank/transactions/transaction.dart';

/// Caixa central da aplicação. Ajusta estilo com base no content.
/// Suporta: 'welcome' | 'transaction' | 'investments'
class CentralBox extends StatelessWidget {
  final String content;
  final String? selectedItem; // novo: repassar do ContentBody

  const CentralBox({super.key, required this.content, this.selectedItem});

  @override
  Widget build(BuildContext context) {
    const lateralPadding = 16.0;
    const topOffset = 48.0;

    final bgColor = content == 'welcome'
        ? AppColors.primary
        : content == 'transaction'
        ? AppColors.backgroundBox
        : AppColors.primaryText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: lateralPadding),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: topOffset, bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (content) {
      case 'welcome':
        return const Welcome(userName: 'Joana', balance: 1000.0);

      case 'transaction':
        // Provider local apenas para o bloco de transação (sempre mobile)
        return ChangeNotifierProvider(
          create: (_) => TransactionController(),
          child: Transaction(
            selectedItem: selectedItem ?? 'Início', // repassa aqui
          ),
        );

      case 'investments':
        return const SizedBox(
          height: 200,
          child: Center(
            child: Text(
              'Investimentos (em construção)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
