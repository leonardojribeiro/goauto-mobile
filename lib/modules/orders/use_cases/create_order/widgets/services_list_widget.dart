import 'package:flutter/material.dart';

import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/orders/use_cases/create_service_item/create_service_item_widget.dart';
import 'package:intl/intl.dart';

class ServicesListWidget extends StatefulWidget {
  const ServicesListWidget({
    Key? key,
    required this.serviceItemsNotifier,
  }) : super(key: key);
  final ValueNotifier<List<ServiceItemModel>> serviceItemsNotifier;

  @override
  State<ServicesListWidget> createState() => _ServicesListWidgetState();
}

class _ServicesListWidgetState extends State<ServicesListWidget> {
  final formatter = NumberFormat('#,##0.00', 'pt_BR');
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ServiceItemModel>>(
      valueListenable: widget.serviceItemsNotifier,
      builder: (context, items, child) {
        final amount = items.fold<num>(0.00, (amount, item) => amount + (item.quantity ?? 0) * (item.unitPrice ?? 0));
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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                item.description ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(),
                                  1: FlexColumnWidth(),
                                  2: FlexColumnWidth(),
                                },
                                children: [
                                  const TableRow(
                                    children: [
                                      TableCell(child: Text('Valor Unitário')),
                                      TableCell(child: Text('QTD')),
                                      TableCell(child: Text('Valor Total')),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Text('R\$ ${formatter.format(item.unitPrice ?? 0)}'),
                                      ),
                                      TableCell(
                                        child: Text('${item.quantity}'),
                                      ),
                                      TableCell(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text('R\$ ${formatter.format(itemAmount)}'),
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
                      child: Text('Total de serviços: R\$ ${formatter.format(amount)}'),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final result = await showDialog<ServiceItemModel>(
                          context: context,
                          builder: (context) {
                            return const CreateServiceItemWidget();
                          });
                      if (result != null) {
                        widget.serviceItemsNotifier.value = List.from([...widget.serviceItemsNotifier.value, result]);
                      }
                    },
                    child: const Text('Adicionar serviço'),
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
