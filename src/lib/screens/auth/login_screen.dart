
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool _isPasswordVisible = false;


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
        error = '';
      });
      
      try {
        User? user = await _auth.signInWithEmail(email, password);

        if (user != null) {
          if (!user.emailVerified) {
            await _auth.signOut();
            
            setState(() {
              loading = false;
              error = 'Email não verificado. Verifique sua caixa de entrada.';
            });

            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Email não verificado'),
                  content: const Text('Sua conta ainda não foi ativada. Verifique o link enviado para seu email.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _auth.sendEmailVerification(user);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Novo email de verificação enviado!'))
                        );
                      },
                      child: const Text('Reenviar Email'),
                    ),
                  ],
                ),
              );
            }
          } else {
             if (context.mounted) {
               Navigator.popUntil(context, (route) => route.isFirst);
             }
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          loading = false;
          switch (e.code) {
            case 'user-not-found':
            case 'wrong-password':
            case 'invalid-credential':
              error = 'Email ou senha incorretos.';
              break;
            case 'user-disabled':
              error = 'Usuário desativado.';
              break;
            default:
              error = 'Erro: ${e.message}';
          }
        });
      } catch (e) {
        setState(() {
          loading = false;
          error = 'Erro inesperado: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login - Cashly'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryNavy.withOpacity(0.1), Colors.white],
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance_wallet, size: 80, color: AppColors.primaryNavy),
              const SizedBox(height: 16),
              const Text(
                'Faça login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                textInputAction: TextInputAction.next,
                validator: (val) => val!.isEmpty ? 'Digite um email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submitForm(),
                validator: (val) =>
                    val!.length < 6 ? 'A senha deve ter 6+ caracteres' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _submitForm,
                child: loading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Entrar'),
              ),
              const SizedBox(height: 12),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
            ),
          ),
        );
  }
}
