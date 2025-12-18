import 'package:flutter/foundation.dart';
import 'dart:math';
import 'transaction_model.dart';

class TransactionController extends ChangeNotifier {
  final List<TransactionModel> _transactions = [];
  String? _editingId;

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  String? get editingId => _editingId;

  TransactionModel? get editingTransaction => _editingId == null
      ? null
      : _transactions.firstWhere(
          (t) => t.id == _editingId,
          orElse: () => TransactionModel(
            id: '',
            date: DateTime.now(),
            type: 'Depósito',
            value: 0,
          ),
        );

  void setEditingId(String? id) {
    _editingId = id;
    notifyListeners();
  }

  void addTransaction({
    required String type, // "Depósito" | "Transferência"
    required double value,
    DateTime? date,
  }) {
    final id =
        '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(999999)}';
    _transactions.add(
      TransactionModel(
        id: id,
        date: date ?? DateTime.now(),
        type: type,
        value: value,
      ),
    );
    notifyListeners();
  }

  void editTransaction(
    String id, {
    required String type,
    required double value,
    DateTime? date,
  }) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index == -1) return;
    final current = _transactions[index];
    _transactions[index] = current.copyWith(
      type: type,
      value: value,
      date: date ?? current.date,
    );
    notifyListeners();
  }

  void deleteTransaction(String id) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      _transactions.removeAt(index);
      notifyListeners();
    }
  }
}
