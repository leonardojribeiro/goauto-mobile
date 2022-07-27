import 'package:flutter/material.dart';

import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/use_cases/create_part_item/create_part_item_widget.dart';
import 'package:goauto/shared/utilz/calculate_discount.dart';
import 'package:goauto/shared/utilz/format_discount.dart';
import 'package:intl/intl.dart';

class PartListWidget extends StatefulWidget {
  const PartListWidget({
    Key? key,
    required this.partItemsNotifier,
  }) : super(key: key);
  final ValueNotifier<List<PartItemModel>> partItemsNotifier;

  @override
  State<PartListWidget> createState() => _PartListWidgetState();
}

class _PartListWidgetState extends State<PartListWidget> {
  final formatter = NumberFormat('#,##0.00', 'pt_BR');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PartItemModel>>(
      valueListenable: widget.partItemsNotifier,
      builder: (context, items, child) {
        // final amount = items.fold<num>(0.00, (amount, item) => amount + (item.quantity ?? 0) * (item.unitPrice ?? 0));
        final liquidAmount = items.fold<num>(
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
        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final item = items[index];
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
                              Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(),
                                  1: FixedColumnWidth(30),
                                  2: FixedColumnWidth(70),
                                  3: FlexColumnWidth(),
                                  4: FixedColumnWidth(70),
                                },
                                children: [
                                  const TableRow(
                                    children: [
                                      TableCell(child: Text('Valor Unitário')),
                                      TableCell(child: Text('QTD')),
                                      TableCell(child: Text('Bruto')),
                                      TableCell(child: Text('Desconto')),
                                      TableCell(child: Text('Líquido')),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Text('R\$ ${formatter.format(item.unitPrice)}'),
                                      ),
                                      TableCell(
                                        child: Text('${item.quantity}'),
                                      ),
                                      TableCell(
                                        child: Text('R\$ ${formatter.format(itemAmount)}'),
                                      ),
                                      TableCell(
                                        child: Text(formattedDiscount),
                                      ),
                                      TableCell(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text('R\$ ${formatter.format(totalPrice)}'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                      itemCount: items.length,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Total de peças: R\$ ${formatter.format(liquidAmount)}'),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final result = await showDialog<PartItemModel>(
                        context: context,
                        builder: (context) {
                          return const CreatePartItemWidget();
                        },
                      );
                      if (result != null) {
                        widget.partItemsNotifier.value = List.from([...widget.partItemsNotifier.value, result]);
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
