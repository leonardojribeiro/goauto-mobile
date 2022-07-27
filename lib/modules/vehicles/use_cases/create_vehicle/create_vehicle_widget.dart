import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/clients/models/client_model.dart';
import 'package:goauto/modules/clients/widgets/clients_autocomplete_widget.dart';
import 'package:goauto/modules/vehicles/use_cases/create_vehicle/create_vehicle_dto.dart';
import 'package:goauto/modules/vehicles/repositories/vehicles_repository.dart';

class CreateVehicleWidget extends StatefulWidget {
  const CreateVehicleWidget({
    Key? key,
    this.initialLicensePlate,
  }) : super(key: key);
  final String? initialLicensePlate;

  @override
  State<CreateVehicleWidget> createState() => _CreateVehicleWidgetState();
}

class _CreateVehicleWidgetState extends State<CreateVehicleWidget> {
  final licensePlateController = TextEditingController();
  final descriptionController = TextEditingController();
  final clientNotifier = ValueNotifier<ClientModel?>(null);

  @override
  void initState() {
    licensePlateController.text = widget.initialLicensePlate ?? '';
    super.initState();
  }

  Future<void> save() async {
    final navigator = Navigator.of(context);
    final id = await GetIt.I.get<VehiclesRepository>().create(
          CreateVehicleDTO(
            licensePlate: licensePlateController.text,
            description: descriptionController.text,
            clientId: clientNotifier.value?.id ?? '',
            client: clientNotifier.value ?? ClientModel(),
          ),
        );
    navigator.pop(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar veículo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: licensePlateController,
                decoration: const InputDecoration(
                  labelText: 'Placa',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClientsAutocompleteWidget(
                onSelected: (client) => clientNotifier.value = client,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        child: const Icon(Icons.check),
      ),
    );
  }
}
