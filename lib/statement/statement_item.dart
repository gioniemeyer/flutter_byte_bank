import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class StatementItem extends StatelessWidget {
  final int id;
  final String date; // ISO string
  final String type; // "Depósito" | "Transferência"
  final double value;
  final String? receiptUrl;
  final VoidCallback? onClick;
  final bool isClickable;
  final bool isSelected;

  const StatementItem({
    super.key,
    required this.id,
    required this.date,
    required this.type,
    required this.value,
    this.receiptUrl,
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
        margin: const EdgeInsets.all(8),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LADO ESQUERDO: tipo + valor
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
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
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // LADO DIREITO: data + recibo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _dateBR(date),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: AppColors.thirdText,
                      ),
                    ),
                    
                    const SizedBox(height: 6),

                    if (receiptUrl != null)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: AppColors.thirdColor, // 👈 mesma cor do mês
                        ),
                        icon: const Icon(
                          Icons.receipt,
                          size: 16,
                          color: AppColors.thirdColor, // 👈 garante no ícone
                        ),
                        label: const Text(
                          'Ver recibo',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          final uri = Uri.parse(receiptUrl!);

                          if (!await canLaunchUrl(uri)) {
                            debugPrint('Não foi possível abrir o recibo: $uri');
                            return;
                          }

                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication, // 👈 essencial
                          );
                        },
                      ),
                  ],
                ),
              ],
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
