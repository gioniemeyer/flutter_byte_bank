import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/components/user_menu.dart';
import 'package:mobile_byte_bank/theme/colors.dart';

class UserComponent extends StatefulWidget {
  const UserComponent({super.key});

  @override
  State<UserComponent> createState() => _UserComponentState();
}

class _UserComponentState extends State<UserComponent> {
  OverlayEntry? _entry;

  void openMenu() {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          top: 86,
          right: 2,
          child: Material(
            elevation: 8,
            color: Colors.transparent,
            child: UserMenu(onClose: closeMenu),
          ),
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  void closeMenu() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openMenu,
      child: const CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.secondaryColor,
        child: Icon(Icons.account_circle_outlined),
      ),
    );
  }
}
