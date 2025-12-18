import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'transaction_controller.dart';

class TransactionForm extends StatefulWidget {
  final VoidCallback? onCancel;

  const TransactionForm({super.key, this.onCancel});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  String? type; // 'd' | 't'
  final TextEditingController valueController = TextEditingController();
  String? error;

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
        valueController.text = tx.value
            .toStringAsFixed(2)
            .replaceAll('.', ','); // "00,00"
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
    // Permite 12, 12,3, 12,34
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

  void _submit() {
    final controller = context.read<TransactionController>();
    final editingId = controller.editingId;

    final value = valueController.text.trim();
    final typeValue = type;

    final valueRegex = RegExp(r'^\d+,\d{2}$');
    if (typeValue == null || typeValue.isEmpty) {
      setState(() => error = 'Selecione o tipo de transação');
      return;
    }
    if (!valueRegex.hasMatch(value)) {
      setState(() => error = 'Informe o valor no formato 00,00');
      return;
    }

    setState(() => error = null);

    final parsed = double.parse(value.replaceAll(',', '.'));
    final typeLabel = typeValue == 'd' ? 'Depósito' : 'Transferência';

    if (editingId != null) {
      controller.editTransaction(editingId, type: typeLabel, value: parsed);
      controller.setEditingId(null);
      widget.onCancel?.call();
    } else {
      controller.addTransaction(type: typeLabel, value: parsed);
    }

    // Limpa
    setState(() {
      type = null;
      valueController.text = '';
      error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    final editingId = controller.editingId;

    // Padroniza a largura de todos os campos/botões
    final double fieldWidth = 260;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dropdown tipo
          Container(
            height: 48,
            width: fieldWidth,
            decoration: BoxDecoration(
              color: AppColors.primaryText,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryColor, width: 1),
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
                  DropdownMenuItem(value: 'd', child: Text('Depósito')),
                  DropdownMenuItem(value: 't', child: Text('Transferência')),
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

          // Campo valor (mesma largura do dropdown)
          SizedBox(
            width: fieldWidth,
            height: 48,
            child: TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '00,00',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                helperStyle: const TextStyle(color: Colors.red, fontSize: 12),
              ),
              onChanged: _onValueChanged,
            ),
          ),

          const SizedBox(height: 16),

          // Botões (mesma largura)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: fieldWidth,
                height: 48,
                child: ElevatedButton(
                  onPressed: (type == null || valueController.text.isEmpty)
                      ? null
                      : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.primaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // Desabilitado com exactly thirdText
                    disabledBackgroundColor: AppColors.thirdText,
                    disabledForegroundColor: AppColors.primaryText,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  child: Text(
                    editingId != null ? 'Salvar edição' : 'Concluir transação',
                  ),
                ),
              ),

              if (editingId != null) const SizedBox(width: 8),

              if (editingId != null)
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
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
