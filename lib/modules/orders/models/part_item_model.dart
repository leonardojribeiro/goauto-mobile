import 'package:goauto/modules/orders/models/base_item_model.dart';

class PartItemModel extends BaseItemModel {
  final String? providerId;

  PartItemModel({
    super.description,
    super.quantity,
    super.unitPrice,
    this.providerId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      ...super.toMap(),
    };
  }

  factory PartItemModel.fromMap(Map<String, dynamic> map) {
    return PartItemModel(
      providerId: map['providerId'],
      description: map['description'],
      quantity: map['quantity']?.toInt(),
      unitPrice: map['unitPrice'],
    );
  }
}
