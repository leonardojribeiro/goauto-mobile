import 'package:goauto/modules/orders/models/part_item_model.dart';

String formatDiscount(DiscountType type, String discountString) {
  switch (type) {
    case DiscountType.percent:
      return discountString.split('-').fold<String>('', (previousValue, element) => previousValue.isNotEmpty ? '$previousValue - $element%' : '$element%');
    case DiscountType.subtract:
      return discountString;
  }
}
