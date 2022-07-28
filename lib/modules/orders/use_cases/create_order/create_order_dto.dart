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
  final num totalPrice;

  CreateOrderDTO({
    required this.vehicleId,
    required this.vehicle,
    required this.serviceItems,
    required this.partItems,
    required this.createdAt,
    required this.additionalDiscount,
    required this.payedAmount,
    required this.symptom,
    required this.totalPrice,
  });

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
      'totalPrice': totalPrice,
    };
  }
}
