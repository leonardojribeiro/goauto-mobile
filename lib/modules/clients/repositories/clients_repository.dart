import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goauto/modules/clients/dtos/create_client_dto.dart';
import 'package:goauto/modules/clients/models/client_model.dart';

class ClientsRepository {
  Future<String> create(CreateClientDTO data) async {
    final raw = await FirebaseFirestore.instance.collection('clients').add(data.toMap());
    return raw.id;
  }

  Future<List<ClientModel>> find() async {
    final raw = await FirebaseFirestore.instance.collection('clients').get();
    return raw.docs
        .map((e) => ClientModel.fromMap(
              {
                'id': e.id,
                ...e.data(),
              },
            ))
        .toList();
  }
}
