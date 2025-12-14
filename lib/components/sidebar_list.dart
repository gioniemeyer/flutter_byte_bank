import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/state/sidebar_controller.dart';
import 'package:mobile_byte_bank/theme/colors.dart';

typedef VoidCallbackNullable = void Function()?;

/// SidebarList apenas Mobile (clicável, com Material)
class SidebarList extends StatelessWidget {
  final SidebarController controller;
  final VoidCallbackNullable onClose;

  const SidebarList({super.key, required this.controller, this.onClose});

  static const itens = [
    "Início",
    "Transferências",
    "Investimentos",
    "Outros serviços",
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background, // Material dá superfície para gestos
      child: SizedBox(
        width: 172,
        height: 256,
        child: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.only(top: 8),
              itemCount: itens.length,
              separatorBuilder: (_, __) =>
                  const Divider(thickness: 1, height: 1),
              itemBuilder: (context, index) {
                final text = itens[index];
                final selected = controller.selectedItem == text;

                return InkWell(
                  onTap: () {
                    controller.setSelectedItem(text);
                    onClose?.call();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Center(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: selected
                              ? AppColors.secondary
                              : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
                color: AppColors.third,
                tooltip: 'Fechar',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
