import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:goauto/modules/providers/models/provider_model.dart';
import 'package:goauto/modules/providers/repositories/providers_repository.dart';
import 'package:goauto/modules/providers/use_cases/create_provider/create_provider_widget.dart';

class ProvidersAutocompleteWidget extends StatefulWidget {
  const ProvidersAutocompleteWidget({
    Key? key,
    required this.onSelected,
    this.focusNode,
    this.onEditingComplete,
    this.initialValue,
  }) : super(key: key);
  final void Function(ProviderModel provider) onSelected;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ProviderModel? initialValue;

  @override
  State<ProvidersAutocompleteWidget> createState() => _ProvidersAutocompleteWidgetState();
}

class _ProvidersAutocompleteWidgetState extends State<ProvidersAutocompleteWidget> {
  final providersNotifier = ValueNotifier<List<ProviderModel>>([]);
  final hasNoMoreOptionsNotifier = ValueNotifier<bool>(false);
  String inputText = '';

  Future<void> findProviders() async {
    providersNotifier.value = await GetIt.I.get<ProvidersRepository>().find();
    setState(() {});
  }

  @override
  void initState() {
    findProviders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProviderModel>>(
      valueListenable: providersNotifier,
      builder: (context, vehicles, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Autocomplete<ProviderModel>(
              optionsBuilder: (text) async {
                final matches = providersNotifier.value.where(
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
                if (widget.initialValue != null) {
                  textEditingController.text = widget.initialValue?.name ?? '';
                }
                return Focus(
                  focusNode: widget.focusNode,
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      focusNode.requestFocus();
                    }
                  },
                  child: TextFormField(
                    onChanged: (text) => inputText = text,
                    decoration: InputDecoration(
                      labelText: vehicles.isNotEmpty ? 'Fornecedor' : 'Aguarde...',
                    ),
                    enabled: vehicles.isNotEmpty,
                    controller: textEditingController,
                    focusNode: focusNode,
                    validator: (text) => text?.isNotEmpty == true ? null : 'Selecione um fornecedor',
                    onFieldSubmitted: (_) => onFieldSubmitted(),
                    onEditingComplete: widget.onEditingComplete,
                  ),
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
                      builder: (context) => CreateProviderWidget(
                        initalName: inputText,
                      ),
                    ));
                    if (id != null) {
                      findProviders();
                    }
                    hasNoMoreOptionsNotifier.value = false;
                  },
                  child: const Text('Cadastrar este fornecedor'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
