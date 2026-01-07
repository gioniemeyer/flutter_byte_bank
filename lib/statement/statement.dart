import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/transactions/transaction_controller.dart';
import 'package:mobile_byte_bank/transactions/transaction_form.dart';
import 'statement_item.dart';

class Statement extends StatefulWidget {
  const Statement({super.key});

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  // Estados
  bool editMode = false;
  bool deleteMode = false;

  // Filtros
  String filterMonth = '';
  String filterType = ''; // '' | 'Depósito' | 'Transferência'

  // Paginação
  int page = 1;
  int rowsPerPage = 8; // inicial
  final List<int> optionsRowsPerPage = const [5, 8, 10, 20];

  // Helpers filtro
  bool _matchesFilters(DateTime date, String type) {
    final monthLong = DateFormat('MMMM', 'pt_BR').format(date).toLowerCase();
    final monthQuery = filterMonth.trim().toLowerCase();
    final matchMonth = monthQuery.isEmpty || monthLong.contains(monthQuery);
    final matchType = filterType.isEmpty || filterType == type;
    return matchMonth && matchType;
  }

  void _toggleEditMode(TransactionController controller) {
    setState(() {
      editMode = !editMode;
      deleteMode = false;
    });
    controller.setEditingId(null);
  }

  void _toggleDeleteMode(TransactionController controller) {
    setState(() {
      deleteMode = !deleteMode;
      editMode = false;
    });
    controller.setEditingId(null);
  }

  void _openEditModal(BuildContext context, TransactionController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryText,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: TransactionForm(
            onCancel: () {
              Navigator.of(ctx).pop();
            },
          ),
        );
      },
    ).whenComplete(() {
      final c = context.read<TransactionController>();
      c.setEditingId(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    final editingId = controller.editingId;

    // Filtrar transações
    final filtered = controller.transactions.where((t) {
      final dt = t.date;
      return _matchesFilters(dt, t.type);
    }).toList();

    // Total de páginas
    final totalPages = (filtered.isEmpty)
        ? 1
        : ((filtered.length + rowsPerPage - 1) ~/ rowsPerPage);

    // Corrige página se necessário
    if (page > totalPages) page = totalPages;
    if (page < 1) page = 1;

    // Paginação
    final start = (page - 1) * rowsPerPage;
    final end = (start + rowsPerPage) > filtered.length
        ? filtered.length
        : (start + rowsPerPage);
    final paginated = filtered.sublist(start, end);

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(12), // igual ao CentralBox
      decoration: BoxDecoration(
        color: AppColors.primaryText,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // permite ajustar à altura do conteúdo
        children: [
          // Cabeçalho (conteúdo central de 240px)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Extrato',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Filtros',
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: AppColors.primaryText,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (ctx) {
                              String tempMonth = filterMonth;
                              String tempType = filterType;
                              return StatefulBuilder(
                                builder: (ctx, setModalState) => Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Filtros',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        decoration: InputDecoration(
                                          labelText: 'Mês (ex: junho)',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: AppColors.primaryColor,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        onChanged: (v) =>
                                            setModalState(() => tempMonth = v),
                                        controller: TextEditingController(
                                          text: tempMonth,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        height: 48,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryText,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primaryColor,
                                            width: 1,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: tempType.isEmpty
                                                ? null
                                                : tempType,
                                            hint: Text(
                                              'Tipo',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'Depósito',
                                                child: Text('Depósito'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'Transferência',
                                                child: Text('Transferência'),
                                              ),
                                            ],
                                            onChanged: (val) => setModalState(
                                              () => tempType = val ?? '',
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () {
                                                setState(() {
                                                  filterMonth = tempMonth;
                                                  filterType = tempType;
                                                  page = 1;
                                                });
                                                Navigator.pop(ctx);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    AppColors.primaryColor,
                                                side: const BorderSide(
                                                  color: AppColors.primaryColor,
                                                  width: 1,
                                                ),
                                              ),
                                              child: const Text('Aplicar'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.filter_alt,
                          color: AppColors.thirdText,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Editar',
                        onPressed: () => _toggleEditMode(controller),
                        icon: Icon(
                          Icons.edit,
                          color: editMode
                              ? AppColors.primaryColor
                              : AppColors.thirdText,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Excluir',
                        onPressed: () => _toggleDeleteMode(controller),
                        icon: Icon(
                          Icons.delete,
                          color: deleteMode
                              ? AppColors.primaryColor
                              : AppColors.thirdText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Lista com scroll — altura ligeiramente maior para evitar overflow
          SizedBox(
            height: 396, // 380 + 16 de respiro para evitar overflow
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: paginated.map((t) {
                  return StatementItem(
                    key: ValueKey(t.id),
                    id: int.tryParse(t.id.split('-').first) ?? t.hashCode,
                    date: t.date.toIso8601String(),
                    type: t.type,
                    value: t.value,
                    isClickable: editMode || deleteMode,
                    isSelected: editingId == t.id && editMode,
                    onClick: () {
                      if (editMode) {
                        controller.setEditingId(t.id);
                        _openEditModal(context, controller);
                      } else if (deleteMode) {
                        controller.deleteTransaction(t.id);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ),

          // Rodapé: seletor de rowsPerPage + paginação
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Itens por página
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryText,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: rowsPerPage,
                      items: optionsRowsPerPage
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Text('$v itens/página'),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          rowsPerPage = v;
                          page = 1; // reset
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Paginação (Anterior/Próximo)
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryText,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Anterior',
                        onPressed: page > 1
                            ? () => setState(() => page -= 1)
                            : null,
                        icon: const Icon(
                          Icons.chevron_left,
                          color: AppColors.thirdText,
                        ),
                      ),
                      Text(
                        '$page / $totalPages',
                        style: const TextStyle(
                          color: AppColors.thirdText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Próximo',
                        onPressed: page < totalPages
                            ? () => setState(() => page += 1)
                            : null,
                        icon: const Icon(
                          Icons.chevron_right,
                          color: AppColors.thirdText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
