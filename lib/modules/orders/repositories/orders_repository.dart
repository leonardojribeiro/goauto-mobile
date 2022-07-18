import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/orders/dtos/create_order_dto.dart';
import 'package:goauto/modules/orders/models/order_model.dart';
import 'package:goauto/modules/vehicles/repositories/vehicles_repository.dart';

class OrdersRepository {
  final vehiclesRepository = GetIt.I.get<VehiclesRepository>();

  Future<Map<String, dynamic>?> populateVehicle(String id) async {
    final doc = await FirebaseFirestore.instance.collection('vehicles').doc(id).get();
    final data = doc.data();
    if (data != null) {
      return {
        ...data,
        'id': id,
      };
    }
    return null;
  }

  Future<List<OrderModel>> find() async {
    final raw = await FirebaseFirestore.instance.collection('orders').get();

    return raw.docs
        .map((e) => OrderModel.fromMap({
              'id': e.id,
              ...e.data(),
            }))
        .toList();
  }

  Future<String> create(CreateOrderDTO data) async {
    final raw = await FirebaseFirestore.instance.collection('orders').add(data.toMap());
    return raw.id;
  }
}
