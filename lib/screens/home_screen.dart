import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/solde_provider.dart';
import 'add_revenue_screen.dart';
import 'add_expense_screen.dart';
import 'history_screen.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double solde = ref.watch(soldeProvider);

    // Fonction pour modifier le solde manuellement
    void _editSolde() {
      final _controller = TextEditingController(text: solde.toStringAsFixed(0));

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Modifier le solde'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Nouveau solde en MGA'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(_controller.text);
                if (value != null) {
                  ref.read(soldeProvider.notifier).setSolde(value);
                  Navigator.pop(context);
                }
              },
              child: Text('Valider'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Carte du solde avec bouton modifier
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solde Actuel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${solde.toStringAsFixed(0)} MGA',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.teal, size: 28),
                      onPressed: _editSolde,
                      tooltip: 'Modifier le solde',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // Boutons sous forme de cartes
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      MaterialPageRoute(builder: (_) => AddRevenueScreen()),
                    ),
                  ),
                  _ActionCard(
                    title: 'Ajouter Dépense',
                    color: Colors.red,
                    icon: Icons.arrow_circle_down,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddExpenseScreen()),
                    ),
                  ),
                  _ActionCard(
                    title: 'Historique Mensuel',
                    color: Colors.blue,
                    icon: Icons.history,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HistoryScreen()),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon, color: Colors.white, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
