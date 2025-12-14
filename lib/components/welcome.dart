import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/components/balance_content.dart';
import 'package:mobile_byte_bank/components/welcome_images.dart';

class Welcome extends StatefulWidget {
  final String userName;
  final double balance;

  const Welcome({super.key, required this.userName, required this.balance});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String formatedLetterDate = '';

  @override
  void initState() {
    super.initState();
    _formatDate();
  }

  void _formatDate() {
    final now = DateTime.now();
    final formatted = DateFormat('EEEE, dd/MM/yyyy', 'pt_BR').format(now);
    setState(() {
      formatedLetterDate = formatted.isNotEmpty
          ? formatted[0].toUpperCase() + formatted.substring(1)
          : formatted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 655,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Camada inferior: imagens decorativas
          const Positioned.fill(child: WelcomeImages()),

          // Camada superior: textos + balance, começando no topo
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // topo
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // opcional: pequeno respiro do topo
                const SizedBox(height: 16),

                // Título
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Olá, ${widget.userName}! :)',
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),

                // Data
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    formatedLetterDate,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),

                // Balance logo abaixo
                BalanceContent(balance: widget.balance),

                const SizedBox(height: 24), // respiro inferior opcional
              ],
            ),
          ),
        ],
      ),
    );
  }
}
