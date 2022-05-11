import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/network/http_service.dart';
import '../core/service/service_locator.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../core/network/api.dart';
import 'auth_provider.dart';

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
            'remarks': remarks,
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
      rethrow;
    }
  }

  OrderModel getSingleOrderById(String id) {
    return _orders.firstWhere((order) => order.id == id);
  }

  Future<void> cancelOrder(
      {required String orderId,
      required String cancelReason,
      required String cancelDetails}) async {
    try {
      final index = _orders.indexWhere((order) => order.id == orderId);

      if (index != -1) {
        OrderModel orderModel = _orders[index];
        const updateStatus = 'order_cancelled';
        orderModel.orderActions!.add(
            OrderStatusModel(action: updateStatus, createdAt: DateTime.now()));
        await httpService.patch(
            API.orders + '${orderModel.userId}/$orderId.json',
            body: json.encode({
              'status': updateStatus,
              'cancel_reason': cancelReason,
              'cancel_details': cancelDetails,
              'order_actions': orderModel.orderActions
                  ?.map((item) => {
                        'action': item.action,
                        'created_at': item.createdAt?.toIso8601String(),
                      })
                  .toList(),
            }));
        _orders[index].orderActions = orderModel.orderActions;
        _orders[index].status = updateStatus;
        _orders[index].cancelReason = cancelReason;
        _orders[index].cancelDetails = cancelDetails;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
