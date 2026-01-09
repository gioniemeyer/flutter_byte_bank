import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/routes.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/transactions/transaction_controller.dart';
import 'package:provider/provider.dart';

typedef VoidCallbackNullable = void Function()?;

class UserMenu extends StatelessWidget {
  final VoidCallbackNullable onClose;

  const UserMenu({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          width: 110,
          height: 64,
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [
                  InkWell(
                    onTap: () async {
                      final controller = context.read<TransactionController>();

                      await FirebaseAuth.instance.signOut();
                      controller.clear();

                      onClose?.call();

                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed(Routes.login);
                      }
                    },
                    child: const SizedBox(
                      height: 48,
                      child: Center(
                        child: Text(
                          'Sair',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                top: -10,
                right: 0,
                child: IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                  color: AppColors.thirdColor,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
