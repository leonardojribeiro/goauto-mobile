import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goauto/modules/orders/use_cases/create_order/create_order_dto.dart';
import 'package:goauto/modules/orders/models/order_model.dart';
import 'package:goauto/modules/orders/use_cases/create_order/update_order_dto.dart';

class OrdersRepository {
  final _orders = ValueNotifier<List<OrderModel>>([]);
  OrdersRepository() {
    FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots().listen((event) {
      _orders.value = event.docs
          .map((e) => OrderModel.fromMap({
                'id': e.id,
                ...e.data(),
              }))
          .toList();
    });
  }

  ValueNotifier<List<OrderModel>> docs() {
    return _orders;
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
