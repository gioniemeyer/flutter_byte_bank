import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'transaction_controller.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionForm extends StatefulWidget {
  final VoidCallback? onCancel;

  const TransactionForm({super.key, this.onCancel});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  String? type;
  final TextEditingController valueController = TextEditingController();
  String? error;
  File? receiptFile;
  bool uploading = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hydrateFromEditing();
  }

  void _hydrateFromEditing() {
    final controller = context.read<TransactionController>();
    final tx = controller.editingTransaction;

    if (controller.editingId != null && tx != null && tx.id.isNotEmpty) {
      setState(() {
        type = tx.type == 'Depósito' ? 'd' : 't';
        valueController.text = tx.value.toStringAsFixed(2).replaceAll('.', ',');
        error = null;
      });
    } else {
      setState(() {
        type = null;
        valueController.text = '';
        error = null;
      });
    }
  }

  void _onValueChanged(String input) {
    final regex = RegExp(r'^\d*(,?\d{0,2})?$');
    if (regex.hasMatch(input)) {
      setState(() {
        valueController.text = input;
        valueController.selection = TextSelection.fromPosition(
          TextPosition(offset: valueController.text.length),
        );
        error = null;
      });
    }
  }

  Future<void> _pickReceipt() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        receiptFile = File(picked.path);
      });
    }
  }

  Future<String?> _uploadReceipt(String transactionId) async {
    if (receiptFile == null) return null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final ref = FirebaseStorage.instance
        .ref()
        .child('receipts')
        .child(user.uid)
        .child('$transactionId.jpg');

    await ref.putFile(receiptFile!);
    return await ref.getDownloadURL();
  }

  Future<void> _submit() async {
    final controller = context.read<TransactionController>();
    final editingId = controller.editingId;

    final value = valueController.text.trim();
    final typeValue = type;
    final valueRegex = RegExp(r'^\d+,\d{2}$');

    if (typeValue == null) {
      setState(() => error = 'Selecione o tipo de transação');
      return;
    }

    if (!valueRegex.hasMatch(value)) {
      setState(() => error = 'Informe o valor no formato 00,00');
      return;
    }

    final parsed = double.parse(value.replaceAll(',', '.'));
    final typeLabel = typeValue == 'd' ? 'Depósito' : 'Transferência';

    setState(() => uploading = true);

    if (editingId != null) {
      final receiptUrl = await _uploadReceipt(editingId);

      controller.editTransaction(
        editingId,
        type: typeLabel,
        value: parsed,
        receiptUrl: receiptUrl,
      );

      controller.setEditingId(null);
      widget.onCancel?.call();
    } else {
      final newId = await controller.addTransaction(
        type: typeLabel,
        value: parsed,
      );

      final receiptUrl = await _uploadReceipt(newId);

      if (receiptUrl != null) {
        controller.updateReceipt(newId, receiptUrl);
      }
    }

    setState(() {
      type = null;
      valueController.text = '';
      receiptFile = null;
      uploading = false;
      error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    final editingId = controller.editingId;

    final double maxHeight = MediaQuery.of(context).size.height * 0.7;
    const double fieldWidth = 260;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 24,
          right: 24,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dropdown tipo
                    Container(
                      height: 48,
                      width: fieldWidth,
                      decoration: BoxDecoration(
                        color: AppColors.primaryText,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: type,
                          hint: Text(
                            'Tipo de transação',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'd',
                              child: Text('Depósito'),
                            ),
                            DropdownMenuItem(
                              value: 't',
                              child: Text('Transferência'),
                            ),
                          ],
                          onChanged: (val) => setState(() => type = val),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Valor',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.thirdText,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Campo valor
                    SizedBox(
                      width: fieldWidth,
                      height: 48,
                      child: TextField(
                        controller: valueController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '00,00',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          filled: true,
                          fillColor: AppColors.primaryText,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 1,
                            ),
                          ),
                          helperText: error,
                          helperStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                        onChanged: _onValueChanged,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botões
                    SizedBox(
                      width: fieldWidth,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            (type == null || valueController.text.isEmpty)
                            ? null
                            : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: AppColors.primaryText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBackgroundColor: AppColors.thirdText,
                          disabledForegroundColor: AppColors.primaryText,
                        ),
                        child: Text(
                          editingId != null
                              ? 'Salvar edição'
                              : 'Concluir transação',
                        ),
                      ),
                    ),

                    if (editingId != null) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: fieldWidth,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            controller.setEditingId(null);
                            widget.onCancel?.call();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            side: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    SizedBox(
                      width: fieldWidth,
                      height: 32,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.attach_file),
                        label: Text(
                          receiptFile == null
                              ? 'Anexar arquivo'
                              : 'Arquivo selecionado',
                        ),
                        onPressed: _pickReceipt,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBackgroundColor: AppColors.thirdText,
                          disabledForegroundColor: AppColors.primaryText,
                        ),
                      ),
                    ),

                    if (receiptFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          receiptFile!.path.split('/').last,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
