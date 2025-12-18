import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/theme/colors.dart';

class UserComponent extends StatelessWidget {
  const UserComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 18,
      child: Icon(Icons.account_circle_outlined),
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.secondaryColor,
    );
  }
}
