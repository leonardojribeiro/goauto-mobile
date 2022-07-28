import 'package:flutter/material.dart';
import 'package:goauto/modules/orders/use_cases/create_order/create_order_widget.dart';
import 'package:goauto/modules/orders/use_cases/list_orders/list_orders_widget.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de ordens de serviço'),
      ),
      body: const ListOrdersWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateOrderWidget(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
