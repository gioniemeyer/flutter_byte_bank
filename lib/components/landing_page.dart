import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/routes.dart';
import 'package:mobile_byte_bank/theme/colors.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryText,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Experimente mais liberdade no controle da sua vida financeira. Crie sua conta com a gente!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Image.asset(
                      'assets/images/illustration3.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botões
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryText,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // abrir conta
                          },
                          child: const Text(
                            'Abrir conta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.secondaryText,
                            side: const BorderSide(
                              color: AppColors.secondaryText,
                              width: 2,
                            ),
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(Routes.login);
                          },
                          child: const Text(
                            'Já tenho conta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Vantagens
            const Text(
              'Vantagens do nosso banco:',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const _BenefitItem(
              image: 'assets/images/icon1.png',
              title: 'Conta e cartão gratuitos',
              description:
                'Isso mesmo, nossa conta é digital, sem custo fixo e mais que isso: sem tarifa de manutenção.',
            ),
            const _BenefitItem(
              image: 'assets/images/icon2.png',
              title: 'Saques sem custo',
              description:
                'Você pode sacar gratuitamente 4x por mês de qualquer Banco 24h.',
            ),
            const _BenefitItem(
              image: 'assets/images/icon3.png',
              title: 'Programa de pontos',
              description:
                'Você pode acumular pontos com suas compras no crédito sem pagar mensalidade!',
            ),
            const _BenefitItem(
              image: 'assets/images/icon4.png',
              title: 'Seguro dispositivos',
              description:
                'Seus dispositivos móveis (computador e laptop) protegidos por uma mensalidade simbólica.',
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const _BenefitItem({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              color: AppColors.third,
              height: 56,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.third,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.thirdText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}