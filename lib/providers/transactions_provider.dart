import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>(
        (ref) => TransactionsNotifier());

class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  final box = Hive.box('financeApp');

  TransactionsNotifier() : super([]) {
    List? stored = box.get('transactions');
    if (stored != null) {
      state = List<Map<String, dynamic>>.from(stored)
          .map((e) => TransactionModel.fromMap(e))
          .toList();
    }
  }

  // ➕ Ajouter une transaction
  void addTransaction(TransactionModel transaction) {
    state = [transaction, ...state];
    save();
  }

  // ✅ Supprimer une transaction par ID
  void removeTransaction(int id) {
    state = state.where((tx) => tx.id != id).toList();
    save();
  }

  // ✅ Supprimer toutes les transactions d'un mois donné
  void removeTransactionsOfMonth(int year, int month) {
    state = state.where((tx) => !(tx.date.year == year && tx.date.month == month)).toList();
    save();
  }

  // 💾 Sauvegarder dans Hive
  void save() {
    box.put('transactions', state.map((e) => e.toMap()).toList());
  }
}
