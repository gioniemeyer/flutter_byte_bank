import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory TransactionModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    final timestamp = data['date'];

    return TransactionModel(
      id: doc.id,
      type: data['type'] as String,
      value: (data['value'] as num).toDouble(),
      date: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.now(),
      receiptUrl: data['receiptUrl'] as String?,
    );
  }
}
