import 'package:petcare_commerce/models/cart_model.dart';

class OrderModel {
  final String id;
  final double amount;
  final double? cancelCharge;
  final List<CartModel> products;
  final DateTime dateTime;
  final String status;
  final String deliveryLocation;
  final String orderUsername;
  final String orderMobileNumber;
  final String paymentMethod;
  final String? cancelReason;
  final String? remarks;

  OrderModel({
    required this.id,
    required this.status,
    required this.amount,
    required this.products,
    required this.dateTime,
    required this.deliveryLocation,
    this.cancelCharge,
    required this.orderUsername,
    required this.orderMobileNumber,
    required this.paymentMethod,
    this.cancelReason,
    this.remarks,
  });

  factory OrderModel.fromJson(String orderId, Map<String, dynamic> json) {
    return OrderModel(
        id: orderId,
        status: json['status'],
        amount: double.parse(json['amount'].toString()),
        products: (json['products'] as List<dynamic>)
            .map((cartItem) => CartModel(
                id: cartItem['id'],
                title: cartItem['title'],
                price: cartItem['price'],
                quantity: cartItem['quantity']))
            .toList(),
        dateTime: DateTime.parse(
          json['dateTime'],
        ),
        orderUsername: json['orderUsername'],
        deliveryLocation: json['deliveryLocation'],
        orderMobileNumber: json['orderMobileNumber'],
        paymentMethod: json['paymentMethod'],
        remarks: json['remarks']);
  }
}
