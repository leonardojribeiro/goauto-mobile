import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/orders/models/order_model.dart';
import 'package:goauto/modules/orders/repositories/orders_repository.dart';
import 'package:goauto/modules/orders/widgets/form_order_widget.dart';

class ListOrdersWidget extends StatefulWidget {
  const ListOrdersWidget({Key? key}) : super(key: key);

  @override
  State<ListOrdersWidget> createState() => _ListOrdersWidgetState();
}

class _ListOrdersWidgetState extends State<ListOrdersWidget> {
  final ordersNotifier = ValueNotifier<List<OrderModel>>([]);

  Future<void> findOrders() async {
    ordersNotifier.value = await GetIt.I.get<OrdersRepository>().find();
  }

  @override
  void initState() {
    findOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordens de serviço'),
      ),
      body: ValueListenableBuilder<List<OrderModel>>(
        valueListenable: ordersNotifier,
        builder: (context, value, child) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final order = value[index];
              final createdAt = order.createdAt != null ? MaterialLocalizations.of(context).formatCompactDate(order.createdAt ?? DateTime.now()) : '';
              return ListTile(
                title: Text(order.vehicle?.licensePlate?.toUpperCase() ?? ''),
                subtitle: Text(createdAt),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FormOrderWidget(
                        order: order,
                      ),
                    ),
                  );
                },
              );
            },
            itemCount: value.length,
          );
        },
      ),
    );
  }
}
