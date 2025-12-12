import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import '../../services/database_service.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;
  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final List<String> expenseCategories = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Educação',
    'Saúde',
    'Moradia',
    'Compras',
    'Outros'
  ];

  final List<String> incomeCategories = [
    'Salário',
    'Investimentos',
    'Férias',
    '13º Salário',
    'Freelance',
    'Presente',
    'Outros'
  ];

  String category = 'Alimentação';
  double amount = 0;
  String description = '';
  String type = 'expense';
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    category = expenseCategories.first;

    if (widget.transaction != null) {
      final t = widget.transaction!;
      type = t.type;
      amount = t.amount;
      category = t.category;
      description = t.description;
      selectedMonth = t.month;
      selectedYear = t.year;
    }
  }

  void _updateType(String newType) {
    setState(() {
      type = newType;
      if (! (newType == 'expense' ? expenseCategories : incomeCategories).contains(category)) {
         category = newType == 'expense' ? expenseCategories.first : incomeCategories.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final isExpense = type == 'expense';
    final isEditing = widget.transaction != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing 
            ? 'Editar Transação' 
            : (isExpense ? 'Adicionar Despesa' : 'Adicionar Receita')),
        backgroundColor: isExpense ? Colors.redAccent : Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isExpense ? Colors.redAccent : Colors.grey[200],
                        foregroundColor: isExpense ? Colors.white : Colors.black,
                      ),
                      onPressed: () => _updateType('expense'),
                      icon: const Icon(Icons.money_off),
                      label: const Text('Despesa'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isExpense ? Colors.green : Colors.grey[200],
                        foregroundColor: !isExpense ? Colors.white : Colors.black,
                      ),
                      onPressed: () => _updateType('income'),
                      icon: const Icon(Icons.attach_money),
                      label: const Text('Receita'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                   Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<int>(
                      value: selectedMonth,
                      menuMaxHeight: 300, 
                      decoration: const InputDecoration(
                        labelText: 'Mês',
                      ),
                      items: List.generate(12, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text(DateFormat.MMMM('pt_BR').format(DateTime(2000, index + 1, 1)).toUpperCase()),
                        );
                      }),
                      onChanged: (val) {
                         if (val != null) setState(() => selectedMonth = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<int>(
                      value: selectedYear,
                      menuMaxHeight: 300, 
                      decoration: const InputDecoration(
                        labelText: 'Ano',
                      ),
                      items: List.generate(31, (index) {
                         int year = 2020 + index;
                         return DropdownMenuItem(
                           value: year,
                           child: Text(year.toString()),
                         );
                      }),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedYear = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                ),
                items: (isExpense ? expenseCategories : incomeCategories)
                    .map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => category = val);
                  }
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                initialValue: isEditing ? amount.toStringAsFixed(2).replaceAll('.', ',') : null,
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                   if (val == null || val.isEmpty) return 'Informe um valor';
                   String cleaned = val.replaceAll(',', '.');
                   if (double.tryParse(cleaned) == null) return 'Valor inválido';
                   return null;
                }, 
                onChanged: (val) {
                  String cleaned = val.replaceAll(',', '.');
                  setState(() => amount = double.tryParse(cleaned) ?? 0);
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(
                  labelText: 'Descrição (Opcional)',
                ),
                onChanged: (val) {
                  setState(() => description = val);
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isExpense ? Colors.redAccent : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('O valor deve ser maior que zero.'))
                        );
                        return;
                      }

                      final dbService = DatabaseService(uid: user!.uid);
                      
                      final date = DateTime(selectedYear, selectedMonth, 1);
                      final transactionData = TransactionModel(
                        id: isEditing ? widget.transaction!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                        userId: user.uid,
                        amount: amount,
                        category: category,
                        type: type,
                        date: date,
                        month: selectedMonth,
                        year: selectedYear,
                        description: description,
                      );

                      if (isEditing) {
                        await dbService.updateTransaction(transactionData);
                      } else {
                        await dbService.addTransaction(transactionData);
                      }
                      
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: Text(isEditing ? 'Atualizar' : 'Salvar', style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
