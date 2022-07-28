import 'package:flutter/material.dart';
import 'package:goauto/modules/orders/models/order_model.dart';
import 'package:goauto/modules/orders/widgets/form_order_widget.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';
import 'package:goauto/modules/vehicles/widgets/vehicles_autocomplete_widget.dart';
import 'package:intl/intl.dart';

class CreateOrderWidget extends StatefulWidget {
  const CreateOrderWidget({Key? key}) : super(key: key);

  @override
  State<CreateOrderWidget> createState() => _CreateOrderWidgetState();
}

class _CreateOrderWidgetState extends State<CreateOrderWidget> {
  final formatter = NumberFormat('#,##0.00', 'pt_BR');

  final vehicleNotifier = ValueNotifier<VehicleModel?>(null);
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VehicleModel?>(
      valueListenable: vehicleNotifier,
      builder: (context, vehicle, child) {
        return Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              Builder(builder: (context) {
                return Scaffold(
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
                            FocusScope.of(context).unfocus();
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Icon(Icons.arrow_forward_rounded),
                        )
                      : Container(),
                );
              }),
              FormOrderWidget(
                order: OrderModel(
                  vehicle: vehicleNotifier.value,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
