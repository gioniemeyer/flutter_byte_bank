import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/components/welcome.dart';

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
        ? AppColors.primaryColor
        : content == 'transaction'
        ? AppColors.backgroundBox
        : AppColors.primaryText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: lateralPadding),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
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
    final user = FirebaseAuth.instance.currentUser;
    final String nome = user?.displayName ?? 'Usuário';

    switch (content) {
      case 'welcome':
        return Welcome(userName: nome, balance: 1000.0);

      case 'transaction':
        return Transaction(selectedItem: selectedItem ?? 'Início');

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
