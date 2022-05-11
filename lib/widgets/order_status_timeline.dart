import 'package:flutter/material.dart';
import '../core/constants/constants.dart';
import '../core/utils/order_helper.dart';
import '../models/order_model.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class OrderStatusTimeline extends StatelessWidget {
  final List<OrderStatusModel> orderActions;

  const OrderStatusTimeline({
    Key? key,
    required this.orderActions,
  }) : super(key: key);

  Widget _buildTimelineWidget(
      {required String title,
      required String dateTime,
      bool isFirst = false,
      bool isCompleted = false,
      bool isLast = false}) {
    return TimelineTile(
      key: UniqueKey(),
      alignment: TimelineAlign.manual,
      lineXY: 0.43,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 60,
        color: primaryColor,
        drawGap: true,
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
        indicator: Icon(
          title == 'Order Cancelled'
              ? Icons.cancel
              : Icons.check_circle_rounded,
          color: title == 'Order Cancelled' ? Colors.redAccent : primaryColor,
          size: 30,
        ),
      ),
      beforeLineStyle: LineStyle(
        color: title == 'Order Cancelled' ? Colors.redAccent : primaryColor,
        thickness: 3,
      ),
      afterLineStyle: LineStyle(
        color: title == 'Order Cancelled' ? Colors.redAccent : primaryColor,
        thickness: 3,
      ),
      startChild: Container(
        constraints: const BoxConstraints(
          minHeight: 60,
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          dateTime,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 13, color: Colors.black87),
        ),
      ),
      endChild: Container(
        constraints: const BoxConstraints(
          minHeight: 60,
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildListForTimeline() {
    List<Widget> _buildTimeline = [];
    orderActions.map((orderAction) {
      final index = orderActions
          .indexWhere((item) => item.createdAt == orderAction.createdAt);
      String title = OrderHelper.getStringForOrderAction(orderAction.action!);
      _buildTimeline.add(_buildTimelineWidget(
        title: title,
        isFirst: orderAction.action == 'new_order_created',
        isLast: orderAction.action == 'trip_completed' ||
            index == orderActions.length - 1,
        isCompleted: true,
        dateTime: DateFormat()
            .add_yMMMMEEEEd()
            .add_jm()
            .format(orderAction.createdAt!),
      ));
    }).toList();
    return Column(children: _buildTimeline);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildListForTimeline(),
        ],
      ),
    );
  }
}
