import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'transaction_controller.dart';
import 'transaction.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionController(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: const SafeArea(
          child: Center(
            child: Transaction(
              selectedItem: 'Transferências', // ou 'Início'
            ),
          ),
        ),
      ),
    );
  }
}
