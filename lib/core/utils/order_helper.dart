import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/constants/constants.dart';

import 'order_utils.dart';

/// Helper [OrderHelper] : OrderHelper for getting the values for the status
class OrderHelper {
  /// FUNC [getIconForOrder] : Get the Icon according to status
  static Icon getIconForOrder({required String orderAction, Color? iconColor}) {
    Color color = iconColor ?? Colors.white;
    switch (orderAction) {
      case 'processing':
      case 'new_order_created':
      case 'pickup_rider_assigned':
      case 'order_accepted':
      case 'trip_started':
      case 'pick_up_reached':
      case 'reached_collection_station':
      case 'dispatched_from_station':
      case 'drop_off_reached':
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
      case 'order_canceled':
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

  /// String [getStringForOrder] : Get the string text for status
  static String getStringForOrderAction(String orderAction) {
    switch (orderAction) {
      case 'processing':
      case 'new_order_created':
        return 'Order Accepted';
      case 'pickup_rider_assigned':
      case 'order_accepted':
        return 'Rider Assigned';
      case 'trip_started':
        return 'Trip Started';
      case 'pick_up_reached':
        return 'Pickup Reached';
      case 'dispatch_rider_assigned':
        return 'Dispatched From Station';
      case 'reached_collection_station':
        return 'Reached Collection Station';
      case 'dispatched_from_station':
        return 'Dispatched From Station';
      case 'drop_off_reached':
        return 'Drop Off Reached';
      case 'order_delivered':
        return 'Order Delivered';
      case 'order_canceled':
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
      case 'pickup_rider_assigned':
      case 'order_accepted':
      case 'pick_up_reached':
      case 'trip_started':
      case 'reached_collection_station':
      case 'dispatched_from_station':
      case 'dispatch_rider_assigned':
      case 'drop_off_reached':
      case 'payment_completed':
        return accentColor;
      case 'order_delivered':
        return Colors.green;
      case 'order_canceled':
        return Colors.redAccent;
      default:
        return Colors.green;
    }
  }
}
