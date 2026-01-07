import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/components/sidebar_list.dart';
import 'package:mobile_byte_bank/state/sidebar_controller.dart';
import 'package:mobile_byte_bank/theme/colors.dart';

class MenuDrawerButton extends StatefulWidget {
  const MenuDrawerButton({super.key});

  @override
  State<MenuDrawerButton> createState() => _MenuDrawerButtonState();
}

class _MenuDrawerButtonState extends State<MenuDrawerButton> {
  final controller = SidebarController();
  OverlayEntry? _entry;

  void openSidebar() {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          // Posição relativa à tela inteira
          top: 86,
          left: 2, // canto direito
          child: Material(
            elevation: 8,
            color: Colors.transparent,
            child: SidebarList(controller: controller, onClose: closeSidebar),
          ),
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  void closeSidebar() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: openSidebar,
      icon: const Icon(Icons.menu),
      color: AppColors.secondaryColor,
      tooltip: 'Abrir menu',
    );
  }
}
