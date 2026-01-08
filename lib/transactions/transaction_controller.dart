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

  double get totalBalance {
    double total = 0;
    for (final t in _transactions) {
      if (t.type == 'Depósito') {
        total += t.value;
      } else if (t.type == 'Transferência') {
        total -= t.value;
      }
    }
    return total;
  }

  void setEditingId(String? id) {
    _editingId = id;
    notifyListeners();
  }

  String addTransaction({
    required String type,
    required double value,
    DateTime? date,
    String? receiptUrl,
  }) {
    final id =
        '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(999999)}';

    _transactions.add(
      TransactionModel(
        id: id,
        date: date ?? DateTime.now(),
        type: type,
        value: value,
        receiptUrl: receiptUrl,
      ),
    );

    notifyListeners();
    return id; // 👈 importante
  }

  void editTransaction(
    String id, {
    required String type,
    required double value,
    DateTime? date,
    String? receiptUrl,
  }) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final current = _transactions[index];

    _transactions[index] = current.copyWith(
      type: type,
      value: value,
      date: date ?? current.date,
      receiptUrl: receiptUrl ?? current.receiptUrl,
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

  void updateReceipt(String id, String receiptUrl) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index == -1) return;

    _transactions[index] =
        _transactions[index].copyWith(receiptUrl: receiptUrl);

    notifyListeners();
  }
}
