import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import '../../services/database_service.dart';
import '../../constants/app_colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final List<Color> pieColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    AppColors.primaryNavy,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final dbService = DatabaseService(uid: user!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise Financeira'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- FILTERS ---
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButton<int>(
                          value: selectedMonth,
                          isExpanded: true,
                          underline: Container(),
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
                        child: DropdownButton<int>(
                          value: selectedYear,
                          isExpanded: true,
                          underline: Container(),
                          items: List.generate(31, (index) {
                            int year = 2020 + index;
                            return DropdownMenuItem(value: year, child: Text(year.toString()));
                          }),
                          onChanged: (val) {
                            if (val != null) setState(() => selectedYear = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Gastos por Categoria (Mês)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: StreamBuilder<List<TransactionModel>>(
                  stream: dbService.getTransactionsByMonth(selectedMonth, selectedYear),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Sem dados neste mês.'));
                    }

                    final expenses = snapshot.data!.where((t) => t.type == 'expense').toList();
                    if (expenses.isEmpty) {
                       return const Center(child: Text('Nenhuma despesa registrada.'));
                    }

                    Map<String, double> categoryTotals = {};
                    double totalExpenses = 0;
                    for (var t in expenses) {
                      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
                      totalExpenses += t.amount;
                    }

                    List<PieChartSectionData> sections = [];
                    List<Widget> legendItems = [];
                    int colorIndex = 0;

                    categoryTotals.forEach((category, amount) {
                      final percentage = (amount / totalExpenses) * 100;
                      final color = pieColors[colorIndex % pieColors.length];
                      
                      sections.add(PieChartSectionData(
                        color: color,
                        value: amount,
                        title: '${percentage.toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ));

                      legendItems.add(Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 12, height: 12, color: color),
                          const SizedBox(width: 4),
                          Text(category, style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 12),
                        ],
                      ));

                      colorIndex++;
                    });

                    return Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: sections,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: legendItems,
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              Text('Evolução Anual ($selectedYear)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: StreamBuilder<List<TransactionModel>>(
                  stream: dbService.getTransactionsByYear(selectedYear),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Sem dados neste ano.'));
                    }

                    Map<int, double> incomeByMonth = {};
                    Map<int, double> expenseByMonth = {};

                    for (var t in snapshot.data!) {
                      if (t.type == 'income') {
                        incomeByMonth[t.month] = (incomeByMonth[t.month] ?? 0) + t.amount;
                      } else {
                        expenseByMonth[t.month] = (expenseByMonth[t.month] ?? 0) + t.amount;
                      }
                    }

                    List<BarChartGroupData> barGroups = [];
                    for (int i = 1; i <= 12; i++) {
                       barGroups.add(
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(toY: incomeByMonth[i] ?? 0, color: Colors.green, width: 8),
                            BarChartRodData(toY: expenseByMonth[i] ?? 0, color: Colors.red, width: 8),
                          ],
                        )
                       );
                    }

                    double maxY = 0;
                    incomeByMonth.forEach((_, v) { if(v > maxY) maxY = v; });
                    expenseByMonth.forEach((_, v) { if(v > maxY) maxY = v; });
                    if (maxY == 0) maxY = 100;

                    return BarChart(
                      BarChartData(
                        maxY: maxY * 1.2,
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                                if (value.toInt() >= 1 && value.toInt() <= 12) {
                                   return Text(months[value.toInt() - 1], style: const TextStyle(fontSize: 10));
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: barGroups,
                        gridData: const FlGridData(show: true, drawVerticalLine: false),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 12),
                  SizedBox(width: 4),
                  Text('Receitas'),
                  SizedBox(width: 16),
                  Icon(Icons.circle, color: Colors.red, size: 12),
                  SizedBox(width: 4),
                  Text('Despesas'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


