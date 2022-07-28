import 'package:flutter/material.dart';
import 'package:goauto/modules/orders/widgets/dialog_confirm_widget.dart';
import 'package:intl/intl.dart';

import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/widgets/form_part_item_widget.dart';
import 'package:goauto/modules/orders/widgets/form_order_widget.dart';
import 'package:goauto/shared/utilz/calculate_discount.dart';
import 'package:goauto/shared/utilz/format_discount.dart';

class PartListWidget extends StatefulWidget {
  const PartListWidget({
    Key? key,
    required this.partItemsNotifier,
    required this.status,
  }) : super(key: key);
  final ValueNotifier<ItemsState<PartItemModel>> partItemsNotifier;
  final FormOrderStatus status;

  @override
  State<PartListWidget> createState() => _PartListWidgetState();
}

class _PartListWidgetState extends State<PartListWidget> {
  final formatter = NumberFormat('#,##0.00', 'pt_BR');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ItemsState<PartItemModel>>(
      valueListenable: widget.partItemsNotifier,
      builder: (context, state, child) {
        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        final itemAmount = (item.unitPrice ?? 0) * (item.quantity ?? 0);
                        final totalPrice = calculateDiscount(
                          item.discountType ?? DiscountType.percent,
                          item.discount ?? '',
                          itemAmount,
                        );
                        final formattedDiscount = formatDiscount(
                          item.discountType ?? DiscountType.percent,
                          item.discount ?? '',
                        );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item.description ?? '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text('De: ${item.provider?.name ?? 'Não informado'}'),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('R\$ ${formatter.format(item.unitPrice ?? 0)} X ${item.quantity}'),
                                  Text('= R\$ ${formatter.format(itemAmount)}'),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('- $formattedDiscount'),
                                  Text(
                                    'Total: R\$ ${formatter.format(totalPrice)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              if (widget.status == FormOrderStatus.creating || widget.status == FormOrderStatus.editing)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      splashRadius: 20,
                                      onPressed: () async {
                                        final canDelete = await showConfirmDialog(
                                          context: context,
                                          title: 'Excluir peça',
                                          body: 'Tem certeza?\nEssa ação não poderá ser revertida se as alterações forem salvas.',
                                        );
                                        if (canDelete == true) {
                                          widget.partItemsNotifier.value.items.removeAt(index);
                                          final newItems = List<PartItemModel>.from(widget.partItemsNotifier.value.items);
                                          final newItemsAmount = newItems.fold<num>(
                                            0.00,
                                            (amount, item) {
                                              final itemAmount = (item.unitPrice ?? 0) * (item.quantity ?? 0);
                                              return amount +
                                                  calculateDiscount(
                                                    item.discountType ?? DiscountType.percent,
                                                    item.discount ?? '',
                                                    itemAmount,
                                                  );
                                            },
                                          );
                                          widget.partItemsNotifier.value = ItemsState<PartItemModel>(
                                            items: newItems,
                                            itemsAmount: newItemsAmount,
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                    IconButton(
                                      splashRadius: 20,
                                      onPressed: () async {
                                        final result = await showDialog<PartItemModel>(
                                          context: context,
                                          builder: (context) {
                                            return FormPartItemWidget(
                                              partItem: item,
                                            );
                                          },
                                        );
                                        if (result != null) {
                                          final newItems = List<PartItemModel>.from(widget.partItemsNotifier.value.items);
                                          newItems[index] = result;
                                          final newItemsAmount = newItems.fold<num>(
                                            0.00,
                                            (amount, item) {
                                              final itemAmount = (item.unitPrice ?? 0) * (item.quantity ?? 0);
                                              return amount +
                                                  calculateDiscount(
                                                    item.discountType ?? DiscountType.percent,
                                                    item.discount ?? '',
                                                    itemAmount,
                                                  );
                                            },
                                          );
                                          widget.partItemsNotifier.value = ItemsState<PartItemModel>(
                                            items: newItems,
                                            itemsAmount: newItemsAmount,
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                      itemCount: state.items.length,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Total de peças: R\$ ${formatter.format(state.itemsAmount)}'),
                    ),
                  ),
                  if (widget.status == FormOrderStatus.creating || widget.status == FormOrderStatus.editing)
                    OutlinedButton(
                      onPressed: () async {
                        final result = await showDialog<PartItemModel>(
                          context: context,
                          builder: (context) {
                            return const FormPartItemWidget();
                          },
                        );
                        if (result != null) {
                          final newItems = List<PartItemModel>.from([...widget.partItemsNotifier.value.items, result]);
                          final newItemsAmount = newItems.fold<num>(
                            0.00,
                            (amount, item) {
                              final itemAmount = (item.unitPrice ?? 0) * (item.quantity ?? 0);
                              return amount +
                                  calculateDiscount(
                                    item.discountType ?? DiscountType.percent,
                                    item.discount ?? '',
                                    itemAmount,
                                  );
                            },
                          );
                          widget.partItemsNotifier.value = ItemsState<PartItemModel>(
                            items: newItems,
                            itemsAmount: newItemsAmount,
                          );
                        }
                      },
                      child: const Text('Adicionar Peça'),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
