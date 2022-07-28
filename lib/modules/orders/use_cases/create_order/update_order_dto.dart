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
  final num totalPrice;
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
    required this.totalPrice,
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
    num? totalPrice,
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
      totalPrice: totalPrice ?? this.totalPrice,
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
      'totalPrice': totalPrice,
      'symptom': symptom,
      'lastModified': lastModified.millisecondsSinceEpoch,
    };
  }
}
