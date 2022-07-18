import 'package:flutter/material.dart';

import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/orders/use_cases/create_part_item/create_part_item_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PartItemModel>>(
      valueListenable: widget.partItemsNotifier,
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
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Total de peças: $amount'),
              ),
            ),
          ],
        );
      },
    );
  }
}
