import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transactions_provider.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  // ✅ Formater le montant pour lisibilité
  String formatMontant(double montant) {
    if (montant >= 1000000) {
      return '${(montant / 1000000).toStringAsFixed(3)} M MGA';
    } else if (montant >= 1000) {
      return '${(montant / 1000).toStringAsFixed(0)} k MGA';
    } else {
      return '${montant.toStringAsFixed(0)} MGA';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Historique Mensuel'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: transactions.isEmpty
          ? Center(
              child: Text(
                'Aucune transaction ce mois-ci',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final bool isRevenue = tx.type == TransactionType.revenu;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: isRevenue ? Colors.green[50] : Colors.red[50],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    leading: CircleAvatar(
                      backgroundColor:
                          isRevenue ? Colors.green[200] : Colors.red[200],
                      child: Icon(
                        isRevenue
                            ? Icons.arrow_circle_up
                            : Icons.arrow_circle_down,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      tx.motif,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(tx.date),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Text(
                      '${isRevenue ? "+" : "-"}${formatMontant(tx.montant)}',
                      style: TextStyle(
                        color: isRevenue ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
