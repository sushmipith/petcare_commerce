import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:petcare_commerce/core/network/http_service.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/core/utils/order_helper.dart';
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
        return status == 'new_order_created' ||
            status == 'ready_for_delivery' ||
            status == 'package_pickup' ||
            status == 'order_accepted' ||
            status == 'out_for_delivery' ||
            status == 'payment_completed';
      }).toList();
    } else if (status == ButtonStatus.cancelled) {
      orderList = _allOrders.where((orderItem) {
        final status = orderItem.status;
        return status == 'order_cancelled';
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

  Future<void> updateOrderStatus({required String orderId}) async {
    try {
      final index = _allOrders.indexWhere((order) => order.id == orderId);

      if (index != -1) {
        OrderModel orderModel = _allOrders[index];
        final updateIndex = OrderHelper.orderStatusList
            .indexWhere((element) => element == orderModel.status);
        print(updateIndex);
        final updateStatus = OrderHelper.orderStatusList[updateIndex + 1];
        orderModel.orderActions!.add(
            OrderStatusModel(action: updateStatus, createdAt: DateTime.now()));
        final response = await httpService.patch(
            API.orders + '${orderModel.userId}/$orderId.json',
            body: json.encode({
              'status': updateStatus,
              'order_actions': orderModel.orderActions
                  ?.map((item) => {
                        'action': item.action,
                        'created_at': item.createdAt?.toIso8601String(),
                      })
                  .toList(),
            }));
        final responseMap = json.decode(response.body) as Map<String, dynamic>;
        _allOrders[index].orderActions = orderModel.orderActions;
        _allOrders[index].status = updateStatus;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> cancelOrder(
      {required String orderId,
      required String cancelReason,
      required String cancelDetails}) async {
    try {
      final index = _allOrders.indexWhere((order) => order.id == orderId);

      if (index != -1) {
        OrderModel orderModel = _allOrders[index];
        const updateStatus = 'order_cancelled';
        orderModel.orderActions!.add(
            OrderStatusModel(action: updateStatus, createdAt: DateTime.now()));
        final response = await httpService.patch(
            API.orders + '${orderModel.userId}/$orderId.json',
            body: json.encode({
              'status': updateStatus,
              'cancel_reason': cancelReason,
              'cancel_by': 'admin',
              'cancel_details': cancelDetails,
              'order_actions': orderModel.orderActions
                  ?.map((item) => {
                        'action': item.action,
                        'created_at': item.createdAt?.toIso8601String(),
                      })
                  .toList(),
            }));
        final responseMap = json.decode(response.body) as Map<String, dynamic>;
        _allOrders[index].orderActions = orderModel.orderActions;
        _allOrders[index].status = updateStatus;
        _allOrders[index].cancelReason = cancelReason;
        _allOrders[index].cancelDetails = cancelDetails;
        _allOrders[index].cancelBy = 'admin';
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
