import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'transaction_controller.dart';

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
      type = tx.type == 'Depósito' ? 'd' : 't';
      valueController.text = tx.value.toStringAsFixed(2).replaceAll('.', ',');
    } else {
      type = null;
      valueController.clear();
    }
  }

  void _onValueChanged(String input) {
    final regex = RegExp(r'^\d*(,?\d{0,2})?$');
    if (regex.hasMatch(input)) {
      valueController.value = valueController.value.copyWith(
        text: input,
        selection: TextSelection.collapsed(offset: input.length),
      );
      setState(() => error = null);
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

  Future<void> _submit() async {
    final controller = context.read<TransactionController>();
    final editingId = controller.editingId;

    final value = valueController.text.trim();
    final valueRegex = RegExp(r'^\d+,\d{2}$');

    if (type == null) {
      setState(() => error = 'Selecione o tipo de transação');
      return;
    }

    if (!valueRegex.hasMatch(value)) {
      setState(() => error = 'Informe o valor no formato 00,00');
      return;
    }

    final parsed = double.parse(value.replaceAll(',', '.'));
    final typeLabel = type == 'd' ? 'Depósito' : 'Transferência';

    setState(() => uploading = true);

    try {
      if (editingId != null) {
        await controller.editTransaction(
          editingId,
          type: typeLabel,
          value: parsed,
        );

        if (receiptFile != null) {
          await controller.uploadReceipt(
            transactionId: editingId,
            file: receiptFile!,
          );
        }
      } else {
        final newId = await controller.addTransaction(
          type: typeLabel,
          value: parsed,
        );

        if (receiptFile != null) {
          await controller.uploadReceipt(
            transactionId: newId,
            file: receiptFile!,
          );
        }
      }

      controller.setEditingId(null);
      widget.onCancel?.call();
    } finally {
      setState(() {
        uploading = false;
        receiptFile = null;
        type = null;
        valueController.clear();
        error = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final editingId = context.watch<TransactionController>().editingId;

    const double fieldWidth = 260;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 24,
          right: 24,
        ),
        child: Column(
          children: [
            // Tipo
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

            // Valor
            SizedBox(
              width: fieldWidth,
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

            // Botão salvar
            SizedBox(
              width: fieldWidth,
              height: 48,
              child: ElevatedButton(
                onPressed: uploading ? null : _submit,
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

            const SizedBox(height: 12),

            // Anexar arquivo
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
          ],
        ),
      ),
    );
  }
}
