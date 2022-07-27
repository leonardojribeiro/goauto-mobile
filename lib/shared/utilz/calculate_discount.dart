import 'package:goauto/modules/orders/models/part_item_model.dart';

num calculateDiscount(DiscountType discountType, String discountString, num amount) {
  var totalPrice = amount;
  switch (discountType) {
    case DiscountType.percent:
      final parts = discountString.split('-');
      for (final part in parts) {
        final discount = num.tryParse(part) ?? 0;
        totalPrice = totalPrice - (totalPrice * discount / 100);
      }
      break;
    case DiscountType.subtract:
      final discount = num.tryParse(discountString) ?? 0;
      totalPrice = totalPrice - discount;
      break;
  }
  return totalPrice;
}
