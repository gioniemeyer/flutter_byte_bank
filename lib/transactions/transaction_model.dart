class TransactionModel {
  final String id;
  final DateTime date;
  final String type;
  final double value;
  final String? receiptUrl;

  TransactionModel({
    required this.id,
    required this.date,
    required this.type,
    required this.value,
    this.receiptUrl,
  });

  TransactionModel copyWith({
    String? id,
    DateTime? date,
    String? type,
    double? value,
    String? receiptUrl,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      value: value ?? this.value,
      receiptUrl: receiptUrl ?? this.receiptUrl,
    );
  }
}
