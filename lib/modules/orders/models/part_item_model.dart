import 'dart:convert';

import 'package:goauto/modules/providers/models/provider_model.dart';

enum DiscountType { percent, subtract }

class PartItemModel {
  final String? providerId;
  final ProviderModel? provider;
  final String? description;
  final int? quantity;
  final num? unitPrice;
  final String? discount;
  final DiscountType? discountType;

  PartItemModel({
    this.providerId,
    this.provider,
    this.description,
    this.quantity,
    this.unitPrice,
    this.discount,
    this.discountType,
  });

  PartItemModel copyWith({
    String? providerId,
    ProviderModel? provider,
    String? description,
    int? quantity,
    num? unitPrice,
    String? discount,
    DiscountType? discountType,
  }) {
    return PartItemModel(
      providerId: providerId ?? this.providerId,
      provider: provider ?? this.provider,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'provider': provider?.toMap(),
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discount': discount,
      'discountType': discountType?.index,
    };
  }

  factory PartItemModel.fromMap(Map<String, dynamic> map) {
    return PartItemModel(
      providerId: map['providerId'],
      provider: map['provider'] != null ? ProviderModel.fromMap(map['provider']) : null,
      description: map['description'],
      quantity: map['quantity']?.toInt(),
      unitPrice: map['unitPrice'],
      discount: map['discount'],
      discountType: map['discountType'] != null ? DiscountType.values[map['discountType']] : null,
    );
  }

  @override
  String toString() {
    return 'PartItemModel(providerId: $providerId, provider: $provider, description: $description, quantity: $quantity, unitPrice: $unitPrice, discount: $discount, discountType: $discountType)';
  }

  String toJson() => json.encode(toMap());

  factory PartItemModel.fromJson(String source) => PartItemModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PartItemModel &&
        other.providerId == providerId &&
        other.provider == provider &&
        other.description == description &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice &&
        other.discount == discount &&
        other.discountType == discountType;
  }

  @override
  int get hashCode {
    return providerId.hashCode ^ provider.hashCode ^ description.hashCode ^ quantity.hashCode ^ unitPrice.hashCode ^ discount.hashCode ^ discountType.hashCode;
  }
}
