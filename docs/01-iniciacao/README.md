# Iniciação

A fase de iniciação, em gerência de projetos, é o estágio que estabelece as bases para o sucesso do empreendimento. Durante essa etapa, os objetivos definidos, identificando-se suas metas, escopo, partes interessadas (*stakeholders*) e restrições. É o momento em que a viabilidade do projeto é avaliada, analisando-se recursos necessários, riscos potenciais e benefícios esperados. Nesta etapa é elaborado o Termo de Abertura do Projeto (TAP). Essa fase serve como um alicerce estratégico, proporcionando uma compreensão abrangente do que o projeto busca alcançar e delineando as diretrizes que orientarão as etapas subsequentes. O sucesso na fase de iniciação contribui significativamente para a eficácia do gerenciamento de projetos como um todo.

# Estrutura do Documento

- [Iniciação](#iniciação)
- [Estrutura do Documento](#estrutura-do-documento)
- [Introdução](#introdução)
  - [Problema](#problema)
  - [Objetivos](#objetivos)
  - [Justificativa](#justificativa)
  - [Critérios de Sucesso](#critérios-de-sucesso)
- [Partes Interessadas](#partes-interessadas)
- [Termo de Abertura do Projeto](#termo-de-abertura-do-projeto)
  - [Estimativa de Custo](#estimativa-de-custo)
    - [Requisitos Funcionais](#requisitos-funcionais)
    - [Requisitos Não Funcionais](#requisitos-não-funcionais)
    - [Restrições](#restrições)
    - [Contra-Escopo](#contra-escopo)
    - [Condições para início do Projeto](#condições-para-início-do-projeto)
  - [Marcos Agendados e Entregas](#marcos-agendados-e-entregas)
  - [Divisão de Papéis](#divisão-de-papéis)
  - [Ferramentas](#ferramentas)

# Introdução

![Iniciação](artefatos/definicao_do_projeto.pdf)

## Problema

A falta de um sistema de gerenciamento financeiro eficiente para cidadãos comuns resulta em dificuldades no controle de receitas e despesas, impactando a saúde financeira dos negócios.

## Objetivos

O objetivo geral deste projeto é desenvolver um sistema de gerenciamento financeiro que permita a cidadãos comuns controlar suas receitas e despesas de forma eficiente.

Objetivos específicos:
1. Criar uma interface intuitiva para o registro de receitas e despesas.
2. Implementar relatórios financeiros que ajudem na visualização do fluxo de caixa.
3. Integrar funcionalidades de alerta para vencimento de contas e despesas recorrentes.
4. Garantir a segurança e privacidade dos dados financeiros dos usuários.

## Justificativa

A implementação deste sistema trará diversos benefícios, como:
- Melhoria no controle financeiro pessoal, permitindo uma gestão mais eficiente das finanças.
- Redução de inadimplência, com alertas para vencimento de contas.
- Aumento da conscientização sobre hábitos de consumo, por meio de relatórios detalhados.

## Critérios de Sucesso

- Entrega do sistema dentro do prazo e orçamento estabelecidos.
- Satisfação dos usuários com a interface e funcionalidades do sistema.
- Aceite de 80% do cliente nas funcionalidades entregues.
- Redução de 20% na inadimplência dos usuários em até 6 meses após a implementação.
- Aumento de 30% na utilização do sistema em relação ao período anterior à sua implementação.

# Partes Interessadas

**Membros da Equipe e Funções Principais**
A equipe principal de desenvolvimento e gestão é composta por:

- Pedro Marra Turra (Gerente de Projeto): É responsável pelo Planejamento e coordenação geral do projeto, com expectativas de coordenação, organização e entrega. Possui Alta influência e Alta importância/poder.
- Bernardo Rodrigues (Dev Backend): Seu papel é o Desenvolvimento da API e banco de dados. Ele espera Implementar backend funcional e seguro.
- Gabriel Mamede (Designer UI/UX): Responsável pela Prototipagem e design da interface , com a expectativa de Criar interface intuitiva e atrativa.
- Gabriel Reis (Dev Frontend): Atua no Desenvolvimento da interface web/app , visando Desenvolver frontend responsivo.
- Felipe Rios (Testador QA): Tem o papel de realizar Testes e validação do sistema para Garantir qualidade e confiabilidade.

**Clientes e Patrocinadores**

- Professor da Disciplina (Cliente Principal): Seu papel é a Definição de requisitos e validação final. Sua principal expectativa é a Entrega conforme requisitos e o aprendizado dos alunos. Possui Alta influência e Alta importância/poder.
- Coordenação do Curso (Patrocinador): Oferece Apoio institucional e financeiro/acadêmico. Espera Relevância acadêmica e qualidade do projeto.

**Fornecedores**

- Loja de Aplicativos (Google Play) (Fornecedor): Sua função é a Distribuição do aplicativo. Sua expectativa é Disponibilizar o app aos usuários finais. Possui Baixa influência e Média importância/poder.
- Firebase (Fornecedor): Fornece Serviços de backend e autenticação. Garante estabilidade e escalabilidade dos serviços.


# Termo de Abertura do Projeto

O Termo de Abertura do Projeto (TAP) é um documento fundamental que formaliza o início de um projeto, estabelecendo sua existência e definindo os principais elementos que orientarão sua execução.
 
![Termo de Abertura do Projeto](artefatos/TAP_Cashly.pdf)

## Estimativa de Custo

| Item de Custo                                    | Qtd. Horas | Valor/Hora   | Valor Total       |
|--------------------------------------------------|------------:|--------------:|------------------:|
| Recursos Humanos (Dev, Designer, QA)             |         720 | R$ 70,00     | R$ 50.400,00      |
| Hardware (notebooks, periféricos)                |           — | —            | R$ 8.000,00       |
| Rede e serviços de hospedagem                     |           — | —            | R$ 1.200,00       |
| Software de terceiros (licenças, APIs)           |           — | —            | R$ 2.500,00       |
| Serviços de treinamento                           |          40 | R$ 100,00    | R$ 4.000,00       |
| **Total Geral**                                   |            |              | **R$ 66.100,00**  |

### Requisitos Funcionais

|ID     | Descrição do Requisito                                                                 | Prioridade |
|-------:|---------------------------------------------------------------------------------------|-----------:|
|RF-001 | Cadastro de usuário com autenticação (e-mail/senha e opção de SSO via Google/Facebook) | ALTA       |
|RF-002 | Login, recuperação de senha e gerenciamento de sessão                                 | ALTA       |
|RF-003 | Cadastro, edição e exclusão de contas (bancos, cartões, carteiras)                     | ALTA       |
|RF-004 | Registro de transações de receita e despesa com categoria, data, valor e descrição    | ALTA       |
|RF-005 | Importação/Exportação de extratos em CSV                                            | MÉDIA      |
|RF-006 | Configuração de despesas recorrentes e agendamento de lembretes                       | ALTA       |
|RF-007 | Geração de relatórios e gráficos: fluxo de caixa, despesas por categoria e período    | ALTA       |
|RF-008 | Dashboard inicial com saldo consolidado e principais indicadores (KPIs)               | ALTA       |
|RF-009 | Pesquisa e filtros de transações por data, categoria e valor                          | MÉDIA      |
|RF-010 | Controle de permissões básicas (conta vs. convidado) para compartilhamento de dados   | MÉDIA      |
|RF-011 | Notificações push/e-mail para vencimentos e alertas configuráveis                     | MÉDIA      |

### Requisitos Não Funcionais

|ID     | Descrição do Requisito                                                       | Prioridade |
|-------:|-------------------------------------------------------------------------------|-----------:|
|RNF-001| Interface responsiva para dispositivos móveis e desktops                     | ALTA       |
|RNF-002| Tempo de resposta de telas críticas ≤ 3s em conexões típicas                  | MÉDIA      |
|RNF-003| Nível de disponibilidade do serviço 99% (considerando hosting Firebase/Cloud)| MÉDIA      |
|RNF-004| Armazenamento e transmissão dos dados criptografados (TLS em trânsito, AES em repouso) | ALTA |
|RNF-005| Conformidade básica com LGPD: consentimento, anonimização e eliminação de dados | ALTA     |
|RNF-006| Escalabilidade horizontal prevista para 10k usuários simultâneos             | BAIXA      |

### Restrições

|ID    | Descrição da Restrição                                                                 |
|------|----------------------------------------------------------------------------------------|
|RE-001| Uso de Firebase/auth e Firestore como backend principal (limitação tecnológica)       |
|RE-002| Orçamento limitado a R$ 66.100,00 conforme estimativa do TAP                          |
|RE-003| Prazo do semestre acadêmico para entrega das primeiras versões funcionais             |
|RE-004| Integração apenas com APIs de terceiros com plano gratuito ou baixo custo inicial      |
|RE-005| Não será suportado ambiente on-premises; solução será hospedada em cloud pública      |

### Contra-Escopo

|ID    | Descrição do Contra-Escopo                            |
|------|------------------------------------------------------|
|CE-001| Treinamento de modelos de LLM para análises financeiras|
|CE-002| Pesquisa de mercado comercial detalhada              |
|CE-003| Desenvolvimento de versão desktop nativa (Electron)  |
|CE-004| Integração com sistemas bancários via Open Banking    |
|CE-005| Fornecimento de consultoria financeira personalizada  |

### Condições para início do Projeto

|ID    | Descrição de Condição para Início do Projeto                                   |
|------|---------------------------------------------------------------------------------|
|CI-001| Assinatura do termo de compromisso/contrato entre equipe e cliente (professor) |
|CI-002| Disponibilização de acesso ao repositório GitHub e criação do Project/Kanban    |
|CI-003| Definição e aprovação do backlog inicial e critérios de aceite (TAP aprovado)  |
|CI-004| Recursos mínimos alocados (notebooks, acesso a Firebase e contas de serviço)   |

## Marcos Agendados e Entregas

|ID   | Marco do Projeto / Entregável                                              | Data Prevista (estimada) |
|-----|-----------------------------------------------------------------------------|--------------------------|
|M-1  | Kick-off e TAP aprovado; repositório e projeto GitHub configurados          | Dia 0 (início)           |
|M-2  | Protótipo de baixa fidelidade e WBS aprovados                               | +2 semanas               |
|M-3  | MVP backend básico (autenticação, CRUD de transações)                       | +6 semanas               |
|M-4  | MVP frontend funcional (registro/transações, dashboard básico)              | +8 semanas               |
|M-5  | Testes integrados, documentação mínima e implantação em ambiente de testes  | +10 semanas              |
|M-6  | Entrega final para avaliação (ajustes pós-feedback e documentação final)     | +12 semanas              |

## Divisão de Papéis

Pedro Marra Turra - Gerente de Projeto
Bernardo Rodrigues - Dev Backend
Gabriel Mamede - Designer UI/UX
Gabriel Reis - Dev Frontend
Felipe Rios - Testador QA

## Ferramentas

| Ambiente              | Plataforma         | Justificativa |
|-----------------------|--------------------|---------------|
| Quadro Kanban         | GitHub             | Centralização e organização do projeto no próprio repositório. |
| Repositório de código | GitHub             |               |
| Protótipo Interativo  | MavelApp ou Figma  |               |
| Documentos Textuais   | LibreOffice Writer |               |
| Planilhas e Gráficos  | Google Planilhas   |               |

----
