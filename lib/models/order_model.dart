import 'package:petcare_commerce/models/cart_model.dart';

class OrderModel {
  final String id;
  final double amount;
  final List<CartModel> products;
  final DateTime dateTime;
  final String status;

  OrderModel({
    required this.id,
    required this.status,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}
