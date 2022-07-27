import 'package:goauto/modules/clients/models/client_model.dart';

class CreateVehicleDTO {
  final String licensePlate;
  final String clientId;
  final ClientModel client;
  final String description;

  CreateVehicleDTO({
    required this.licensePlate,
    required this.clientId,
    required this.client,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'licensePlate': licensePlate,
      'clientId': clientId,
      'client': client.toMap(),
      'description': description,
    };
  }

  @override
  String toString() {
    return 'CreateVehicleDTO(licensePlate: $licensePlate, clientId: $clientId, client: $client, description: $description)';
  }
}
