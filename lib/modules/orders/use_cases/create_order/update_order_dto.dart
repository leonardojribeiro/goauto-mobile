import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';

class UpdateOrderDTO {
  final String id;
  final String vehicleId;
  final VehicleModel vehicle;
  final List<ServiceItemModel> serviceItems;
  final List<PartItemModel> partItems;
  final num additionalDiscount;
  final num payedAmount;
  final String symptom;
  final DateTime lastModified;

  UpdateOrderDTO({
    required this.id,
    required this.vehicleId,
    required this.vehicle,
    required this.serviceItems,
    required this.partItems,
    required this.additionalDiscount,
    required this.payedAmount,
    required this.symptom,
    required this.lastModified,
  });

  UpdateOrderDTO copyWith({
    String? id,
    String? vehicleId,
    VehicleModel? vehicle,
    List<ServiceItemModel>? serviceItems,
    List<PartItemModel>? partItems,
    num? additionalDiscount,
    num? payedAmount,
    String? symptom,
    DateTime? lastModified,
  }) {
    return UpdateOrderDTO(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicle: vehicle ?? this.vehicle,
      serviceItems: serviceItems ?? this.serviceItems,
      partItems: partItems ?? this.partItems,
      additionalDiscount: additionalDiscount ?? this.additionalDiscount,
      payedAmount: payedAmount ?? this.payedAmount,
      symptom: symptom ?? this.symptom,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'vehicle': vehicle.toMap(),
      'serviceItems': serviceItems.map((x) => x.toMap()).toList(),
      'partItems': partItems.map((x) => x.toMap()).toList(),
      'additionalDiscount': additionalDiscount,
      'payedAmount': payedAmount,
      'symptom': symptom,
      'lastModified': lastModified.millisecondsSinceEpoch,
    };
  }

  factory UpdateOrderDTO.fromMap(Map<String, dynamic> map) {
    return UpdateOrderDTO(
      id: map['id'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
      vehicle: VehicleModel.fromMap(map['vehicle']),
      serviceItems: List<ServiceItemModel>.from(map['serviceItems']?.map((x) => ServiceItemModel.fromMap(x))),
      partItems: List<PartItemModel>.from(map['partItems']?.map((x) => PartItemModel.fromMap(x))),
      additionalDiscount: map['additionalDiscount'] ?? 0,
      payedAmount: map['payedAmount'] ?? 0,
      symptom: map['symptom'] ?? '',
      lastModified: DateTime.fromMillisecondsSinceEpoch(map['lastModified']),
    );
  }

  @override
  String toString() {
    return 'UpdateOrderDTO(id: $id, vehicleId: $vehicleId, vehicle: $vehicle, serviceItems: $serviceItems, partItems: $partItems, additionalDiscount: $additionalDiscount, payedAmount: $payedAmount, symptom: $symptom, lastModified: $lastModified)';
  }
}
