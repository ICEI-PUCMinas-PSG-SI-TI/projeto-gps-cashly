import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import '../../services/database_service.dart';
import 'add_transaction_screen.dart';
import '../../constants/app_colors.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  String searchQuery = '';
  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final dbService = DatabaseService(uid: user!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extrato'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: selectedMonth,
                            isExpanded: true,
                            icon: const Icon(Icons.calendar_today, size: 16, color: AppColors.primaryNavy),
                            items: List.generate(12, (index) {
                              return DropdownMenuItem(
                                value: index + 1,
                                child: Text(DateFormat.MMMM('pt_BR').format(DateTime(2000, index + 1, 1)).toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600)),
                              );
                            }),
                            onChanged: (val) {
                              if (val != null) setState(() => selectedMonth = val);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: selectedYear,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryNavy),
                            items: List.generate(31, (index) {
                                int year = 2020 + index;
                                return DropdownMenuItem(value: year, child: Text(year.toString(), style: const TextStyle(fontWeight: FontWeight.w600)));
                            }),
                            onChanged: (val) {
                              if (val != null) setState(() => selectedYear = val);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar por descrição...',
                    prefixIcon: Icon(Icons.search, color: AppColors.primaryNavy),
                    filled: true,
                    fillColor: Color(0xFFF9FAFB),
                  ),
                  onChanged: (val) {
                    setState(() => searchQuery = val);
                  },
                ),
              ],
            ),
          ),
          
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
                stream: dbService.getTransactionsByMonth(selectedMonth, selectedYear),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Erro ao carregar: ${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                      ),
                    );
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma transação encontrada neste período.', 
                        style: TextStyle(color: Colors.grey)),
                    );
                  }

                  final transactions = snapshot.data!.where((t) {
                    if (searchQuery.isEmpty) return true;
                    return t.description.toLowerCase().contains(searchQuery.toLowerCase()) || 
                           t.category.toLowerCase().contains(searchQuery.toLowerCase());
                  }).toList();

                  if (transactions.isEmpty) {
                     return const Center(child: Text('Nenhum resultado para a busca.'));
                  }

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: transaction.type == 'income'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            child: Icon(
                              transaction.type == 'income'
                                  ? Icons.arrow_upward_rounded
                                  : Icons.shopping_bag_outlined,
                              color: transaction.type == 'income'
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                          ),
                          title: Text(transaction.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (transaction.description.isNotEmpty)
                                Text(transaction.description, style: const TextStyle(fontSize: 12)),
                              Text(DateFormat('MM/yyyy').format(transaction.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                NumberFormat.simpleCurrency(locale: 'pt_BR').format(transaction.amount),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: transaction.type == 'income' ? Colors.green : Colors.red
                                ),
                              ),
                              PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => AddTransactionScreen(transaction: transaction)),
                                    );
                                  } else if (value == 'delete') {
                                     _showDeleteConfirmation(context, dbService, transaction.id);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Editar')),
                                  const PopupMenuItem(value: 'delete', child: Text('Excluir', style: TextStyle(color: Colors.red))),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, DatabaseService db, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Transação?'),
        content: const Text('Deseja realmente remover esta transação?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              db.deleteTransaction(id);
              Navigator.pop(context);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
