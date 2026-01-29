import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/solde_provider.dart';
import '../providers/transactions_provider.dart';
import '../models/transaction.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _motifController = TextEditingController();
  String? _errorText;

  // ✅ Ajouter une dépense
  void addExpense() {
    final double? montant = double.tryParse(_montantController.text);
    final String motif = _motifController.text.trim();

    if (montant == null || montant <= 0 || motif.isEmpty) {
      setState(() {
        _errorText = 'Veuillez entrer un montant valide et un motif';
      });
      return;
    }

    // 🟥 Soustraire du solde
    ref.read(soldeProvider.notifier).removeMontant(montant);

    // ➕ Ajouter la transaction
    ref.read(transactionsProvider.notifier).addTransaction(TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch,
          montant: montant,
          motif: motif,
          date: DateTime.now(),
          type: TransactionType.depense,
        ));

    Navigator.pop(context); // Retour à l'accueil
  }

  @override
  void dispose() {
    _montantController.dispose();
    _motifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Ajouter Dépense'),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔹 Montant
            TextField(
              controller: _montantController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Montant',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.money_off),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Motif
            TextField(
              controller: _motifController,
              decoration: InputDecoration(
                labelText: 'Motif',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Message d'erreur
            if (_errorText != null)
              Text(
                _errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),

            // 🔹 Bouton Ajouter
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'Ajouter Dépense',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
