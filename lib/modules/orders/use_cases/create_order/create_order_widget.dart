import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/orders/use_cases/create_order/create_order_dto.dart';
import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/orders/repositories/orders_repository.dart';
import 'package:goauto/modules/orders/use_cases/create_order/widgets/parts_list_widget.dart';
import 'package:goauto/modules/orders/use_cases/create_order/widgets/services_list_widget.dart';
import 'package:goauto/modules/providers/models/provider_model.dart';
import 'package:goauto/modules/providers/repositories/providers_repository.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';
import 'package:goauto/modules/vehicles/widgets/vehicles_autocomplete_widget.dart';

class CreateOrderWidget extends StatefulWidget {
  const CreateOrderWidget({Key? key}) : super(key: key);

  @override
  State<CreateOrderWidget> createState() => _CreateOrderWidgetState();
}

class _CreateOrderWidgetState extends State<CreateOrderWidget> {
  final providersNotifier = ValueNotifier<List<ProviderModel>>([]);
  final vehicleNotifier = ValueNotifier<VehicleModel?>(null);
  final serviceItemsNotifier = ValueNotifier<List<ServiceItemModel>>([]);
  final partItemsNotifier = ValueNotifier<List<PartItemModel>>([]);
  final pageController = PageController();

  Future<void> findProviders() async {
    providersNotifier.value = await GetIt.I.get<ProvidersRepository>().find();
  }

  @override
  void initState() {
    findProviders();
    super.initState();
  }

  Future<void> save() async {
    final navigator = Navigator.of(context);
    final id = await OrdersRepository().create(
      CreateOrderDTO(
        vehicleId: vehicleNotifier.value?.id ?? '',
        vehicle: vehicleNotifier.value ?? VehicleModel(),
        serviceItems: serviceItemsNotifier.value,
        partItems: partItemsNotifier.value,
        createdAt: DateTime.now(),
      ),
    );
    navigator.pop(id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: ValueListenableBuilder<VehicleModel?>(
        valueListenable: vehicleNotifier,
        builder: (context, vehicle, child) {
          return Scaffold(
            body: PageView(
              controller: pageController,
              children: [
                Scaffold(
                  appBar: AppBar(
                    title: const Text('Cadastrar ordem de serviço'),
                  ),
                  body: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: VehiclesAutocompleteWidget(
                          onSelected: (vehicle) => vehicleNotifier.value = vehicle,
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: vehicle != null
                      ? FloatingActionButton(
                          onPressed: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Icon(Icons.arrow_forward_rounded),
                        )
                      : Container(),
                ),
                Scaffold(
                  appBar: AppBar(
                    title: Text('Veículo: ${vehicle?.licensePlate?.toUpperCase()}'),
                    leading: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.close),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.check),
                      )
                    ],
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: DefaultTabController(
                          length: 2,
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
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    ServicesListWidget(
                                      serviceItemsNotifier: serviceItemsNotifier,
                                    ),
                                    PartListWidget(
                                      partItemsNotifier: partItemsNotifier,
                                    ),
                                  ],
                                ),
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
          );
        },
      ),
    );
  }
}
