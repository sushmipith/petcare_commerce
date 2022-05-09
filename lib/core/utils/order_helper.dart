import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/constants/constants.dart';

import 'order_utils.dart';

/// Helper [OrderHelper] : OrderHelper for getting the values for the status
class OrderHelper {
  static const List<String> orderStatusList = [
    'new_order_created',
    'order_accepted',
    'ready_for_delivery',
    'package_pickup',
    'out_for_delivery',
    'payment_completed',
    'order_delivered',
  ];

  /// FUNC [getIconForOrder] : Get the Icon according to status
  static Icon getIconForOrder({required String orderAction, Color? iconColor}) {
    Color color = iconColor ?? Colors.white;
    switch (orderAction) {
      case 'processing':
      case 'new_order_created':
      case 'order_accepted':
      case 'ready_for_delivery':
      case 'package_pickup':
      case 'out_for_delivery':
      case 'payment_completed':
        return Icon(
          Icons.two_wheeler_rounded,
          color: color,
          size: 18,
        );
      case 'order_delivered':
        return Icon(
          Icons.check_box_outlined,
          color: color,
          size: 20,
        );
      case 'order_cancelled':
        return Icon(
          Icons.cancel_outlined,
          color: color,
          size: 20,
        );
      default:
        return Icon(
          Icons.check_box_outlined,
          color: color,
          size: 20,
        );
    }
  }

  /// Color [getColorForOrder] : Get the color for status
  static Color getColorForOrder(OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.ongoing:
        return accentColor;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.redAccent;
      default:
        return Colors.green;
    }
  }

  /// String [getNextStringAction] : Get the next string text for status
  static String getNextStringAction(String orderAction) {
    switch (orderAction) {
      case 'processing':
      case 'new_order_created':
        return 'Accept Order';
      case 'order_accepted':
        return 'Ready for Delivery';
      case 'ready_for_delivery':
        return 'Package Pickup';
      case 'package_pickup':
        return 'Out for Delivery';
      case 'out_for_delivery':
        return 'Payment Completed';
      case 'payment_completed':
        return 'Order Delivered';
      default:
        return 'Ongoing';
    }
  }

  /// String [getStringForOrder] : Get the string text for status
  static String getStringForOrderAction(String orderAction) {
    switch (orderAction) {
      case 'processing':
      case 'new_order_created':
        return 'New Order';
      case 'order_accepted':
        return 'Order Accepted';
      case 'ready_for_delivery':
        return 'Ready for Delivery';
      case 'package_pickup':
        return 'Package Pickup';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'order_delivered':
        return 'Order Delivered';
      case 'order_cancelled':
        return 'Order Cancelled';
      case 'payment_completed':
        return 'Payment Completed';
      default:
        return 'Ongoing';
    }
  }

  /// Color [getColorForOrder] : Get the color for status
  static Color getColorForOrderAction(String orderAction) {
    switch (orderAction) {
      case 'processing':
      case 'new_order_created':
      case 'package_pickup':
      case 'out_for_delivery':
      case 'ready_for_delivery':
      case 'order_accepted':
      case 'payment_completed':
        return accentColor;
      case 'order_delivered':
        return Colors.green;
      case 'order_cancelled':
        return Colors.redAccent;
      default:
        return Colors.green;
    }
  }
}
