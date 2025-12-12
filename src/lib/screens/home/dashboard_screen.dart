
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../models/transaction_model.dart';
import '../../services/database_service.dart';
import '../transactions/add_transaction_screen.dart';
import '../transactions/transactions_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final dbService = DatabaseService(uid: user!.uid);

    return StreamProvider<List<TransactionModel>>.value(
      value: dbService.transactions,
      initialData: const [],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
        ),
        body: const DashboardBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
            );
          },
          backgroundColor: AppColors.primaryNavy,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  bool _isAnnual = false;

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<List<TransactionModel>>(context);
    final user = Provider.of<User?>(context);
    final dbService = DatabaseService(uid: user!.uid);

    return StreamBuilder<DocumentSnapshot>(
        stream: dbService.userData,
        builder: (context, snapshot) {
          final now = DateTime.now();
          
          final currentTransactions = transactions.where((t) {
            return t.month == now.month && t.year == now.year;
          }).toList();

          double monthlyIncome = 0;
          double totalExpenses = 0;

          for (var t in currentTransactions) {
            if (t.type == 'income') {
              monthlyIncome += t.amount;
            } else if (t.type == 'expense') {
              totalExpenses += t.amount;
            }
          }
          double monthlyBalance = monthlyIncome - totalExpenses;

          double annualIncome = 0;
          double annualExpense = 0;
          final annualTransactions = transactions.where((t) => t.year == now.year).toList();
          
          for (var t in annualTransactions) {
            if (t.type == 'income') {
              annualIncome += t.amount;
            } else {
              annualExpense += t.amount;
            }
          }
          double annualBalance = annualIncome - annualExpense;

          Map<String, double> monthlyBalances = {};
          final allSorted = List<TransactionModel>.from(transactions);
          allSorted.sort((a, b) => b.date.compareTo(a.date));

          for (var t in allSorted) {
            final key = "${t.month}/${t.year}";
            if (!monthlyBalances.containsKey(key)) {
              monthlyBalances[key] = 0;
            }
            if (t.type == 'income') {
              monthlyBalances[key] = monthlyBalances[key]! + t.amount;
            } else {
               monthlyBalances[key] = monthlyBalances[key]! - t.amount;
            }
          }

          double displayBalance = _isAnnual ? annualBalance : monthlyBalance;
          double displayIncome = _isAnnual ? annualIncome : monthlyIncome;
          double displayExpense = _isAnnual ? annualExpense : totalExpenses;
          String label = _isAnnual ? 'Saldo Anual (${now.year})' : 'Saldo Restante (Mês)';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                
                Card(
                  elevation: 8,
                  shadowColor: AppColors.primaryNavy.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [AppColors.primaryNavy, AppColors.navyLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(label,
                                style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Text('Mensal', 
                                    style: TextStyle(
                                      fontSize: 12, 
                                      fontWeight: !_isAnnual ? FontWeight.bold : FontWeight.normal,
                                      color: Colors.white
                                    )
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: _isAnnual,
                                      activeColor: Colors.white,
                                      activeTrackColor: AppColors.primaryGreen,
                                      inactiveThumbColor: Colors.white,
                                      inactiveTrackColor: Colors.white.withOpacity(0.3),
                                      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                                      onChanged: (val) {
                                        setState(() {
                                          _isAnnual = val;
                                        });
                                      },
                                    ),
                                  ),
                                  Text('Anual', 
                                    style: TextStyle(
                                      fontSize: 12, 
                                      fontWeight: _isAnnual ? FontWeight.bold : FontWeight.normal,
                                      color: Colors.white
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          NumberFormat.simpleCurrency(locale: 'pt_BR')
                              .format(displayBalance),
                          style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                     CircleAvatar(
                                       radius: 12, 
                                       backgroundColor: Colors.white.withOpacity(0.2), 
                                       child: const Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 16)
                                     ),
                                     const SizedBox(width: 8),
                                     Text('Rendas', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                    NumberFormat.simpleCurrency(locale: 'pt_BR')
                                        .format(displayIncome),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                     CircleAvatar(
                                       radius: 12, 
                                       backgroundColor: Colors.white.withOpacity(0.2), 
                                       child: const Icon(Icons.arrow_downward, color: Colors.redAccent, size: 16)
                                     ),
                                     const SizedBox(width: 8),
                                     Text('Gastos', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  NumberFormat.simpleCurrency(locale: 'pt_BR')
                                      .format(displayExpense),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                

                const Text('Histórico Mensal',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: monthlyBalances.length,
                    itemBuilder: (context, index) {
                      final monthKey = monthlyBalances.keys.toList()[index];
                      final balance = monthlyBalances[monthKey]!;
                      final monthName = _getMonthName(int.parse(monthKey.split('/')[0]));
                      
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(monthName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(
                                  NumberFormat.simpleCurrency(locale: 'pt_BR').format(balance),
                                  style: TextStyle(
                                    color: balance >= 0 ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                const Text('Transações Recentes',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length > 5 ? 5 : transactions.length,
                  itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        child: ListTile(
                          visualDensity: VisualDensity.compact,
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: transaction.type == 'income'
                                ? Colors.green[100]
                                : Colors.red[100],
                            child: Icon(
                              transaction.type == 'income'
                                  ? Icons.arrow_upward
                                  : Icons.shopping_cart,
                              color: transaction.type == 'income'
                                  ? Colors.green
                                  : Colors.red,
                              size: 16,
                            ),
                          ),
                          title: Text(transaction.category),
                          subtitle: Text(DateFormat('MM/yyyy').format(transaction.date)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                NumberFormat.simpleCurrency(locale: 'pt_BR')
                                    .format(transaction.amount),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: transaction.type == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Excluir Transação'),
                                      content: const Text(
                                          'Tem certeza que deseja excluir esta transação?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await dbService.deleteTransaction(transaction.id);
                                            if (context.mounted) Navigator.pop(context);
                                          },
                                          child: const Text('Excluir',
                                              style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (_) => AddTransactionScreen(transaction: transaction)),
                             );
                          },
                        ),
                      );
                    },
                  ),

                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionsScreen()));
                  }, 
                  child: const Text('Ver Extrato Completo')
                ),
              ],
            ),
          ),
          );
        });
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }
}
