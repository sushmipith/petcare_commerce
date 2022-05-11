import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';

/// Widget [OrderItemWidget] : OrderItemWidget display a single order item in the list
class OrderItemWidget extends StatelessWidget {
  final OrderModel orderModel;

  const OrderItemWidget({Key? key, required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeConst = Theme.of(context);
    return Card(
      child: ExpansionTile(
          title: Text(
            "Rs. ${orderModel.amount}",
            style: themeConst.textTheme.headline6
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            DateFormat.yMMMEd().add_jm().format(orderModel.dateTime),
            style: const TextStyle(color: Colors.black87),
          ),
          leading: Icon(
              orderModel.status == "Pending"
                  ? FontAwesomeIcons.truckLoading
                  : FontAwesomeIcons.truckPickup,
              color: orderModel.status == "Pending"
                  ? Colors.orangeAccent
                  : Colors.green),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: orderModel.products.map((product) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      product.title,
                      style: themeConst.textTheme.subtitle2
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child:
                          Text("${product.quantity} x Rs. ${product.price} ")),
                ],
              ),
            );
          }).toList()),
    );
  }
}
