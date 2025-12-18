import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_byte_bank/theme/colors.dart';

class StatementItem extends StatelessWidget {
  final int id;
  final String date; // ISO string
  final String type; // "Depósito" | "Transferência"
  final double value;
  final VoidCallback? onClick;
  final bool isClickable;
  final bool isSelected;

  const StatementItem({
    super.key,
    required this.id,
    required this.date,
    required this.type,
    required this.value,
    this.onClick,
    this.isClickable = false,
    this.isSelected = false,
  });

  String _monthLongPtBR(String isoDate) {
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    final monthLong = DateFormat(
      'MMMM',
      'pt_BR',
    ).format(dt); // mês em texto (pt_BR)
    // Capitaliza primeira letra
    return monthLong.isNotEmpty
        ? monthLong[0].toUpperCase() + monthLong.substring(1)
        : monthLong;
  }

  String _dateBR(String isoDate) {
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    return DateFormat('dd/MM/yyyy', 'pt_BR').format(dt);
  }

  String _formatBRLCurrency(double v) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: r'R$',
      decimalDigits: 2,
    );
    return formatter.format(v);
  }

  @override
  Widget build(BuildContext context) {
    final amount = type == 'Transferência' ? -value : value;

    return GestureDetector(
      onTap: isClickable ? onClick : null,
      child: Container(
        width: 240,
        height: 76, // reduzido de 78 para 76
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        clipBehavior: Clip.hardEdge, // evita overflow visual no web
        decoration: BoxDecoration(
          color: isSelected ? AppColors.background : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: const Color(0xFF47A138), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max, // manter
          children: [
            // Mês
            Text(
              _monthLongPtBR(date),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.thirdColor,
              ),
            ),

            // Linha: tipo e data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _dateBR(date),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: AppColors.thirdText,
                  ),
                ),
              ],
            ),

            // Valor
            Text(
              _formatBRLCurrency(amount),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.secondaryText,
              ),
            ),

            // Divider
            const SizedBox(height: 2), // reduzido de 4 para 2
            SizedBox(
              width: 180,
              child: Divider(
                color: const Color(0x8047A138),
                thickness: 1,
                height: 1, // altura da linha
              ),
            ),
          ],
        ),
      ),
    );
  }
}
