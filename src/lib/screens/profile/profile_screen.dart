import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

import '../auth/terms_screen.dart';
import '../auth/policy_screen.dart';
import '../../constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _reloadUserData();
  }

  Future<void> _reloadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      await AuthService().syncUserEmail();
      
      final freshUser = FirebaseAuth.instance.currentUser;
      if (mounted) {
        setState(() {
          _userName = freshUser?.displayName;
          _userEmail = freshUser?.email;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar dados',
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              await _reloadUserData();
              if (mounted) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Dados atualizados!')),
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          UserHeader(nameOverride: _userName, emailOverride: _userEmail),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Alterar Nome'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showChangeNameDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Alterar Senha'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showChangePasswordDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Alterar Email'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showChangeEmailDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre o App'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Termos de Uso'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen()));
            },
          ),
           ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Política de Privacidade'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const PolicyScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.orange),
            title: const Text('Sair', style: TextStyle(color: Colors.orange)),
            onTap: () async {
              await AuthService().signOut();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Excluir Conta', style: TextStyle(color: Colors.red)),
            onTap: () {
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
    );
  }


  void _showChangeNameDialog(BuildContext context) {
      final TextEditingController nameController = TextEditingController();
      final user = Provider.of<User?>(context, listen: false);
      if (user?.displayName != null) {
        nameController.text = user!.displayName!;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alterar Nome'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Novo Nome'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            TextButton(
              onPressed: () async {
                if(nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, digite um nome')));
                    return;
                }
                
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                
                try {
                  await AuthService().changeName(nameController.text);
                  await _reloadUserData();
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Nome atualizado com sucesso!')));
                } catch(e) {
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
                }
              }, 
              child: const Text('Salvar')
            ),
          ],
        ),
      );
  }

  void _showChangePasswordDialog(BuildContext context) {
      final TextEditingController passController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alterar Senha'),
          content: TextField(
            controller: passController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Nova Senha'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            TextButton(
              onPressed: () async {
                if(passController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A senha deve ter pelo menos 6 caracteres')));
                    return;
                }
                try {
                  await AuthService().changePassword(passController.text);
                  if(context.mounted) {
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha alterada com sucesso!')));
                  }
                } catch(e) {
                   if(context.mounted) {
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}. Talvez seja necessário fazer login novamente.')));
                  }
                }
              }, 
              child: const Text('Salvar')
            ),
          ],
        ),
      );
  }

  void _showChangeEmailDialog(BuildContext context) {
      final TextEditingController emailController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alterar Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Um email de verificação será enviado para o novo endereço. Sua conta será atualizada após a verificação.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Novo Email'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            TextButton(
              onPressed: () async {
                if(emailController.text.isEmpty || !emailController.text.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email inválido')));
                    return;
                }
                try {
                  await AuthService().changeEmail(emailController.text);
                  if(context.mounted) {
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email de verificação enviado! Verifique sua nova caixa de entrada.')));
                  }
                } catch(e) {
                   if(context.mounted) {
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}. Talvez seja necessário fazer login novamente.')));
                  }
                }
              }, 
              child: const Text('Enviar')
            ),
          ],
        ),
      );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Cashly',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.account_balance_wallet, size: 40, color: AppColors.primaryNavy),
      children: [
        const Text('Cashly é um aplicativo de gestão financeira pessoal desenvolvido para ajudar você a controlar seus gastos e receitas de forma simples e eficiente.'),
        const SizedBox(height: 10),
        const Text('Desenvolvido por Você.'),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Conta?'),
        content: const Text(
            'Tem certeza? Todos os seus dados serão apagados permanentemente. Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await AuthService().deleteAccount();
              } catch (e) {
                 if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Erro ao excluir: $e. Tente sair e entrar novamente.'))
                   );
                 }
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}


class UserHeader extends StatelessWidget {
  final String? nameOverride;
  final String? emailOverride;
  
  const UserHeader({super.key, this.nameOverride, this.emailOverride});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final email = emailOverride ?? user?.email ?? 'Visitante';
    final name = nameOverride ?? user?.displayName ?? 'Usuário';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryNavy,
            backgroundImage: user?.photoURL != null 
                ? NetworkImage(user!.photoURL!) 
                : null,
            child: user?.photoURL == null 
                ? const Icon(Icons.person, size: 40, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(email, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
