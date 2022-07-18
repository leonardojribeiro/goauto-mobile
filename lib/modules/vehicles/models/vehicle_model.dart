import 'package:goauto/modules/clients/models/client_model.dart';

class VehicleModel {
  final String? id;
  final String? description;
  final String? clientId;
  final ClientModel? client;
  final String? licensePlate;

  VehicleModel({
    this.id,
    this.description,
    this.clientId,
    this.client,
    this.licensePlate,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'],
      description: map['description'],
      clientId: map['clientId'],
      client: map['client'] != null ? ClientModel.fromMap(map['client']) : null,
      licensePlate: map['licensePlate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'clientId': clientId,
      'client': client?.toMap(),
      'licensePlate': licensePlate,
    };
  }

  @override
  String toString() {
    return 'VehicleModel(id: $id, description: $description, clientId: $clientId, client: $client, licensePlate: $licensePlate)';
  }
}
