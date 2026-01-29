import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final soldeProvider = StateNotifierProvider<SoldeNotifier, double>((ref) => SoldeNotifier());

class SoldeNotifier extends StateNotifier<double> {
  final Box box = Hive.box('financeApp');

  // Initialise le state dans le constructeur
  SoldeNotifier() : super(0.0) {
    double? stored = box.get('solde');
    if (stored != null) state = stored;
  }

  void setSolde(double value) {
    state = value;
    box.put('solde', state);
  }

  void addMontant(double value) {
    state += value;
    box.put('solde', state);
  }

  void removeMontant(double value) {
    state -= value;
    box.put('solde', state);
  }
}
