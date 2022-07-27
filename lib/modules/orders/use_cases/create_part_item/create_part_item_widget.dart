import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/providers/models/provider_model.dart';
import 'package:goauto/modules/providers/widgets/providers_autocomplete_widget.dart';
import 'package:intl/intl.dart';

class CreatePartItemWidget extends StatefulWidget {
  const CreatePartItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePartItemWidget> createState() => _CreatePartItemWidgetState();
}

class _CreatePartItemWidgetState extends State<CreatePartItemWidget> {
  final formatter = NumberFormat('#,##0.00', 'pt_BR');
  final formKey = GlobalKey<FormState>();
  final quantityFocus = FocusNode();
  final unitPriceFocus = FocusNode();
  final discountFocus = FocusNode();
  final providerFocus = FocusNode();

  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final unitPriceController = TextEditingController(text: 'R\$ 0,00');
  final unitPriceNotifier = ValueNotifier<num>(0);
  final discountController = TextEditingController();
  final providerNotifier = ValueNotifier<ProviderModel?>(null);
  final discountTypeNotifier = ValueNotifier<DiscountType>(DiscountType.percent);

  void save() {
    if (formKey.currentState?.validate() == true) {
      Navigator.of(context).pop(
        PartItemModel(
          description: descriptionController.text,
          quantity: int.tryParse(quantityController.text),
          unitPrice: unitPriceNotifier.value,
          providerId: providerNotifier.value?.id,
          provider: providerNotifier.value,
          discountType: discountTypeNotifier.value,
          discount: discountController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Adicionar peça'),
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
              validator: (text) => text?.isNotEmpty == true ? null : 'Digite o nome da peça',
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
              onEditingComplete: () => discountFocus.requestFocus(),
            ),
            ValueListenableBuilder<DiscountType>(
              valueListenable: discountTypeNotifier,
              builder: (context, value, child) {
                final isPercent = value == DiscountType.percent;
                return Column(
                  children: [
                    DropdownButtonFormField<DiscountType>(
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Desconto',
                      ),
                      value: value,
                      items: const [
                        DropdownMenuItem(
                          value: DiscountType.percent,
                          child: Text('Porcento'),
                        ),
                        DropdownMenuItem(
                          value: DiscountType.subtract,
                          child: Text('Subtração'),
                        ),
                      ],
                      onChanged: (value) => discountTypeNotifier.value = value ?? DiscountType.percent,
                    ),
                    TextFormField(
                      focusNode: discountFocus,
                      inputFormatters: [
                        if (isPercent)
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final replaced = newValue.text.replaceAll(RegExp(r'[^0-9.,-]'), '');
                            return newValue.copyWith(
                              text: replaced,
                              selection: TextSelection.collapsed(
                                offset: replaced.length,
                              ),
                            );
                          })
                        else
                          FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Desconto',
                      ),
                      onEditingComplete: () => providerFocus.requestFocus(),
                    ),
                  ],
                );
              },
            ),
            // SwitchListTile(
            //   value: true,
            //   title: const Text('Manter esse desconto'),
            //   contentPadding: EdgeInsets.zero,
            //   onChanged: (value) {},
            // ),
            ProvidersAutocompleteWidget(
              focusNode: providerFocus,
              onSelected: (provider) {
                providerNotifier.value = provider;
              },
              onEditingComplete: save,
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: Navigator.of(context).pop,
          child: const Icon(Icons.close),
        ),
        AnimatedBuilder(
          animation: Listenable.merge([
            unitPriceNotifier,
            quantityController,
            discountController,
            discountTypeNotifier,
          ]),
          builder: (context, snapshot) {
            final quantity = num.tryParse(quantityController.text) ?? 0;
            var totalPrice = unitPriceNotifier.value * quantity;
            switch (discountTypeNotifier.value) {
              case DiscountType.percent:
                final parts = discountController.text.split('-');
                for (final part in parts) {
                  final discount = num.tryParse(part) ?? 0;
                  totalPrice = totalPrice - (totalPrice * discount / 100);
                }
                break;
              case DiscountType.subtract:
                final discount = num.tryParse(discountController.text) ?? 0;
                totalPrice = totalPrice - discount;
                break;
            }
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
