import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/clients/models/client_model.dart';
import 'package:goauto/modules/clients/repositories/clients_repository.dart';
import 'package:goauto/modules/vehicles/dtos/create_vehicle_dto.dart';
import 'package:goauto/modules/vehicles/repositories/vehicles_repository.dart';

class CreateVehicleWidget extends StatefulWidget {
  const CreateVehicleWidget({Key? key}) : super(key: key);

  @override
  State<CreateVehicleWidget> createState() => _CreateVehicleWidgetState();
}

class _CreateVehicleWidgetState extends State<CreateVehicleWidget> {
  final licensePlateController = TextEditingController();
  final descriptionController = TextEditingController();
  final clientIdNotifier = ValueNotifier<String?>(null);
  final clientsNotifier = ValueNotifier<List<ClientModel>>([]);

  Future<void> findClients() async {
    clientsNotifier.value = await GetIt.I.get<ClientsRepository>().find();
    setState(() {});
  }

  @override
  void initState() {
    findClients();
    super.initState();
  }

  Future<void> save() async {
    final navigator = Navigator.of(context);
    final id = await GetIt.I.get<VehiclesRepository>().create(
          CreateVehicleDTO(
            licensePlate: licensePlateController.text,
            description: descriptionController.text,
            clientId: clientIdNotifier.value ?? '',
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
              child: Autocomplete<ClientModel>(
                optionsBuilder: (text) async {
                  final matches = clientsNotifier.value.where(
                    (element) => element.name.toLowerCase().contains(text.text.toLowerCase()),
                  );
                  return matches;
                },
                onSelected: (client) {
                  clientIdNotifier.value = client.id;
                },
                fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Cliente',
                  ),
                  controller: textEditingController,
                  focusNode: focusNode,
                  onFieldSubmitted: (_) => onFieldSubmitted(),
                ),
                displayStringForOption: (c) => c.name,
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
