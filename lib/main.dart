import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/components/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
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
          backgroundColor: AppColors.primaryColor,
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
        body: const Center(child: ContentBody(selectedItem: "Início")),
      ),
    );
  }
}
