import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:petcare_commerce/core/network/http_service.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/models/cart_model.dart';
import 'package:petcare_commerce/models/order_model.dart';
import 'package:petcare_commerce/core/network/API.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';

class OrderProvider with ChangeNotifier {
  final HttpService httpService = locator<HttpService>();

  List<OrderModel> _orders = [];

  List<OrderModel> get orders {
    return [..._orders];
  }

  //fetch all orders
  Future<List<OrderModel>> fetchAllAndSetOrders() async {
    try {
      String? userId = locator<AuthProvider>().userId;
      final response = await httpService.get(API.orders + "$userId.json");
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return [];
      }
      final List<OrderModel> _loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(
          OrderModel(
            id: orderId,
            status: orderData['status'],
            amount: double.parse(orderData['amount'].toString()),
            products: (orderData['products'] as List<dynamic>)
                .map((cartItem) => CartModel(
                    id: cartItem['id'],
                    title: cartItem['title'],
                    price: cartItem['price'],
                    quantity: cartItem['quantity']))
                .toList(),
            dateTime: DateTime.parse(
              orderData['dateTime'],
            ),
          ),
        );
      });
      _orders = _loadedOrders.reversed.toList();
      return _orders;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  //add cart to order
  Future<void> addOrder(List<CartModel> cartProducts, double total) async {
    try {
      String? userId = locator<AuthProvider>().userId;
      final response = await httpService.post(API.orders + "$userId.json",
          body: json.encode({
            'amount': total,
            'dateTime': DateTime.now().toIso8601String(),
            'status': "Pending",
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'quantity': cp.quantity,
                      'price': cp.price,
                      'title': cp.title,
                    })
                .toList()
          }));
      final id = json.decode(response.body);
      _orders.add(OrderModel(
          id: id['name'],
          amount: total,
          status: "Pending",
          products: cartProducts,
          dateTime: DateTime.now()));
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
