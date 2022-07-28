import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:goauto/modules/orders/models/service_item_model.dart';

class FormServiceItemWidget extends StatefulWidget {
  const FormServiceItemWidget({
    Key? key,
    this.serviceItem,
  }) : super(key: key);
  final ServiceItemModel? serviceItem;

  @override
  State<FormServiceItemWidget> createState() => _FormServiceItemWidgetState();
}

class _FormServiceItemWidgetState extends State<FormServiceItemWidget> {
  final formatter = NumberFormat('#,##0.00', 'pt_BR');
  final formKey = GlobalKey<FormState>();
  final quantityFocus = FocusNode();
  final unitPriceFocus = FocusNode();

  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final unitPriceController = TextEditingController(text: 'R\$ 0,00');
  final unitPriceNotifier = ValueNotifier<num>(0);

  @override
  void initState() {
    if (widget.serviceItem != null) {
      descriptionController.text = widget.serviceItem?.description ?? '';
      quantityController.text = widget.serviceItem?.quantity?.toString() ?? '';
      unitPriceNotifier.value = widget.serviceItem?.unitPrice ?? 0;
      unitPriceController.text = 'R\$ ${formatter.format(widget.serviceItem?.unitPrice ?? 0)}';
    }
    super.initState();
  }

  void save() {
    if (formKey.currentState?.validate() == true) {
      Navigator.of(context).pop(
        ServiceItemModel(
          description: descriptionController.text,
          quantity: int.tryParse(quantityController.text),
          unitPrice: unitPriceNotifier.value,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(widget.serviceItem != null ? 'Alterar serviço' : 'Adicionar serviço'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
              ),
              validator: (text) => text?.isNotEmpty == true ? null : 'Digite o nome do serviço',
              onEditingComplete: () => unitPriceFocus.requestFocus(),
            ),
            TextFormField(
              focusNode: unitPriceFocus,
              controller: unitPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor unitário',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final value = double.parse(newValue.text) / 100;
                  if (value < 1000000) {
                    final newText = 'R\$ ${formatter.format(value)}';
                    unitPriceNotifier.value = value;
                    return newValue.copyWith(
                      text: newText,
                      selection: TextSelection.collapsed(
                        offset: newText.length,
                      ),
                    );
                  }
                  return oldValue;
                })
              ],
              onEditingComplete: () => quantityFocus.requestFocus(),
            ),
            TextFormField(
              focusNode: quantityFocus,
              controller: quantityController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
              ),
              onEditingComplete: save,
            ),
          ],
        ),
      ),
      actions: [
        AnimatedBuilder(
          animation: Listenable.merge([
            unitPriceNotifier,
            quantityController,
          ]),
          builder: (context, snapshot) {
            final quantity = num.tryParse(quantityController.text) ?? 0;
            var totalPrice = unitPriceNotifier.value * quantity;

            return Text('Total: R\$ ${formatter.format(totalPrice)}');
          },
        ),
        OutlinedButton(
          onPressed: save,
          child: const Icon(Icons.check),
        ),
      ],
    );
  }
}
