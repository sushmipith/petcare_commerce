import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/service/service_locator.dart';
import '../../../core/utils/order_helper.dart';
import '../../../models/order_model.dart';
import '../../../providers/auth_provider.dart';
import 'ongoing_order_details_screen.dart';
import '../../order/order_details_screen.dart';
import '../../../widgets/text_with_icon.dart';

/// Widget [OngoingOrderItem] : OngoingOrderItem used for displaying an order item from list
class OngoingOrderItem extends StatelessWidget {
  final OrderModel selectedOrder;

  const OngoingOrderItem({Key? key, required this.selectedOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(selectedOrder.id),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          Navigator.of(context).pushNamed(
            locator<AuthProvider>().isAdmin
                ? OngoingOrderDetailScreen.routeName
                : OrderDetailScreen.routeName,
            arguments: selectedOrder.id,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedOrder.orderUsername,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  TextWithIcon(
                    spacing: 10,
                    text: OrderHelper.getStringForOrderAction(
                        selectedOrder.status),
                    padding: EdgeInsets.zero,
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: OrderHelper.getColorForOrderAction(
                            selectedOrder.status)),
                    icon: OrderHelper.getIconForOrder(
                        orderAction: selectedOrder.status,
                        iconColor: OrderHelper.getColorForOrderAction(
                            selectedOrder.status)),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.jm().format(selectedOrder.dateTime),
                          key: UniqueKey(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat.yMMMEd().format(selectedOrder.dateTime),
                          key: UniqueKey(),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      selectedOrder.deliveryLocation,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              if (selectedOrder.status != 'order_cancelled') ...[
                const Divider(),
                Text(
                  'Rs. ${selectedOrder.amount}',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.black87),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
