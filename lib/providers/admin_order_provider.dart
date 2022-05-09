import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:petcare_commerce/core/network/http_service.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/models/cart_model.dart';
import 'package:petcare_commerce/models/order_model.dart';
import 'package:petcare_commerce/core/network/API.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:petcare_commerce/screens/admin/orders/ongoing_order_screen.dart';

class AdminOrderProvider with ChangeNotifier {
  final HttpService httpService = locator<HttpService>();

  List<OrderModel> _allOrders = [];

  List<OrderModel> get allOrders {
    return [..._allOrders];
  }

  //fetch all orders
  Future<void> fetchAllOrders() async {
    try {
      final response = await httpService.get(API.orders + '.json');
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      _allOrders.clear();
      for (var userItem in extractedData.values) {
        final userOrderMap = userItem as Map<String, dynamic>;
        userOrderMap.forEach((orderId, orderData) {
          _allOrders.add(OrderModel.fromJson(orderId, orderData));
        });
      }
      _allOrders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  List<OrderModel> getOrderListByStatus(ButtonStatus status) {
    List<OrderModel> orderList = [];
    if (status == ButtonStatus.transit) {
      orderList = _allOrders.where((orderItem) {
        final status = orderItem.status;
        return status == 'processing' ||
            status == 'new_order_created' ||
            status == 'pickup_rider_assigned' ||
            status == 'dispatch_rider_assigned' ||
            status == 'order_accepted' ||
            status == 'pick_up_reached' ||
            status == 'trip_started' ||
            status == 'reached_collection_station' ||
            status == 'dispatched_from_station' ||
            status == 'payment_completed' ||
            status == 'drop_off_reached';
      }).toList();
    } else if (status == ButtonStatus.cancelled) {
      orderList = _allOrders.where((orderItem) {
        final status = orderItem.status;
        return status == 'order_canceled';
      }).toList();
    } else if (status == ButtonStatus.delivered) {
      orderList = _allOrders.where((orderItem) {
        final status = orderItem.status;
        return status == 'order_delivered';
      }).toList();
    }
    return orderList;
  }

  OrderModel getSingleOrderById(String id) {
    return _allOrders.firstWhere((order) => order.id == id);
  }
}
