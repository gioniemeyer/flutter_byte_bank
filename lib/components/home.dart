import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/state/sidebar_controller.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/components/index.dart';

class HomePage extends StatelessWidget {
  final SidebarController controller;

  const HomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 8,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryText,
        flexibleSpace: SafeArea(
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [MenuDrawerButton(), UserComponent()],
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, _) {
          return ContentBody(
            selectedItem: controller.selectedItem,
          );
        },
      ),
    );
  }
}