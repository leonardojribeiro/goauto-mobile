import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/providers/dtos/create_provider_dto.dart';
import 'package:goauto/modules/providers/repositories/providers_repository.dart';

class CreateProviderWidget extends StatefulWidget {
  const CreateProviderWidget({Key? key}) : super(key: key);

  @override
  State<CreateProviderWidget> createState() => _CreateProviderWidgetState();
}

class _CreateProviderWidgetState extends State<CreateProviderWidget> {
  final nameController = TextEditingController();
  final telephoneController = TextEditingController();
  final whatsappController = TextEditingController();

  Future<void> save() async {
    final navigator = Navigator.of(context);
    final id = await GetIt.I.get<ProvidersRepository>().create(
          CreateProviderDTO(
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
        title: const Text('Cadastrar Fornecedor'),
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
