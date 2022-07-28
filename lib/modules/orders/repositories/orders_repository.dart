import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/orders/use_cases/create_order/create_order_dto.dart';
import 'package:goauto/modules/orders/models/order_model.dart';
import 'package:goauto/modules/orders/use_cases/create_order/update_order_dto.dart';
import 'package:goauto/modules/vehicles/repositories/vehicles_repository.dart';

class OrdersRepository {
  final vehiclesRepository = GetIt.I.get<VehiclesRepository>();

  Future<List<OrderModel>> find() async {
    final raw = await FirebaseFirestore.instance.collection('orders').get();
    return raw.docs
        .map((e) => OrderModel.fromMap({
              'id': e.id,
              ...e.data(),
            }))
        .toList();
  }

  Future<void> create(CreateOrderDTO data) async {
    await FirebaseFirestore.instance.collection('orders').add(data.toMap());
  }

  Future<void> update(UpdateOrderDTO data) async {
    final doc = FirebaseFirestore.instance.collection('orders').doc(data.id);
    await doc.set(
      data.toMap(),
      SetOptions(merge: true),
    );
  }
}
