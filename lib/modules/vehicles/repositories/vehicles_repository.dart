import 'package:goauto/modules/vehicles/dtos/create_vehicle_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';

class VehiclesRepository {
  Future<String> create(CreateVehicleDTO data) async {
    final raw = await FirebaseFirestore.instance.collection('vehicles').add(data.toMap());
    return raw.id;
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
