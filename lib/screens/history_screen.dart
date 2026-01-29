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
      return '${montant.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ' ')} MGA';
    } else {
      return '${montant.toStringAsFixed(0)} MGA';
    }
  }

  // ✅ Formater le mois
  String formatMonth(DateTime date) {
    return DateFormat('MMMM yyyy').format(date); // Ex: January 2026
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    // 🔹 Grouper les transactions par mois
    Map<String, List<TransactionModel>> grouped = {};
    for (var tx in transactions) {
      String month = formatMonth(tx.date);
      if (!grouped.containsKey(month)) {
        grouped[month] = [];
      }
      grouped[month]!.add(tx);
    }

    // 🔹 Trier les mois par ordre décroissant (du plus récent)
    final sortedMonths = grouped.keys.toList()
      ..sort((a, b) {
        DateTime dateA = grouped[a]![0].date;
        DateTime dateB = grouped[b]![0].date;
        return dateB.compareTo(dateA); // décroissant
      });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Historique par mois'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: transactions.isEmpty
          ? Center(
              child: Text(
                'Aucune transaction',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: sortedMonths.length,
              itemBuilder: (context, monthIndex) {
                String month = sortedMonths[monthIndex];
                List<TransactionModel> monthTransactions = grouped[month]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 En-tête du mois avec icône supprimer
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            month,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Supprimer l\'historique du mois',
                            onPressed: () {
                              // 🔥 Confirmer avant suppression
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Confirmer la suppression'),
                                  content: Text(
                                      'Voulez-vous vraiment supprimer toutes les transactions de $month ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text('Annuler'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Supprimer toutes les transactions de ce mois
                                        final monthTransactions =
                                            grouped[month]!;
                                        for (var tx
                                            in monthTransactions) {
                                          ref
                                              .read(transactionsProvider
                                                  .notifier)
                                              .removeTransaction(tx.id);
                                        }
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: const Text('Supprimer'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // 🔹 Transactions de ce mois
                    ...monthTransactions.map((tx) {
                      final bool isRevenue = tx.type == TransactionType.revenu;
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: isRevenue ? Colors.green[50] : Colors.red[50],
                        margin: const EdgeInsets.symmetric(vertical: 6),
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
                    }).toList(),
                  ],
                );
              },
            ),
    );
  }
}
