# 💰 Cashly - Gestão Financeira Pessoal

<div align="center">

![Cashly Logo](assets/icon.png)

**Gerencie suas finanças de forma simples e objetiva**

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart)](https://dart.dev)

[🌐 Acessar o App Web](https://projeto-gps-cashly.web.app) · [📱 Download](#) · [📖 Documentação](#funcionalidades)

</div>

---

## 📋 Sobre o Projeto

**Cashly** é um aplicativo multiplataforma de gestão financeira pessoal desenvolvido com Flutter e Firebase. O objetivo é ajudar você a controlar suas receitas e despesas de forma intuitiva, visualizar análises gráficas e tomar decisões financeiras mais conscientes.

### 📄 Identificação do Projeto (TAP)
| Campo | Detalhe |
|-------|---------|
| **Nome do Projeto** | Cashly |
| **Gerente do Projeto** | Pedro Marra Turra |
| **Cliente do Projeto** | Professor da Disciplina |
| **Tipo de Projeto** | Desenvolvimento de novo produto |
| **Objetivo** | Criar uma aplicação web/móvel para gerir finanças e gastos pessoais de uma forma simples e objetiva. |
| **Benefícios** | Melhor controle financeiro pessoal, acessibilidade digital, incentivo à educação financeira e facilidade de uso. |
| **Qualidade Esperada** | Aplicativo web/móvel 100% funcional, entrega dentro do prazo e satisfação do cliente acima de 85%. |

### 📋 Escopo e Premissas
**O que será feito:** Aplicativo que permite o usuário indicar sua renda mensal, subdividir em categorias (alimentação, aluguel etc.), alterar renda na virada do mês, subtrair valores conforme gastos e criar usuário.

**O que não será feito:** Integração com bancos digitais/físicos, transações In-App (apenas controle financeiro com números fictícios).

**Produtos a serem entregues:** Aplicativo móvel/Página na Web 100% funcional.

**Condições para início:** Aprovação do TAP, definição do orçamento, disponibilização de equipe e infraestrutura mínima.

### ✨ Destaques

- 🎨 **Interface Moderna**: Design premium com cores vibrantes e animações suaves
- 📊 **Análises Gráficas**: Visualize seus gastos por categoria com gráficos interativos
- 🔐 **Autenticação Segura**: Login com email/senha ou Google Sign-In
- ☁️ **Sincronização em Nuvem**: Dados sincronizados automaticamente via Firebase
- 🌐 **Multiplataforma**: Funciona em Android, iOS, Web, Windows, macOS e Linux
- 🆓 **Totalmente Gratuito**: Sem custos, sem propagandas

---

## 🚀 Funcionalidades

### 💳 Gestão de Transações
- ✅ Adicionar receitas e despesas
- ✅ Categorização automática (Alimentação, Transporte, Lazer, etc.)
- ✅ Histórico completo de transações
- ✅ Filtros por data e categoria

### 📈 Dashboard & Análises
- ✅ Saldo total em tempo real
- ✅ Resumo de receitas e despesas
- ✅ Gráfico de pizza por categoria
- ✅ Análise de tendências mensais

### 👤 Perfil & Configurações
- ✅ Alterar nome, email e senha
- ✅ Foto de perfil (Google)
- ✅ Excluir conta
- ✅ Termos de Uso e Política de Privacidade

---

## 🛠️ Tecnologias Utilizadas

### Frontend
- **[Flutter](https://flutter.dev)** - Framework UI multiplataforma
- **[Provider](https://pub.dev/packages/provider)** - Gerenciamento de estado
- **[FL Chart](https://pub.dev/packages/fl_chart)** - Gráficos interativos
- **[Intl](https://pub.dev/packages/intl)** - Formatação e localização

### Backend & Serviços
- **[Firebase Authentication](https://firebase.google.com/products/auth)** - Autenticação de usuários
- **[Cloud Firestore](https://firebase.google.com/products/firestore)** - Banco de dados NoSQL
- **[Firebase Hosting](https://firebase.google.com/products/hosting)** - Hospedagem web
- **[Google Sign-In](https://pub.dev/packages/google_sign_in)** - Login social

---

## 📦 Instalação e Execução

### Pré-requisitos

- [Flutter](https://flutter.dev/docs/get-started/install) (versão 3.10 ou superior)
- [Git](https://git-scm.com/)
- [Firebase CLI](https://firebase.google.com/docs/cli) (para deploy)
- Conta Google (para Firebase)

### Passos para Executar

1. **Clone o repositório**
   ```bash
   git clone https://github.com/seu-usuario/cashly.git
   cd cashly
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase**
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com)
   - Ative Authentication (Email/Password e Google)
   - Ative Cloud Firestore
   - Baixe os arquivos de configuração e coloque no projeto

4. **Execute o app**
   
   **Web:**
   ```bash
   flutter run -d chrome
   ```
   
   **Android:**
   ```bash
   flutter run -d android
   ```
   
   **Windows:**
   ```bash
   flutter run -d windows
   ```

---

## 🌐 Deploy Web (Firebase Hosting)

Para fazer o deploy da versão web gratuitamente:

1. **Compile para web**
   ```bash
   flutter build web --release
   ```

2. **Faça o deploy no Firebase**
   ```bash
   firebase deploy --only hosting
   ```

Para mais detalhes, consulte o arquivo [DEPLOY_WEB.md](DEPLOY_WEB.md)

**🔗 App Online:** [https://projeto-gps-cashly.web.app](https://projeto-gps-cashly.web.app)

---

## 📱 Plataformas Suportadas

| Plataforma | Status | Download |
|------------|--------|----------|
| 🌐 Web | ✅ Disponível | [Acessar](https://projeto-gps-cashly.web.app) |
| 🤖 Android | ✅ Em desenvolvimento | Em breve |
| 🍎 iOS | ✅ Em desenvolvimento | Em breve |
| 🖥️ Windows | ✅ Em desenvolvimento | Em breve |
| 🍎 macOS | ✅ Em desenvolvimento | Em breve |
| 🐧 Linux | ✅ Em desenvolvimento | Em breve |

---

## 🎨 Paleta de Cores

O Cashly utiliza uma paleta de cores moderna e profissional:

- **Primary Navy**: `#0D3B66` - Cor principal (confiança e estabilidade)
- **Vibrant Green**: `#52C79F` - Cor de destaque (crescimento e sucesso)

---

## 📸 Screenshots

<div align="center">

### Dashboard
![Dashboard](screenshots/dashboard.png)

### Transações
![Transações](screenshots/transactions.png)

### Análises
![Análises](screenshots/analytics.png)

</div>

---

## 🗂️ Estrutura do Projeto

```
cashly/
├── lib/
│   ├── constants/
│   │   └── app_colors.dart          # Cores do app
│   ├── models/
│   │   ├── transaction_model.dart   # Modelo de transação
│   │   └── user_model.dart          # Modelo de usuário
│   ├── screens/
│   │   ├── auth/                    # Telas de autenticação
│   │   ├── home/                    # Dashboard
│   │   ├── transactions/            # Gestão de transações
│   │   ├── analytics/               # Análises gráficas
│   │   └── profile/                 # Perfil do usuário
│   ├── services/
│   │   ├── auth_service.dart        # Serviço de autenticação
│   │   └── database_service.dart    # Serviço de banco de dados
│   └── main.dart                    # Entrada do app
├── assets/
│   ├── icon.png                     # Ícone do app
│   └── app_logo.png                 # Logo do app
├── firebase.json                    # Configuração do Firebase
├── pubspec.yaml                     # Dependências
└── README.md                        # Este arquivo
```

---

## 🤝 Contribuindo

Contribuições são sempre bem-vindas! Siga os passos abaixo:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👨‍💻 Autor

Desenvolvido com ❤️ por **Você**

- 📧 Email: seu-email@example.com
- 💼 LinkedIn: [Seu Nome](https://linkedin.com/in/seu-perfil)
- 🐙 GitHub: [@seu-usuario](https://github.com/seu-usuario)

---

## 📞 Suporte

Encontrou algum problema ou tem alguma sugestão?

- 🐛 [Reportar Bug](https://github.com/seu-usuario/cashly/issues)
- 💡 [Sugerir Feature](https://github.com/seu-usuario/cashly/issues)
- 📧 Email: suporte@cashly.com

---

## 🙏 Agradecimentos

- [Flutter Team](https://flutter.dev) - Framework incrível
- [Firebase](https://firebase.google.com) - Backend como serviço
- [FL Chart](https://github.com/imaNNeo/fl_chart) - Biblioteca de gráficos

---

<div align="center">

**⭐ Se este projeto te ajudou, considere deixar uma estrela!**

[🌐 Acessar o App](https://projeto-gps-cashly.web.app) · [📖 Documentação](#) · [🐛 Reportar Bug](https://github.com/seu-usuario/cashly/issues)

---

Feito com 💰 e ☕ 

</div>
