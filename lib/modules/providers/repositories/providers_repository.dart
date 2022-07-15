import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goauto/modules/providers/dtos/create_provider_dto.dart';
import 'package:goauto/modules/providers/models/provider_model.dart';

class ProvidersRepository {
  Future<String> create(CreateProviderDTO data) async {
    final raw = await FirebaseFirestore.instance.collection('providers').add(data.toMap());
    return raw.id;
  }

  Future<List<ProviderModel>> find() async {
    final raw = await FirebaseFirestore.instance.collection('providers').get();
    return raw.docs
        .map((e) => ProviderModel.fromMap(
              {
                'id': e.id,
                ...e.data(),
              },
            ))
        .toList();
  }
}
