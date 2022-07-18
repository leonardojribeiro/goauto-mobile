import 'package:flutter/material.dart';

import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/providers/widgets/providers_autocomplete_widget.dart';

class CreatePartItemWidget extends StatefulWidget {
  const CreatePartItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePartItemWidget> createState() => _CreatePartItemWidgetState();
}

class _CreatePartItemWidgetState extends State<CreatePartItemWidget> {
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final unitPriceController = TextEditingController(text: '0');
  final providerIdNotifier = ValueNotifier<String?>(null);

  void save() {
    Navigator.of(context).pop(
      PartItemModel(
        description: descriptionController.text,
        quantity: int.tryParse(quantityController.text),
        unitPrice: num.tryParse(unitPriceController.text),
        providerId: providerIdNotifier.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Adicionar peça'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            autofocus: true,
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descrição',
            ),
          ),
          TextFormField(
            controller: unitPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Valor unitário',
            ),
          ),
          TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantidade',
            ),
          ),
          ProvidersAutocompleteWidget(
            onSelected: (provider) {
              providerIdNotifier.value = provider.id;
            },
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: save,
          child: const Icon(Icons.check),
        ),
      ],
    );
  }
}
