import 'package:flutter/material.dart';

import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/orders/use_cases/create_service_item/create_service_item_widget.dart';

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
                        return ListTile(
                          title: Text(item.description ?? ''),
                          subtitle: Text('${item.quantity} X ${item.unitPrice} = ${(item.quantity ?? 0) * (item.unitPrice ?? 0)}'),
                        );
                      },
                      itemCount: items.length,
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
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Total de serviços: $amount'),
              ),
            ),
          ],
        );
      },
    );
  }
}
