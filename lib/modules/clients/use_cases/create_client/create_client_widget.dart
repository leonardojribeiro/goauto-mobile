import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:goauto/modules/clients/dtos/create_client_dto.dart';
import 'package:goauto/modules/clients/repositories/clients_repository.dart';

class CreateClientWidget extends StatefulWidget {
  const CreateClientWidget({
    Key? key,
    this.initalName,
  }) : super(key: key);
  final String? initalName;

  @override
  State<CreateClientWidget> createState() => _CreateClientWidgetState();
}

class _CreateClientWidgetState extends State<CreateClientWidget> {
  final nameController = TextEditingController();
  final telephoneController = TextEditingController();
  final whatsappController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.initalName ?? '';
    super.initState();
  }

  Future<void> save() async {
    final navigator = Navigator.of(context);
    final id = await GetIt.I.get<ClientsRepository>().create(
          CreateClientDTO(
            name: nameController.text,
            telephone: telephoneController.text,
            whatsapp: whatsappController.text,
          ),
        );
    navigator.pop(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar cliente'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: telephoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: whatsappController,
                decoration: const InputDecoration(
                  labelText: 'WhatsApp',
                ),
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
