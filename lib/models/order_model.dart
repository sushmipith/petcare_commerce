import 'package:petcare_commerce/core/utils/order_utils.dart';
import 'package:petcare_commerce/models/cart_model.dart';

class OrderModel {
  final String id;
  final double amount;
  final List<CartModel> products;
  final DateTime dateTime;
  String status;
  final String deliveryLocation;
  final String orderUsername;
  final String orderMobileNumber;
  String? cancelReason;
  String? cancelDetails;
  String? cancelBy;
  final String? remarks;
  final String? userId;
  List<OrderStatusModel>? orderActions;

  OrderModel({
    required this.id,
    required this.status,
    required this.amount,
    required this.products,
    required this.dateTime,
    required this.deliveryLocation,
    required this.orderUsername,
    required this.orderMobileNumber,
    required this.userId,
    this.orderActions,
    this.cancelBy,
    this.cancelReason,
    this.cancelDetails,
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
      cancelBy: json['cancel_by'],
      deliveryLocation: json['deliveryLocation'],
      orderMobileNumber: json['orderMobileNumber'],
      remarks: json['remarks'],
      orderActions: json['order_actions'] == null
          ? null
          : List.from((json['order_actions'] as List<dynamic>)
              .map((action) => OrderStatusModel.fromJson(action))),
      userId: json['userId'],
      cancelReason: json['cancelReason'],
      cancelDetails: json['cancelDetails'],
    );
  }
}

class OrderStatusModel {
  String? action;
  DateTime? createdAt;

  OrderStatusModel({
    required this.action,
    this.createdAt,
  });

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      action: json['action'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at']),
    );
  }
}
