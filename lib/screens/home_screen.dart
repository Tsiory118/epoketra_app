import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/solde_provider.dart';
import 'add_revenue_screen.dart';
import 'add_expense_screen.dart';
import 'history_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // ✅ Fonction de lisibilité du solde
  String formatSolde(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(3)} M';
    } else if (value >= 1000) {
      return value
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'\B(?=(\d{3})+(?!\d))'),
            (match) => ' ',
          );
    } else {
      return value.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double solde = ref.watch(soldeProvider);

    // 🔒 Modifier le solde manuellement
    void editSolde() {
      final controller =
          TextEditingController(text: solde.toStringAsFixed(0));

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Modifier le solde'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nouveau solde (MGA)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null) {
                  ref.read(soldeProvider.notifier).setSolde(value);
                  Navigator.pop(context);
                }
              },
              child: const Text('Valider'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔹 Carte du solde
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solde actuel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${formatSolde(solde)} MGA',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 28),
                      color: Colors.teal,
                      tooltip: 'Modifier le solde',
                      onPressed: editSolde,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Actions
            Expanded(
              child: GridView(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 20,
                  childAspectRatio: 3.5,
                ),
                children: [
                  _ActionCard(
                    title: 'Ajouter Revenu',
                    color: Colors.green,
                    icon: Icons.arrow_circle_up,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddRevenueScreen()),
                    ),
                  ),
                  _ActionCard(
                    title: 'Ajouter Dépense',
                    color: Colors.red,
                    icon: Icons.arrow_circle_down,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddExpenseScreen()),
                    ),
                  ),
                  _ActionCard(
                    title: 'Historique mensuel',
                    color: Colors.blue,
                    icon: Icons.history,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => HistoryScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon, color: Colors.white, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}
