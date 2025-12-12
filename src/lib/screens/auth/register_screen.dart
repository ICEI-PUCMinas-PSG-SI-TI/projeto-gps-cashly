import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name = '';
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
        print("Tentando cadastrar usuário: $email");
        User? user = await _auth.registerWithEmail(email, password, name);

        if (user != null) {
          print("Usuário criado com sucesso: ${user.uid}");
          try {
            await _auth.sendEmailVerification(user);
            print("Email de verificação enviado.");
          } catch (e) {
            print("Erro ao enviar email: $e");
          }
          
          await _auth.signOut();

          setState(() => loading = false);

          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Verifique seu Email'),
                content: Text(
                    'Uma mensagem de confirmação foi enviada para $email. Verifique sua caixa de entrada e clique no link para ativar sua conta.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text('Ir para Login'),
                  )
                ],
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException Detalhado: Code=${e.code}, Message=${e.message}, TenantId=${e.tenantId}");
        setState(() {
          loading = false;
          switch (e.code) {
            case 'email-already-in-use':
              error = 'Este email já está sendo usado.';
              break;
            case 'weak-password':
              error = 'A senha é muito fraca.';
              break;
            case 'invalid-email':
              error = 'Email inválido.';
              break;
            case 'operation-not-allowed':
              error = 'Cadastro por email/senha não habilitado no Firebase.';
              break;
            default:
              error = 'Erro (${e.code}): ${e.message}';
          }
        });
      } catch (e) {
          print("Erro Inesperado: $e");
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
        title: const Text('Criar Conta'),
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
                'Crie sua conta',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                ),
                textInputAction: TextInputAction.next,
                validator: (val) => val!.isEmpty ? 'Digite seu nome' : null,
                onChanged: (val) {
                  setState(() => name = val);
                },
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
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50)),
                onPressed: _submitForm,
                child: loading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Cadastrar e Verificar Email'),
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
