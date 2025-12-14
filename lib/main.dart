import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/components/index.dart'; // ou: import 'package:mobile_byte_bank/components/user_component.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
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
                children: [
                  const MenuDrawerButton(),
                  const UserComponent(), // vindo do components/index.dart
                ],
              ),
            ),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You have pushed the button this many times:'),
              Text('0'),
            ],
          ),
        ),
      ),
    );
  }
}
