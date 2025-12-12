
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidade'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Política de Privacidade - Cashly',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. Coleta de Dados\n'
              'Coletamos apenas as informações fornecidas por você, como email para cadastro e dados de transações financeiras inseridos manualmente.\n\n'
              '2. Uso dos Dados\n'
              'Os dados são usados exclusivamente para fornecer as funcionalidades de gestão financeira do aplicativo.\n\n'
              '3. Compartilhamento\n'
              'Não compartilhamos seus dados pessoais com terceiros, exceto quando exigido por lei.\n\n'
              '4. Segurança\n'
              'Utilizamos o Firebase (Google) para armazenar seus dados com segurança e criptografia padrão da indústria.\n\n'
              '5. Exclusão de Dados\n'
              'Você pode solicitar a exclusão da sua conta e de todos os dados associados a qualquer momento.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
