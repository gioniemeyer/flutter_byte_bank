import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'transaction_images.dart';
import 'transaction_form.dart';
import 'transaction_controller.dart';

class Transaction extends StatelessWidget {
  final String selectedItem; // "Início" | "Transferências" | "Investimentos"

  const Transaction({super.key, required this.selectedItem});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    final editingId = controller.editingId;

    return SizedBox(
      height: 655, // mobile
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Imagens decorativas (agora recebe selectedItem)
          TransactionImages(selectedItem: selectedItem),

          // Conteúdo
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Título
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    '${editingId != null ? "Editar" : "Nova"} transação',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      color: AppColors.thirdText,
                    ),
                  ),
                ),

                // Formulário
                TransactionForm(
                  onCancel: () {
                    // Aqui você pode navegar, fechar modal, etc.
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
