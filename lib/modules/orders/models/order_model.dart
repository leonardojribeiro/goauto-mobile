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
  final num? payedAmount;
  final String? symptom;

  OrderModel({
    this.id,
    this.vehicle,
    this.createdAt,
    this.serviceItems,
    this.partItems,
    this.additionalDiscount,
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
      payedAmount: map['payedAmount'],
      symptom: map['symptom'],
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, vehicle: $vehicle, createdAt: $createdAt, serviceItems: $serviceItems, partItems: $partItems, additionalDiscount: $additionalDiscount, payedAmount: $payedAmount, symptom: $symptom)';
  }

  OrderModel copyWith({
    String? id,
    VehicleModel? vehicle,
    DateTime? createdAt,
    List<ServiceItemModel>? serviceItems,
    List<PartItemModel>? partItems,
    num? additionalDiscount,
    num? payedAmount,
    String? symptom,
  }) {
    return OrderModel(
      id: id ?? this.id,
      vehicle: vehicle ?? this.vehicle,
      createdAt: createdAt ?? this.createdAt,
      serviceItems: serviceItems ?? this.serviceItems,
      partItems: partItems ?? this.partItems,
      additionalDiscount: additionalDiscount ?? this.additionalDiscount,
      payedAmount: payedAmount ?? this.payedAmount,
      symptom: symptom ?? this.symptom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicle': vehicle?.toMap(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'serviceItems': serviceItems?.map((x) => x.toMap()).toList(),
      'partItems': partItems?.map((x) => x.toMap()).toList(),
      'additionalDiscount': additionalDiscount,
      'payedAmount': payedAmount,
      'symptom': symptom,
    };
  }
}
