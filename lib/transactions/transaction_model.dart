class TransactionModel {
  final String id;
  final DateTime date;
  final String type; // "Depósito" | "Transferência"
  final double value;

  TransactionModel({
    required this.id,
    required this.date,
    required this.type,
    required this.value,
  });

  TransactionModel copyWith({
    String? id,
    DateTime? date,
    String? type,
    double? value,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}
