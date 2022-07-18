import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/clients/models/client_model.dart';
import 'package:goauto/modules/clients/repositories/clients_repository.dart';
import 'package:goauto/modules/clients/use_cases/create_client/create_client_widget.dart';

class ClientsAutocompleteWidget extends StatefulWidget {
  const ClientsAutocompleteWidget({
    Key? key,
    required this.onSelected,
  }) : super(key: key);
  final void Function(ClientModel client) onSelected;

  @override
  State<ClientsAutocompleteWidget> createState() => _ClientsAutocompleteWidgetState();
}

class _ClientsAutocompleteWidgetState extends State<ClientsAutocompleteWidget> {
  final vehiclesNotifier = ValueNotifier<List<ClientModel>>([]);
  final hasNoMoreOptionsNotifier = ValueNotifier<bool>(false);
  String inputText = '';

  Future<void> findClients() async {
    vehiclesNotifier.value = await GetIt.I.get<ClientsRepository>().find();
    setState(() {});
  }

  @override
  void initState() {
    findClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ClientModel>>(
      valueListenable: vehiclesNotifier,
      builder: (context, vehicles, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Autocomplete<ClientModel>(
              optionsBuilder: (text) async {
                final matches = vehiclesNotifier.value.where(
                  (element) => (element.name ?? '').toLowerCase().contains(text.text.toLowerCase()),
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
                    labelText: vehicles.isNotEmpty ? 'Cliente' : 'Aguarde...',
                  ),
                  enabled: vehicles.isNotEmpty,
                  controller: textEditingController,
                  focusNode: focusNode,
                  onFieldSubmitted: (_) => onFieldSubmitted(),
                );
              },
              displayStringForOption: (client) => client.name ?? '',
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
                      builder: (context) => CreateClientWidget(
                        initalName: inputText,
                      ),
                    ));
                    if (id != null) {
                      findClients();
                    }
                    hasNoMoreOptionsNotifier.value = false;
                  },
                  child: const Text('Cadastrar este cliente'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
