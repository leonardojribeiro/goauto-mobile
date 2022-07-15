class BaseItemModel {
  final String? description;
  final int? quantity;
  final num? unitPrice;

  BaseItemModel({
    this.description,
    this.quantity,
    this.unitPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory BaseItemModel.fromMap(Map<String, dynamic> map) {
    return BaseItemModel(
      description: map['description'],
      quantity: map['quantity']?.toInt(),
      unitPrice: map['unitPrice'],
    );
  }
}
