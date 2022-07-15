import 'package:flutter/material.dart';
import 'package:goauto/modules/orders/models/service_item_model.dart';

class CreateServiceItemWidget extends StatefulWidget {
  const CreateServiceItemWidget({Key? key}) : super(key: key);

  @override
  State<CreateServiceItemWidget> createState() => _CreateServiceItemWidgetState();
}

class _CreateServiceItemWidgetState extends State<CreateServiceItemWidget> {
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final unitPriceController = TextEditingController(text: '0');

  void save() {
    Navigator.of(context).pop(
      ServiceItemModel(
        description: descriptionController.text,
        quantity: int.tryParse(quantityController.text),
        unitPrice: num.tryParse(unitPriceController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar serviço'),
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
