import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/orders/widgets/dialog_confirm_widget.dart';
import 'package:goauto/shared/utilz/calculate_discount.dart';
import 'package:intl/intl.dart';

import 'package:goauto/modules/orders/models/order_model.dart';
import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/orders/repositories/orders_repository.dart';
import 'package:goauto/modules/orders/use_cases/create_order/create_order_dto.dart';
import 'package:goauto/modules/orders/use_cases/create_order/update_order_dto.dart';
import 'package:goauto/modules/orders/widgets/parts_list_widget.dart';
import 'package:goauto/modules/orders/widgets/services_list_widget.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';

class FormOrderWidget extends StatefulWidget {
  const FormOrderWidget({
    Key? key,
    this.order,
  }) : super(key: key);
  final OrderModel? order;

  @override
  State<FormOrderWidget> createState() => _FormOrderWidgetState();
}

class _FormOrderWidgetState extends State<FormOrderWidget> {
  final formatter = NumberFormat('#,##0.00', 'pt_BR');

  final serviceItemsNotifier = ValueNotifier<ItemsState<ServiceItemModel>>(ItemsState<ServiceItemModel>(items: [], itemsAmount: 0));
  final partItemsNotifier = ValueNotifier<ItemsState<PartItemModel>>(ItemsState<PartItemModel>(items: [], itemsAmount: 0));

  final symptomController = TextEditingController();
  final additionalDiscountController = TextEditingController(text: 'R\$ 0,00');
  final additionalDiscountNotifier = ValueNotifier<num>(0);

  final payedAmountController = TextEditingController(text: 'R\$ 0,00');
  final payedAmountNotifier = ValueNotifier<num>(0);

  final amountNotifier = ValueNotifier<num>(0);

  FormOrderStatus status = FormOrderStatus.creating;

  @override
  void initState() {
    if (widget.order?.serviceItems != null) {
      final newItems = List<ServiceItemModel>.from(widget.order?.serviceItems ?? []);
      final newItemsAmount = newItems.fold<num>(0.00, (amount, item) => amount + (item.quantity ?? 0) * (item.unitPrice ?? 0));
      serviceItemsNotifier.value = ItemsState<ServiceItemModel>(
        items: newItems,
        itemsAmount: newItemsAmount,
      );
    }
    if (widget.order?.partItems != null) {
      final newItems = List<PartItemModel>.from(widget.order?.partItems ?? []);
      final newItemsAmount = newItems.fold<num>(
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
      partItemsNotifier.value = ItemsState<PartItemModel>(
        items: newItems,
        itemsAmount: newItemsAmount,
      );
    }
    symptomController.text = widget.order?.symptom ?? '';
    payedAmountNotifier.value = widget.order?.payedAmount ?? 0;
    additionalDiscountNotifier.value = widget.order?.additionalDiscount ?? 0;
    if (widget.order?.payedAmount != null) {
      payedAmountController.text = 'R\$ ${formatter.format(widget.order?.payedAmount ?? ' ')}';
    }
    if (widget.order?.additionalDiscount != null) {
      additionalDiscountController.text = 'R\$ ${formatter.format(widget.order?.additionalDiscount ?? ' ')}';
    }
    if (widget.order?.id != null) {
      status = FormOrderStatus.viewing;
    }
    super.initState();
  }

  bool hasNoWork() {
    return serviceItemsNotifier.value.items.isEmpty &&
        partItemsNotifier.value.items.isEmpty &&
        symptomController.text.isEmpty &&
        payedAmountNotifier.value == 0 &&
        additionalDiscountNotifier.value == 0;
  }

  Future<bool> onWillPop() async {
    final canPop = hasNoWork();
    if (!canPop && status != FormOrderStatus.viewing) {
      final response = await showConfirmDialog(
        context: context,
        title: 'Deseja cancelar?',
        body: 'Se você sair agora, a ordem de serviço será perdida.',
      );
      return response == true;
    }
    return true;
  }

  Future<void> save() async {
    if (!hasNoWork()) {
      final navigator = Navigator.of(context);
      final repository = GetIt.I.get<OrdersRepository>();
      switch (status) {
        case FormOrderStatus.creating:
          await repository.create(
            CreateOrderDTO(
              vehicleId: widget.order?.vehicle?.id ?? '',
              vehicle: widget.order?.vehicle ?? VehicleModel(),
              serviceItems: serviceItemsNotifier.value.items,
              partItems: partItemsNotifier.value.items,
              createdAt: DateTime.now(),
              additionalDiscount: additionalDiscountNotifier.value,
              payedAmount: payedAmountNotifier.value,
              symptom: symptomController.text,
            ),
          );
          navigator.pop(true);
          break;
        case FormOrderStatus.editing:
          await repository.update(
            UpdateOrderDTO(
              id: widget.order?.id ?? '',
              vehicleId: widget.order?.vehicle?.id ?? '',
              vehicle: widget.order?.vehicle ?? VehicleModel(),
              serviceItems: serviceItemsNotifier.value.items,
              partItems: partItemsNotifier.value.items,
              lastModified: DateTime.now(),
              additionalDiscount: additionalDiscountNotifier.value,
              payedAmount: payedAmountNotifier.value,
              symptom: symptomController.text,
            ),
          );
          navigator.pop(true);
          break;
        case FormOrderStatus.viewing:
          break;
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Ordem vazia'),
              content: const Text('Você precisa adicionar pelo menos um serviço ou uma peça antes de salvar.'),
              actions: [
                OutlinedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Ok'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Veículo: ${widget.order?.vehicle?.licensePlate?.toUpperCase()}'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Cliente: ${widget.order?.vehicle?.client?.name ?? 'Não informado'}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                AnimatedBuilder(
                  animation: Listenable.merge([serviceItemsNotifier, partItemsNotifier, additionalDiscountNotifier]),
                  builder: (context, child) {
                    final servicesAmount = serviceItemsNotifier.value.itemsAmount;
                    final partsAmount = partItemsNotifier.value.itemsAmount;
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Total: R\$ ${formatter.format(servicesAmount + partsAmount - additionalDiscountNotifier.value)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          leading: IconButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final canPop = await onWillPop();
              if (canPop) {
                navigator.pop();
              }
            },
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: () {
                switch (status) {
                  case FormOrderStatus.creating:
                    save();
                    break;
                  case FormOrderStatus.editing:
                    save();
                    break;
                  case FormOrderStatus.viewing:
                    setState(() {
                      status = FormOrderStatus.editing;
                    });
                    break;
                }
              },
              icon: status == FormOrderStatus.editing || status == FormOrderStatus.creating ? const Icon(Icons.check) : const Icon(Icons.edit),
            )
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                labelColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(
                    text: 'Serviços',
                  ),
                  Tab(
                    text: 'Peças',
                  ),
                  Tab(
                    text: 'Detalhes',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ServicesListWidget(
                      serviceItemsNotifier: serviceItemsNotifier,
                      status: status,
                    ),
                    PartListWidget(
                      partItemsNotifier: partItemsNotifier,
                      status: status,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: symptomController,
                              decoration: const InputDecoration(
                                labelText: 'Sintoma',
                              ),
                              maxLines: 4,
                              minLines: 2,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Desconto adicional',
                              ),
                              controller: additionalDiscountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                TextInputFormatter.withFunction((oldValue, newValue) {
                                  final value = double.parse(newValue.text) / 100;
                                  if (value < 1000000) {
                                    final newText = 'R\$ ${formatter.format(value)}';
                                    additionalDiscountNotifier.value = value;
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
                            ),
                            TextFormField(
                              controller: payedAmountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Valor Pago',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                TextInputFormatter.withFunction((oldValue, newValue) {
                                  final value = double.parse(newValue.text) / 100;
                                  if (value < 1000000) {
                                    final newText = 'R\$ ${formatter.format(value)}';
                                    additionalDiscountNotifier.value = value;
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemsState<T> {
  final List<T> items;
  final num itemsAmount;
  ItemsState({
    required this.items,
    required this.itemsAmount,
  });

  ItemsState<T> copyWith({
    List<T>? items,
    num? itemsAmount,
  }) {
    return ItemsState<T>(
      items: items ?? this.items,
      itemsAmount: itemsAmount ?? this.itemsAmount,
    );
  }

  @override
  String toString() => 'ItemsState(items: $items, itemsAmount: $itemsAmount)';
}

enum FormOrderStatus {
  creating,
  editing,
  viewing,
}
