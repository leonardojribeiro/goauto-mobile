import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';

class CreateOrderDTO {
  final String vehicleId;
  final VehicleModel vehicle;
  final List<ServiceItemModel> serviceItems;
  final List<PartItemModel> partItems;
  final DateTime createdAt;
  final num additionalDiscount;
  final num payedAmount;
  final String symptom;
  CreateOrderDTO({
    required this.vehicleId,
    required this.vehicle,
    required this.serviceItems,
    required this.partItems,
    required this.createdAt,
    required this.additionalDiscount,
    required this.payedAmount,
    required this.symptom,
  });

  CreateOrderDTO copyWith({
    String? vehicleId,
    VehicleModel? vehicle,
    List<ServiceItemModel>? serviceItems,
    List<PartItemModel>? partItems,
    DateTime? createdAt,
    num? additionalDiscount,
    num? payedAmount,
    String? symptom,
  }) {
    return CreateOrderDTO(
      vehicleId: vehicleId ?? this.vehicleId,
      vehicle: vehicle ?? this.vehicle,
      serviceItems: serviceItems ?? this.serviceItems,
      partItems: partItems ?? this.partItems,
      createdAt: createdAt ?? this.createdAt,
      additionalDiscount: additionalDiscount ?? this.additionalDiscount,
      payedAmount: payedAmount ?? this.payedAmount,
      symptom: symptom ?? this.symptom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleId': vehicleId,
      'vehicle': vehicle.toMap(),
      'serviceItems': serviceItems.map((x) => x.toMap()).toList(),
      'partItems': partItems.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'additionalDiscount': additionalDiscount,
      'payedAmount': payedAmount,
      'symptom': symptom,
    };
  }

  @override
  String toString() {
    return 'CreateOrderDTO(vehicleId: $vehicleId, vehicle: $vehicle, serviceItems: $serviceItems, partItems: $partItems, createdAt: $createdAt, additionalDiscount: $additionalDiscount, payedAmount: $payedAmount, symptom: $symptom)';
  }
}
