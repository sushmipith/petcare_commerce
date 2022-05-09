import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  Future<void> fetchAllAndSetOrders() async {
    try {
      String? userId = locator<AuthProvider>().userId;
      final response = await httpService.get(API.orders + "$userId.json");
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderModel> _loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(OrderModel.fromJson(orderId, orderData));
      });
      _orders = _loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  //add cart to order
  Future<void> addOrder(
      {required List<CartModel> cartProducts,
      required String deliveryLocation,
      required String mobileNumber,
      String? remarks,
      required double total}) async {
    try {
      String? userId = locator<AuthProvider>().userId;
      final response = await httpService.post(API.orders + "$userId.json",
          body: json.encode({
            'amount': total,
            'userId': userId,
            'remarks': remarks ?? '',
            'dateTime': DateTime.now().toIso8601String(),
            'orderUsername': locator<AuthProvider>().currentUsername,
            'deliveryLocation': deliveryLocation,
            'orderMobileNumber': mobileNumber,
            'order_actions': [
              {
                'action': 'new_order_created',
                'created_at': DateTime.now().toIso8601String(),
              }
            ],
            'status': "new_order_created",
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
          status: "new_order_created",
          orderActions: [
            OrderStatusModel(
                action: 'new_order_created', createdAt: DateTime.now())
          ],
          products: cartProducts,
          dateTime: DateTime.now(),
          deliveryLocation: deliveryLocation,
          remarks: remarks ?? '',
          orderUsername: locator<AuthProvider>().currentUsername!,
          orderMobileNumber: mobileNumber,
          userId: userId!));
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  OrderModel getSingleOrderById(String id) {
    return _orders.firstWhere((order) => order.id == id);
  }
}
