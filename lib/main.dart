import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/theme/colors.dart';

void main() {
  runApp(const MyApp());
}

/// Simula seu UserComponent (substitua com seu widget real)
class UserComponent extends StatelessWidget {
  const UserComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(radius: 18, child: Icon(Icons.person));
  }
}

/// Simula seu DrawerButton (substitua com o real)
class DrawerButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const DrawerButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      color: AppColors.primaryText,
      onPressed: onPressed ?? () {},
    );
  }
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
          backgroundColor: (AppColors.primary),
          foregroundColor: (AppColors.primaryText),
          flexibleSpace: SafeArea(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [const DrawerButton(), const UserComponent()],
              ),
            ),
          ),
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You have pushed the button this many times:'),
              Text('0'),
            ],
          ),
        ),
      ),
    );
  }
}
