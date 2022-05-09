import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/constants/constants.dart';
import 'package:petcare_commerce/core/utils/order_utils.dart';

import 'ongoing_order_screen.dart';

class TopTabWidget extends StatelessWidget {
  final Function(ButtonStatus status) changeButtonStatus;
  final ButtonStatus currentStatus;

  const TopTabWidget(
      {Key? key, required this.changeButtonStatus, required this.currentStatus})
      : super(key: key);

  Color _getSelectedContainerColor(ButtonStatus status) {
    return currentStatus == status
        ? _getColorForStatus(status)
        : Colors.grey.shade200;
  }

  Color _getSelectedTextColor(ButtonStatus status) {
    return currentStatus == status ? Colors.white : Colors.black38;
  }

  Color _getColorForStatus(ButtonStatus status) {
    switch (status) {
      case ButtonStatus.delivered:
        return Colors.green;
      case ButtonStatus.transit:
        return accentColor;
      case ButtonStatus.cancelled:
        return Colors.redAccent;
      default:
        return primaryColor;
    }
  }

  OrderStatus _getStatusForButton() {
    switch (currentStatus) {
      case ButtonStatus.delivered:
        return OrderStatus.delivered;
      case ButtonStatus.transit:
        return OrderStatus.ongoing;
      case ButtonStatus.cancelled:
        return OrderStatus.cancelled;
      default:
        return OrderStatus.ongoing;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              changeButtonStatus(ButtonStatus.transit);
            },
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _getSelectedContainerColor(ButtonStatus.transit)),
                child: Center(
                    child: Text(
                  'Transit',
                  style: TextStyle(
                      fontSize: 16,
                      color: _getSelectedTextColor(ButtonStatus.transit),
                      fontWeight: FontWeight.w600),
                ))),
          ),
          InkWell(
            onTap: () {
              changeButtonStatus(ButtonStatus.delivered);
            },
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _getSelectedContainerColor(ButtonStatus.delivered)),
                child: Center(
                    child: Text(
                  'Delivered',
                  style: TextStyle(
                      fontSize: 16,
                      color: _getSelectedTextColor(ButtonStatus.delivered),
                      fontWeight: FontWeight.w600),
                ))),
          ),
          InkWell(
            onTap: () {
              changeButtonStatus(ButtonStatus.cancelled);
            },
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _getSelectedContainerColor(ButtonStatus.cancelled)),
                child: Center(
                    child: Text(
                  'Cancelled',
                  style: TextStyle(
                      fontSize: 16,
                      color: _getSelectedTextColor(ButtonStatus.cancelled),
                      fontWeight: FontWeight.w600),
                ))),
          ),
        ],
      ),
    );
  }
}
