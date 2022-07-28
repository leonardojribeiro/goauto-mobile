import 'package:flutter/material.dart';
import 'package:goauto/modules/orders/widgets/dialog_confirm_widget.dart';
import 'package:intl/intl.dart';

import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/orders/widgets/form_service_item_widget.dart';
import 'package:goauto/modules/orders/widgets/form_order_widget.dart';

class ServicesListWidget extends StatefulWidget {
  const ServicesListWidget({
    Key? key,
    required this.serviceItemsNotifier,
    required this.status,
  }) : super(key: key);
  final ValueNotifier<ItemsState<ServiceItemModel>> serviceItemsNotifier;
  final FormOrderStatus status;

  @override
  State<ServicesListWidget> createState() => _ServicesListWidgetState();
}

class _ServicesListWidgetState extends State<ServicesListWidget> {
  final formatter = NumberFormat('#,##0.00', 'pt_BR');
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ItemsState<ServiceItemModel>>(
      valueListenable: widget.serviceItemsNotifier,
      builder: (context, services, child) {
        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final item = services.items[index];
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('R\$ ${formatter.format(item.unitPrice)} X ${item.quantity}'),
                                  Text(
                                    '= R\$ ${formatter.format(itemAmount)}',
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
                                          title: 'Excluir serviço',
                                          body: 'Tem certeza?\nEssa ação não poderá ser revertida se as alterações forem salvas.',
                                        );
                                        if (canDelete == true) {
                                          widget.serviceItemsNotifier.value.items.removeAt(index);
                                          final newItems = List<ServiceItemModel>.from(widget.serviceItemsNotifier.value.items);
                                          final newItemsAmount = newItems.fold<num>(
                                            0.00,
                                            (amount, item) => (item.unitPrice ?? 0) * (item.quantity ?? 0),
                                          );
                                          widget.serviceItemsNotifier.value = ItemsState<ServiceItemModel>(
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
                                        final result = await showDialog<ServiceItemModel>(
                                          context: context,
                                          builder: (context) {
                                            return FormServiceItemWidget(
                                              serviceItem: item,
                                            );
                                          },
                                        );
                                        if (result != null) {
                                          final newItems = List<ServiceItemModel>.from(widget.serviceItemsNotifier.value.items);
                                          newItems[index] = result;
                                          final newItemsAmount = newItems.fold<num>(
                                            0.00,
                                            (amount, item) => (item.unitPrice ?? 0) * (item.quantity ?? 0),
                                          );
                                          widget.serviceItemsNotifier.value = ItemsState<ServiceItemModel>(
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
                      itemCount: services.items.length,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Total de serviços: R\$ ${formatter.format(services.itemsAmount)}'),
                    ),
                  ),
                  if (widget.status == FormOrderStatus.creating || widget.status == FormOrderStatus.editing)
                    OutlinedButton(
                      onPressed: () async {
                        final result = await showDialog<ServiceItemModel>(
                            context: context,
                            builder: (context) {
                              return const FormServiceItemWidget();
                            });
                        if (result != null) {
                          final newItems = List<ServiceItemModel>.from([...widget.serviceItemsNotifier.value.items, result]);
                          final newItemsAmount = newItems.fold<num>(0.00, (amount, item) => amount + (item.quantity ?? 0) * (item.unitPrice ?? 0));
                          widget.serviceItemsNotifier.value = ItemsState(
                            items: newItems,
                            itemsAmount: newItemsAmount,
                          );
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
