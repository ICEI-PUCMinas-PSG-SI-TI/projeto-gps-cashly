class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final String type;
  final DateTime date;
  final String description;
  final int month;
  final int year;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    required this.description,
    int? month,
    int? year,
  }) : 
    this.month = month ?? date.month,
    this.year = year ?? date.year;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date.toIso8601String(),
      'description': description,
      'month': month,
      'year': year,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      category: map['category'] ?? 'Outros',
      type: map['type'] ?? 'expense',
      date: DateTime.parse(map['date']),
      description: map['description'] ?? '',
      month: map['month'],
      year: map['year'],
    );
  }
}
