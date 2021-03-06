import 'package:goauto/modules/orders/models/part_item_model.dart';
import 'package:goauto/modules/orders/models/service_item_model.dart';
import 'package:goauto/modules/vehicles/models/vehicle_model.dart';

class OrderModel {
  final String? id;
  final VehicleModel? vehicle;
  final DateTime? createdAt;
  final List<ServiceItemModel>? serviceItems;
  final List<PartItemModel>? partItems;
  final num? additionalDiscount;
  final num? totalPrice;
  final num? payedAmount;
  final String? symptom;

  OrderModel({
    this.id,
    this.vehicle,
    this.createdAt,
    this.serviceItems,
    this.partItems,
    this.additionalDiscount,
    this.totalPrice,
    this.payedAmount,
    this.symptom,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      vehicle: map['vehicle'] != null ? VehicleModel.fromMap(map['vehicle']) : null,
      createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) : null,
      serviceItems: map['serviceItems'] != null ? List<ServiceItemModel>.from(map['serviceItems']?.map((x) => ServiceItemModel.fromMap(x))) : null,
      partItems: map['partItems'] != null ? List<PartItemModel>.from(map['partItems']?.map((x) => PartItemModel.fromMap(x))) : null,
      additionalDiscount: map['additionalDiscount'],
      totalPrice: map['totalPrice'],
      payedAmount: map['payedAmount'],
      symptom: map['symptom'],
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, vehicle: $vehicle, createdAt: $createdAt, serviceItems: $serviceItems, partItems: $partItems, additionalDiscount: $additionalDiscount, totalPrice: $totalPrice, payedAmount: $payedAmount, symptom: $symptom)';
  }
}
