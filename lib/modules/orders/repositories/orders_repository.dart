import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goauto/modules/orders/dtos/create_order_dto.dart';

class OrdersRepository {
  Future<String> create(CreateOrderDTO data) async {
    final raw = await FirebaseFirestore.instance.collection('orders').add(data.toMap());
    return raw.id;
  }
}
