import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/components/welcome.dart';
import 'package:mobile_byte_bank/transactions/transaction.dart';
import 'package:mobile_byte_bank/transactions/transaction_controller.dart';
import 'package:provider/provider.dart';

/// Caixa central da aplicação. Ajusta estilo com base no content.
/// Suporta: 'welcome' | 'transaction' | 'investments'
class CentralBox extends StatelessWidget {
  final String content;
  final String? selectedItem; // novo: repassar do ContentBody

  const CentralBox({super.key, required this.content, this.selectedItem});

  @override
  Widget build(BuildContext context) {
    const lateralPadding = 16.0;
    const topOffset = 24.0;

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
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String nome = user?.displayName ?? 'Usuário';
    final controller = context.watch<TransactionController>();

    switch (content) {
      case 'welcome':
        return StreamBuilder(
          stream: controller.watchTransactions(),
          builder: (context, snapshot) {
            final transactions = snapshot.data ?? [];

            double total = 0;
            for (final t in transactions) {
              if (t.type == 'Depósito') {
                total += t.value;
              } else if (t.type == 'Transferência') {
                total -= t.value;
              }
            }

            return Welcome(
              userName: nome,
              balance: total,
            );
          },
        );

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
