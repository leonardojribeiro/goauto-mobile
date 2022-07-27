import 'package:get_it/get_it.dart';
import 'package:goauto/modules/clients/repositories/clients_repository.dart';
import 'package:goauto/modules/vehicles/use_cases/create_vehicle/create_vehicle_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';

class VehiclesRepository {
  final clientsRepository = GetIt.I.get<ClientsRepository>();

  Future<String> create(CreateVehicleDTO data) async {
    final raw = await FirebaseFirestore.instance.collection('vehicles').add(data.toMap());
    return raw.id;
  }

  Future<Map<String, dynamic>> findRawById(String id) async {
    final raw = await FirebaseFirestore.instance.collection('vehicles').doc(id).get();
    final clientId = raw.get('clientId') as String?;
    return {
      'id': raw.id,
      ...raw.data() ?? {},
      'client': clientId?.isNotEmpty == true ? await clientsRepository.findRawById(clientId ?? '') : null,
    };
  }

  Future<List<VehicleModel>> find() async {
    final raw = await FirebaseFirestore.instance.collection('vehicles').get();
    return raw.docs
        .map((e) => VehicleModel.fromMap(
              {
                'id': e.id,
                ...e.data(),
              },
            ))
        .toList();
  }
}
