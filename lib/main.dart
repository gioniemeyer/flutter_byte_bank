import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_byte_bank/components/home.dart';
import 'package:mobile_byte_bank/components/landing_page.dart';
import 'package:mobile_byte_bank/components/login.dart';
import 'package:mobile_byte_bank/components/register.dart';
import 'package:mobile_byte_bank/routes.dart';
import 'package:mobile_byte_bank/state/sidebar_controller.dart';

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
      initialRoute: Routes.landingPage,
      routes: {
        Routes.landingPage: (_) => LandingPage(),
        Routes.login: (_) => LoginPage(),
        Routes.register: (_) => RegisterPage(),
        Routes.inicio: (_) => HomePage(
          controller: SidebarController(),
        ),
      },
    );
  }
}
