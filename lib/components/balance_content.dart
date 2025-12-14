import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_byte_bank/theme/colors.dart';

class BalanceContent extends StatefulWidget {
  final double balance;

  const BalanceContent({super.key, required this.balance});

  @override
  State<BalanceContent> createState() => _BalanceContentState();
}

class _BalanceContentState extends State<BalanceContent> {
  bool showBalance = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // centraliza no eixo X
        children: [
          // Linha título + botão visibilidade (já centralizada)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Saldo',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => setState(() => showBalance = !showBalance),
                iconSize: 20,
                icon: Icon(
                  showBalance ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),

          // Divider centralizado
          SizedBox(
            width: 180,
            child: Divider(
              thickness: 2,
              color: AppColors.primaryText,
              height: 16,
            ),
          ),

          const SizedBox(height: 8),

          // Textos centralizados
          const Text(
            'Conta Corrente',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppColors.primaryText,
            ),
          ),
          Text(
            showBalance ? _formatBRL(widget.balance) : '••••••',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 32,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  String _formatBRL(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: r'R$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }
}
