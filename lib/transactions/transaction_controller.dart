import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'transaction_model.dart';

class TransactionController extends ChangeNotifier {
  User? get _user => FirebaseAuth.instance.currentUser;

  String? _editingId;
  String? get editingId => _editingId;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  void setEditingId(String? id) {
    _editingId = id;
    notifyListeners();
  }

  double calculateTotalBalance(List<TransactionModel> transactions) {
    double total = 0;

    for (final t in transactions) {
      if (t.type == 'Depósito') {
        total += t.value;
      } else if (t.type == 'Transferência') {
        total -= t.value;
      }
    }

    return total;
  }

  // Transações do usuário logado
  Stream<List<TransactionModel>> watchTransactions() {
    final user = _user;
    if (user == null) {
      return const Stream.empty();
    }
    
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map(TransactionModel.fromFirestore)
              .toList();

          _transactions = list; // guarda no controller
          return list;
        });
  }

  // Transação em edição
  TransactionModel? get editingTransaction {
    if (_editingId == null) return null;

    try {
      return _transactions.firstWhere(
        (t) => t.id == _editingId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<String> addTransaction({
    required String type,
    required double value,

  }) async {
    final user = _user;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc();

    await ref.set({
      'type': type,
      'value': value,
      'date': Timestamp.now(),
      'receiptUrl': null,
    });

    return ref.id;
  }

  Future<void> editTransaction(
    String id, {
    required String type,
    required double value,
    String? receiptUrl,
  }) async {
    final user = _user;
    if (user == null) return;

    final data = {
      'type': type,
      'value': value,
    };

    if (receiptUrl != null) {
      data['receiptUrl'] = receiptUrl;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc(id)
        .update(data);
  }

  Future<void> deleteTransaction(String id) async {
    final user = _user;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc(id)
        .delete();
  }

  Future<String?> uploadReceipt({
    required String transactionId,
    required File file,
  }) async {
    final user = _user;
    if (user == null) return null;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('receipts')
        .child(user.uid)
        .child('$transactionId.jpg');

    await storageRef.putFile(file);
    final url = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc(transactionId)
        .update({'receiptUrl': url});

    return url;
  }

  void clear() {
    _editingId = null;
    notifyListeners();
  }
}
