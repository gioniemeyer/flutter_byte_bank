import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/routes.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryText,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                const SizedBox(height: 8),

                Image.asset(
                  'assets/images/register.png',
                  height: 220,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Preencha os campos abaixo para criar sua conta corrente!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Nome',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,  
                  ),
                ),
                const SizedBox(height: 8),
                _Input(
                  hint: 'Digite seu nome completo',
                ),

                const SizedBox(height: 16),

                const Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,  
                  ),
                ),
                const SizedBox(height: 8),
                _Input(
                  hint: 'Digite seu email',
                ),

                const SizedBox(height: 16),

                const Text(
                  'Senha',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,  
                  ),
                ),
                const SizedBox(height: 8),
                _Input(
                  hint: 'Digite sua senha',
                  obscure: true,
                ),

                const SizedBox(height: 32),

                Center(
                  child: SizedBox(
                    width: 144,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.primaryText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // FAZER VALIDAÇÃO DE CONTA
                        Navigator.of(context).pushNamed(Routes.inicio);
                      },
                      child: const Text(
                        'Criar conta',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _Input extends StatelessWidget {
  final String hint;
  final bool obscure;

  const _Input({
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}