import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:goauto/modules/orders/models/order_model.dart';
import 'package:goauto/modules/orders/repositories/orders_repository.dart';
import 'package:goauto/modules/orders/widgets/form_order_widget.dart';
import 'package:intl/intl.dart';

class ListOrdersWidget extends StatefulWidget {
  const ListOrdersWidget({Key? key}) : super(key: key);

  @override
  State<ListOrdersWidget> createState() => _ListOrdersWidgetState();
}

class _ListOrdersWidgetState extends State<ListOrdersWidget> {
  final repository = GetIt.I.get<OrdersRepository>();
  final formatter = NumberFormat('#,##0.00', 'pt_BR');
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<OrderModel>>(
      valueListenable: repository.docs(),
      builder: (context, orders, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(labelText: 'Pesquisar', suffixIcon: Icon(Icons.search)),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: searchController,
                builder: (context, state, child) {
                  final filteredOrders = orders.where(
                    (order) {
                      final vehicle = order.vehicle;
                      return vehicle?.licensePlate?.toLowerCase().contains(state.text.toLowerCase()) == true || vehicle?.client?.name?.toLowerCase().contains(state.text.toLowerCase()) == true;
                    },
                  ).toList();
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final createdAt = order.createdAt != null ? MaterialLocalizations.of(context).formatCompactDate(order.createdAt ?? DateTime.now()) : '';
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${order.vehicle?.description ?? 'N??o informado'} - ${order.vehicle?.licensePlate?.toUpperCase() ?? ''}'),
                            Text(createdAt),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order.vehicle?.client?.name ?? ''),
                            Text('R\$ ${formatter.format(order.totalPrice ?? 0)}'),
                          ],
                        ),
                        dense: true,
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
                    itemCount: filteredOrders.length,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
