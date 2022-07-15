class CreateVehicleDTO {
  final String licensePlate;
  final String clientId;
  final String description;
  CreateVehicleDTO({
    required this.licensePlate,
    required this.clientId,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'licensePlate': licensePlate,
      'clientId': clientId,
      'description': description,
    };
  }
}
