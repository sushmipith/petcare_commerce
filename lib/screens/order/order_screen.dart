import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/providers/order_provider.dart';
import 'package:petcare_commerce/screens/admin/orders/ongoing_order_item.dart';
import 'package:petcare_commerce/widgets/empty_order_widget.dart';
import 'package:provider/provider.dart';

import 'order_item_widget.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = "/order_screen";

  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  Future? _fetchAllOrders;

  @override
  void initState() {
    super.initState();
    _fetchAllOrders = locator<OrderProvider>().fetchAllAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: FutureBuilder(
        future: _fetchAllOrders,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : snapshot.hasError
                  ? const Center(
                      child: Text("Something went wrong!"),
                    )
                  : Consumer<OrderProvider>(
                      builder: (ctx, data, child) {
                        final orders = data.orders;
                        return orders.isEmpty
                            ? EmptyOrder(type: "Order")
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                itemBuilder: (context, index) {
                                  final order = data.orders[index];
                                  return OngoingOrderItem(
                                    key: ValueKey(order.id),
                                    selectedOrder: order,
                                  );
                                },
                                itemCount: orders.length,
                              );
                      },
                    );
        },
      ),
    );
  }
}
