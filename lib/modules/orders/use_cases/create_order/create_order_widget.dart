import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/orders/dtos/create_order_dto.dart';
import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/orders/repositories/orders_repository.dart';
import 'package:goauto/modules/orders/use_cases/create_order/widgets/parts_list_widget.dart';
import 'package:goauto/modules/orders/use_cases/create_order/widgets/services_list_widget.dart';
import 'package:goauto/modules/providers/models/provider_model.dart';
import 'package:goauto/modules/providers/repositories/providers_repository.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';
import 'package:goauto/modules/vehicles/widgtes/vehicles_autocomplete_widget.dart';

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
            appBar: AppBar(
              title: const Text('Cadastrar ordem de serviço'),
            ),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: PageView(
                controller: pageController,
                children: [
                  Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: VehiclesAutocompleteWidget(
                          onSelected: (vehicle) => vehicleNotifier.value = vehicle,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Veículo: ${vehicle?.licensePlate?.toUpperCase()}'),
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
                ],
              ),
            ),
            floatingActionButton: vehicle != null
                ? AnimatedBuilder(
                    animation: Listenable.merge([pageController]),
                    builder: (context, snapshot) {
                      if (pageController.page == 0) {
                        return FloatingActionButton(
                          onPressed: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Icon(Icons.arrow_forward_rounded),
                        );
                      }
                      return FloatingActionButton(
                        onPressed: () {
                          save();
                        },
                        child: const Icon(Icons.check),
                      );
                    })
                : Container(),
          );
        },
      ),
    );
  }
}
