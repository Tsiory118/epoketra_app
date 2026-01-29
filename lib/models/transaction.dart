enum TransactionType { revenu, depense }

class TransactionModel {
  final int id;
  final double montant;
  final String motif;
  final DateTime date;
  final TransactionType type;

  TransactionModel({
    required this.id,
    required this.montant,
    required this.motif,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'montant': montant,
        'motif': motif,
        'date': date.toIso8601String(),
        'type': type.toString(),
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
        id: map['id'],
        montant: map['montant'],
        motif: map['motif'],
        date: DateTime.parse(map['date']),
        type: map['type'] == 'TransactionType.revenu' ? TransactionType.revenu : TransactionType.depense,
      );
}
