import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mobile_byte_bank/theme/colors.dart';
import 'package:mobile_byte_bank/transactions/transaction_controller.dart';
import 'package:mobile_byte_bank/transactions/transaction_form.dart';
import 'package:mobile_byte_bank/transactions/transaction_model.dart';
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

  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  late final Stream<List<TransactionModel>> _transactionsStream;
  @override
  void initState() {
    super.initState();
    _transactionsStream =
        context.read<TransactionController>().watchTransactions();
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

  void _openEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryText,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: TransactionForm(
          onCancel: () => Navigator.of(ctx).pop(),
        ),
      ),
    ).whenComplete(() {
      context.read<TransactionController>().setEditingId(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();

    return StreamBuilder<List<TransactionModel>>(
      stream: _transactionsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allTransactions = snapshot.data ?? [];

        final filtered = allTransactions.where((t) {
          return _matchesFilters(t.date, t.type);
        }).toList();

        filtered.sort((a, b) => b.date.compareTo(a.date));

        // Total de páginas
        final totalPages = filtered.isEmpty
            ? 1
            : ((filtered.length + rowsPerPage - 1) ~/ rowsPerPage);

        page = page.clamp(1, totalPages);

        final start = (page - 1) * rowsPerPage;
        final end = (start + rowsPerPage).clamp(0, filtered.length);
        final paginated = filtered.sublist(start, end);

        final editingId = controller.editingId;

        return Container(
          margin: const EdgeInsets.only(top: 24, bottom: 24),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.primaryText,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Cabeçalho (conteúdo central de 240px)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                            final monthController = TextEditingController(text: filterMonth);
                            String tempType = filterType;
                              
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: AppColors.primaryText,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (ctx) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(ctx).viewInsets.bottom, // 🔴 empurra com teclado
                                  ),
                                  child: StatefulBuilder(
                                    builder: (ctx, setModalState) => Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
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

                                          // ===== MÊS =====
                                          TextField(
                                            controller: monthController,
                                            decoration: InputDecoration(
                                              labelText: 'Mês (ex: junho)',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: AppColors.primaryColor,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 12),

                                          // ===== TIPO =====
                                          Container(
                                            height: 48,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryText,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppColors.primaryColor,
                                                width: 1,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            alignment: Alignment.centerLeft,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: tempType.isEmpty ? null : tempType,
                                                hint: Text(
                                                  'Tipo',
                                                  style: TextStyle(color: Colors.grey[600]),
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
                                                onChanged: (val) {
                                                  setModalState(() {
                                                    tempType = val ?? '';
                                                  });
                                                },
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 16),

                                          // ===== APLICAR =====
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      filterMonth = monthController.text;
                                                      filterType = tempType;
                                                      page = 1;
                                                    });
                                                    Navigator.pop(ctx);
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    foregroundColor: AppColors.primaryColor,
                                                    side: const BorderSide(
                                                      color: AppColors.primaryColor,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: const Text('Aplicar'),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      filterMonth = '';
                                                      filterType = '';
                                                      page = 1;
                                                    });
                                                    Navigator.pop(ctx);
                                                  },
                                                  child: const Text(
                                                    'Limpar',
                                                    style: TextStyle(color: AppColors.primaryColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 8),
                                        ],
                                      ),
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

              // Lista com scroll — altura ligeiramente maior para evitar overflow
              SizedBox(
                height: 396, // 380 + 16 de respiro para evitar overflow
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: paginated.length,
                  itemBuilder: (context, index) {
                    final t = paginated[index];
                      return StatementItem(
                        key: ValueKey(t.id),
                        id: t.id,
                        date: t.date.toIso8601String(),
                        type: t.type,
                        value: t.value,
                        receiptUrl: t.receiptUrl,
                        isClickable: editMode || deleteMode,
                        isSelected: editingId == t.id && editMode,
                        onClick: () {
                          if (editMode) {
                            controller.setEditingId(t.id);
                            _openEditModal(context);
                          } else if (deleteMode) {
                            controller.deleteTransaction(t.id);
                          }
                        },
                      );
                  },
                ),
              ),

              // Rodapé: seletor de rowsPerPage + paginação
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        // === BOX 1: Itens por página ===
                        SizedBox(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryText,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: rowsPerPage,
                                isExpanded: true,
                                items: optionsRowsPerPage
                                    .map(
                                      (v) => DropdownMenuItem(
                                        value: v,
                                        child: Text('$v itens/pág'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  if (v == null) return;
                                  setState(() {
                                    rowsPerPage = v;
                                    page = 1;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        // === BOX 2: Paginação ===
                        SizedBox(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryText,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
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
                                  padding: EdgeInsets.zero,
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
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
