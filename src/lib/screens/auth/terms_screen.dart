
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Termos de Uso - Cashly',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. Aceitação dos Termos\n'
              'Ao utilizar o aplicativo Cashly, você concorda com estes termos. Se não concordar, não utilize o aplicativo.\n\n'
              '2. Uso do Aplicativo\n'
              'O Cashly é destinado ao gerenciamento financeiro pessoal. O uso indevido para fins ilegais é estritamente proibido.\n\n'
              '3. Privacidade\n'
              'Seus dados são armazenados de forma segura e utilizados apenas para o funcionamento do app, conforme nossa Política de Privacidade.\n\n'
              '4. Isenção de Responsabilidade\n'
              'O Cashly não se responsabiliza por perdas financeiras decorrentes de decisões tomadas com base nas informações do aplicativo. Os dados são inseridos pelo próprio usuário.\n\n'
              '5. Alterações\n'
              'Podemos alterar estes termos a qualquer momento. O uso contínuo implica aceitação das mudanças.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
