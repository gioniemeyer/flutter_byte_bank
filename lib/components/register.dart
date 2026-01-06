import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Nome',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _Input(
                  controller: _nameController,
                  hint: 'Digite seu nome completo',
                ),

                const SizedBox(height: 16),

                const Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _Input(controller: _emailController, hint: 'Digite seu email'),

                const SizedBox(height: 16),

                const Text(
                  'Senha',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _Input(
                  controller: _passwordController,
                  hint: 'Digite sua senha',
                  obscure: true,
                ),

                const SizedBox(height: 12),

                Text(_errorMessage, style: TextStyle(color: AppColors.error)),

                const SizedBox(height: 28),

                Center(
                  child: SizedBox(
                    width: 144,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: AppColors.primaryText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (_isLoading) return;

                        setState(() {
                          _isLoading = true;
                          _errorMessage = '';
                        });

                        try {
                          final userCredential = await _auth
                              .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                          await userCredential.user!.updateDisplayName(
                            _nameController.text.trim(),
                          );

                          await userCredential.user!.reload();

                          Navigator.of(
                            context,
                          ).pushReplacementNamed(Routes.inicio);
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            _errorMessage = _getFirebaseError(e);
                          });
                        } catch (e) {
                          setState(() {
                            _errorMessage = 'Erro inesperado. Tente novamente.';
                          });
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryText,
                                ),
                              ),
                            )
                          : const Text(
                              'Criar conta',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
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
  final TextEditingController controller;

  const _Input({
    required this.hint,
    required this.controller,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

String _getFirebaseError(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return 'Este email já está cadastrado.';
    case 'invalid-email':
      return 'O email informado é inválido.';
    case 'weak-password':
      return 'A senha deve ter pelo menos 6 caracteres.';
    case 'operation-not-allowed':
      return 'O cadastro por email está desativado.';
    case 'network-request-failed':
      return 'Sem conexão com a internet.';
    case 'too-many-requests':
      return 'Muitas tentativas. Tente novamente mais tarde.';
    default:
      return 'Erro ao criar conta. Tente novamente.';
  }
}
