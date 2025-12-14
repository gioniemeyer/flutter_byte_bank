import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/components/welcome.dart';

/// Caixa central da aplicação. Ajusta estilo com base no content.
class CentralBox extends StatelessWidget {
  final String content; // 'welcome' | 'transaction' | 'investments'

  const CentralBox({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    const lateralPadding = 16.0; // ok ser const
    const topOffset = 48.0; // ok ser const

    final bgColor = content == 'welcome'
        ? AppColors.primary
        : AppColors.backgroundBox;

    return Padding(
      // EdgeInsets.symmetric pode ser const
      padding: const EdgeInsets.symmetric(horizontal: lateralPadding),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          // margin/decoration podem ser const SE todos os valores dentro forem const
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
        return Welcome(userName: 'Joana', balance: 1000.0);
      default:
        return const SizedBox.shrink();
    }
  }
}
