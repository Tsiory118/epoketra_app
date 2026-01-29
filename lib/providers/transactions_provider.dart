import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>(
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

  void addTransaction(TransactionModel transaction) {
    state = [transaction, ...state];
    save();
  }

  void save() {
    box.put('transactions', state.map((e) => e.toMap()).toList());
  }
}
