import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';

class CreateOrderDTO {
  final String vehicleId;
  final VehicleModel vehicle;
  final List<ServiceItemModel> serviceItems;
  final List<PartItemModel> partItems;
  final DateTime createdAt;
  
  CreateOrderDTO({
    required this.vehicleId,
    required this.vehicle,
    required this.serviceItems,
    required this.partItems,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicleId': vehicleId,
      'vehicle': vehicle.toMap(),
      'serviceItems': serviceItems.map((x) => x.toMap()).toList(),
      'partItems': partItems.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CreateOrderDTO.fromMap(Map<String, dynamic> map) {
    return CreateOrderDTO(
      vehicleId: map['vehicleId'] ?? '',
      vehicle: VehicleModel.fromMap(map['vehicle']),
      serviceItems: List<ServiceItemModel>.from(map['serviceItems']?.map((x) => ServiceItemModel.fromMap(x))),
      partItems: List<PartItemModel>.from(map['partItems']?.map((x) => PartItemModel.fromMap(x))),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
