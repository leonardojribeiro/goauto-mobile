class ServiceItemModel {
  final String? description;
  final int? quantity;
  final num? unitPrice;
  ServiceItemModel({
    this.description,
    this.quantity,
    this.unitPrice,
  });

  ServiceItemModel copyWith({
    String? description,
    int? quantity,
    num? unitPrice,
  }) {
    return ServiceItemModel(
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory ServiceItemModel.fromMap(Map<String, dynamic> map) {
    return ServiceItemModel(
      description: map['description'],
      quantity: map['quantity']?.toInt(),
      unitPrice: map['unitPrice'],
    );
  }

  @override
  String toString() => 'ServiceItemModel(description: $description, quantity: $quantity, unitPrice: $unitPrice)';
}
