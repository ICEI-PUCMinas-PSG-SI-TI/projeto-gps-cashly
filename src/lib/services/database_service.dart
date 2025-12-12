import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference get transactionCollection {
    return userCollection.doc(uid).collection('transactions');
  }

  Future<void> updateUserData({String? email, double? income, String? name}) async {
    Map<String, dynamic> data = {
      'lastActive': FieldValue.serverTimestamp(),
    };
    if (email != null) data['email'] = email;
    if (income != null) data['income'] = income;
    if (name != null) data['name'] = name;

    return await userCollection.doc(uid).set(data, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot> get userData {
    return userCollection.doc(uid).snapshots();
  }

  Future<void> deleteUserData() async {
    final transactions = await transactionCollection.get();
    for (var doc in transactions.docs) {
      await doc.reference.delete();
    }
    
    await userCollection.doc(uid).delete();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    return await transactionCollection.doc(transaction.id).set(transaction.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    return await transactionCollection.doc(id).delete();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    return await transactionCollection.doc(transaction.id).update(transaction.toMap());
  }

  Stream<List<TransactionModel>> get transactions {
    return transactionCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map(_transactionListFromSnapshot);
  }

  List<TransactionModel> _transactionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TransactionModel.fromMap(
          doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
  
  Stream<List<TransactionModel>> getTransactionsByMonth(int month, int year) {
    return transactionCollection
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .snapshots()
        .map((snapshot) {
          final transactions = _transactionListFromSnapshot(snapshot);
          transactions.sort((a, b) => b.date.compareTo(a.date));
          return transactions;
        });
  }

  Stream<List<TransactionModel>> getTransactionsByYear(int year) {
     return transactionCollection
        .where('year', isEqualTo: year)
        .snapshots()
        .map((snapshot) {
          final transactions = _transactionListFromSnapshot(snapshot);
          transactions.sort((a, b) => a.date.compareTo(b.date));
          return transactions;
        });
  }
}
