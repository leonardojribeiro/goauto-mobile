import 'package:goauto/modules/clients/models/client_model.dart';

class VehicleModel {
  final String? id;
  final String? description;
  final ClientModel? client;
  final String? licensePlate;

  VehicleModel({
    this.id,
    this.description,
    this.client,
    this.licensePlate,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'],
      description: map['description'],
      client: map['client'] != null ? ClientModel.fromMap(map['client']) : null,
      licensePlate: map['licensePlate'],
    );
  }

  @override
  String toString() {
    return 'VehicleModel(id: $id, description: $description, client: $client, licensePlate: $licensePlate)';
  }
}
