import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/orders/dtos/create_order_dto.dart';
import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/orders/repositories/orders_repository.dart';
import 'package:goauto/modules/orders/use_cases/create_part_item/create_part_item_widget.dart';
import 'package:goauto/modules/orders/use_cases/create_service_item/create_service_item_widget.dart';
import 'package:goauto/modules/providers/models/provider_model.dart';
import 'package:goauto/modules/providers/repositories/providers_repository.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';
import 'package:goauto/modules/vehicles/repositories/vehicles_repository.dart';

class CreateOrderWidget extends StatefulWidget {
  const CreateOrderWidget({Key? key}) : super(key: key);

  @override
  State<CreateOrderWidget> createState() => _CreateOrderWidgetState();
}

class _CreateOrderWidgetState extends State<CreateOrderWidget> {
  final vehiclesNotifier = ValueNotifier<List<VehicleModel>>([]);
  final providersNotifier = ValueNotifier<List<ProviderModel>>([]);
  final vehicleNotifier = ValueNotifier<VehicleModel?>(null);
  final serviceItemsNotifier = ValueNotifier<List<ServiceItemModel>>([]);
  final partItemsNotifier = ValueNotifier<List<PartItemModel>>([]);

  Future<void> findClients() async {
    vehiclesNotifier.value = await GetIt.I.get<VehiclesRepository>().find();
    setState(() {});
  }

  Future<void> findProviders() async {
    providersNotifier.value = await GetIt.I.get<ProvidersRepository>().find();
  }

  @override
  void initState() {
    findClients();
    findProviders();
    super.initState();
  }

  Future<void> save() async {
    final navigator = Navigator.of(context);
    final id = await OrdersRepository().create(
      CreateOrderDTO(
        vehicleId: vehicleNotifier.value?.id ?? '',
        serviceItems: serviceItemsNotifier.value,
        partItems: partItemsNotifier.value,
        createdAt: DateTime.now(),
      ),
    );
    navigator.pop(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar ordem de serviço'),
      ),
      body: PageView(
        children: [
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Autocomplete<VehicleModel>(
                  optionsBuilder: (text) async {
                    final matches = vehiclesNotifier.value.where(
                      (element) => (element.licensePlate ?? '').toLowerCase().contains(text.text.toLowerCase()),
                    );
                    return matches;
                  },
                  onSelected: (vehicle) {
                    vehicleNotifier.value = vehicle;
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Veículo',
                    ),
                    controller: textEditingController,
                    focusNode: focusNode,
                    onFieldSubmitted: (_) => onFieldSubmitted(),
                  ),
                  displayStringForOption: (vehicle) => '${vehicle.licensePlate} (${vehicle.description}) ',
                ),
              ),
            ),
          ),
          ValueListenableBuilder<VehicleModel?>(
            valueListenable: vehicleNotifier,
            builder: (context, vehicle, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Veículo: ${vehicle?.licensePlate}'),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(
                                text: 'Serviços',
                              ),
                              Tab(
                                text: 'Peças',
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                ValueListenableBuilder<List<ServiceItemModel>>(
                                  valueListenable: serviceItemsNotifier,
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
                                                    serviceItemsNotifier.value = List.from([...serviceItemsNotifier.value, result]);
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
                                ),
                                ValueListenableBuilder<List<PartItemModel>>(
                                  valueListenable: partItemsNotifier,
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
                                              ValueListenableBuilder<List<ProviderModel>>(
                                                  valueListenable: providersNotifier,
                                                  builder: (context, providers, child) {
                                                    return OutlinedButton(
                                                      onPressed: () async {
                                                        final result = await showDialog<ServiceItemModel>(
                                                          context: context,
                                                          builder: (context) {
                                                            return CreatePartItemWidget(
                                                              providers: providers,
                                                            );
                                                          },
                                                        );
                                                        if (result != null) {
                                                          partItemsNotifier.value = List.from([...partItemsNotifier.value, result]);
                                                        }
                                                      },
                                                      child: const Text('Adicionar Peça'),
                                                    );
                                                  }),
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        child: const Icon(Icons.check),
      ),
    );
  }
}
