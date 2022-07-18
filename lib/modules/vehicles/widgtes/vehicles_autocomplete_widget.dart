import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:goauto/modules/vehicles/models/vehicle_model.dart';
import 'package:goauto/modules/vehicles/repositories/vehicles_repository.dart';
import 'package:goauto/modules/vehicles/use_cases/create_vehicle/create_vehicle_widget.dart';

class VehiclesAutocompleteWidget extends StatefulWidget {
  const VehiclesAutocompleteWidget({
    Key? key,
    required this.onSelected,
  }) : super(key: key);
  final void Function(VehicleModel vehicle) onSelected;

  @override
  State<VehiclesAutocompleteWidget> createState() => _VehiclesAutocompleteWidgetState();
}

class _VehiclesAutocompleteWidgetState extends State<VehiclesAutocompleteWidget> {
  final vehiclesNotifier = ValueNotifier<List<VehicleModel>>([]);
  final hasNoMoreOptionsNotifier = ValueNotifier<bool>(false);
  String inputText = '';

  Future<void> findVehicles() async {
    vehiclesNotifier.value = await GetIt.I.get<VehiclesRepository>().find();
    setState(() {});
  }

  @override
  void initState() {
    findVehicles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<VehicleModel>>(
      valueListenable: vehiclesNotifier,
      builder: (context, vehicles, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Autocomplete<VehicleModel>(
              optionsBuilder: (text) async {
                final matches = vehiclesNotifier.value.where(
                  (element) => (element.licensePlate ?? '').toLowerCase().contains(text.text.toLowerCase()),
                );
                hasNoMoreOptionsNotifier.value = matches.isEmpty;
                return matches;
              },
              onSelected: (vehicle) {
                hasNoMoreOptionsNotifier.value = false;
                widget.onSelected(vehicle);
              },
              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                return TextFormField(
                  onChanged: (text) => inputText = text,
                  decoration: InputDecoration(
                    labelText: vehicles.isNotEmpty ? 'Veículo' : 'Aguarde...',
                  ),
                  enabled: vehicles.isNotEmpty,
                  controller: textEditingController,
                  focusNode: focusNode,
                  onFieldSubmitted: (_) => onFieldSubmitted(),
                );
              },
              displayStringForOption: (vehicle) => '${vehicle.licensePlate?.toUpperCase()}',
            ),
            ValueListenableBuilder<bool>(
              valueListenable: hasNoMoreOptionsNotifier,
              builder: (context, value, child) {
                if (!value) {
                  return Container();
                }
                return OutlinedButton(
                  onPressed: () async {
                    final id = await Navigator.of(context).push<String>(MaterialPageRoute(
                      builder: (context) => CreateVehicleWidget(
                        initialLicensePlate: inputText,
                      ),
                    ));
                    if (id != null) {
                      findVehicles();
                    }
                    hasNoMoreOptionsNotifier.value = false;
                  },
                  child: const Text('Cadastrar este veículo'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
