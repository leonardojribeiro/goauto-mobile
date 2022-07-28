import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/orders/use_cases/create_service_item/create_service_item_widget.dart';
import 'package:goauto/modules/orders/widgets/form_order_widget.dart';

class ServicesListWidget extends StatefulWidget {
  const ServicesListWidget({
    Key? key,
    required this.serviceItemsNotifier,
    required this.status,
  }) : super(key: key);
  final ValueNotifier<List<ServiceItemModel>> serviceItemsNotifier;
  final FormOrderStatus status;

  @override
  State<ServicesListWidget> createState() => _ServicesListWidgetState();
}

class _ServicesListWidgetState extends State<ServicesListWidget> {
  final formatter = NumberFormat('#,##0.00', 'pt_BR');
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ServiceItemModel>>(
      valueListenable: widget.serviceItemsNotifier,
      builder: (context, services, child) {
        final amount = services.fold<num>(0.00, (amount, item) => amount + (item.quantity ?? 0) * (item.unitPrice ?? 0));
        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final item = services[index];
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
                              const Divider(),
                            ],
                          ),
                        );
                      },
                      itemCount: services.length,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Total de serviços: R\$ ${formatter.format(amount)}'),
                    ),
                  ),
                  if (widget.status == FormOrderStatus.creating || widget.status == FormOrderStatus.editing)
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
