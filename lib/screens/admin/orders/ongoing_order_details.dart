import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/service/service_locator.dart';
import '../../../core/utils/order_helper.dart';
import '../../../providers/admin_order_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../order/cancel_order_screen.dart';
import '../../../widgets/card_info_builder.dart';
import '../../../widgets/custom_snack_bar.dart';
import '../../../widgets/order_status_timeline.dart';
import '../../../widgets/text_with_icon.dart';
import 'package:provider/provider.dart';

class OngoingOrderDetailScreen extends StatelessWidget {
  static const String routeName = "/ongoing-detail-screen";

  const OngoingOrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminOrderProvider>(
      builder: (ctx, data, child) {
        final orderId = ModalRoute.of(context)?.settings.arguments as String;
        final selectedOrder = data.getSingleOrderById(orderId);
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text('Order Details'),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: OrderHelper.getColorForOrderAction(
                          selectedOrder.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextWithIcon(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      text: OrderHelper.getStringForOrderAction(
                          selectedOrder.status),
                      icon: OrderHelper.getIconForOrder(
                          orderAction: selectedOrder.status,
                          iconColor: Colors.white),
                      mainAxisAlignment: MainAxisAlignment.center,
                      textStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Date:',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${DateFormat.yMMMEd().format(selectedOrder.dateTime)} - ${DateFormat.jm().format(selectedOrder.dateTime)}',
                          key: UniqueKey(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivery Location:',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            selectedOrder.deliveryLocation,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.black54,
                      thickness: 1.5,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (selectedOrder.orderActions != null &&
                  selectedOrder.orderActions!.isNotEmpty) ...[
                OrderStatusTimeline(
                  key: UniqueKey(),
                  orderActions: selectedOrder.orderActions!,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
              CardInfoBuilder(
                  description: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Name:',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                selectedOrder.orderUsername,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Mobile No:',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                selectedOrder.orderMobileNumber,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                  title: 'Customer Details',
                  iconType: FontAwesomeIcons.streetView),
              const SizedBox(
                height: 20,
              ),
              CardInfoBuilder(
                  description: Text(
                    selectedOrder.remarks == null ||
                            selectedOrder.remarks!.isEmpty
                        ? 'No any remarks added!'
                        : selectedOrder.remarks!,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  title: 'Remarks',
                  iconType: FontAwesomeIcons.commentDots),
              if (selectedOrder.status == 'order_cancelled') ...[
                const SizedBox(
                  height: 20,
                ),
                CardInfoBuilder(
                    description: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (selectedOrder.cancelBy == 'admin') ...[
                          const Text(
                            'Cancelled by: PetCareCommerce',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                        Text(
                          'Reason:  ${selectedOrder.cancelReason ?? 'No reason added'}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          selectedOrder.cancelDetails == null ||
                                  selectedOrder.cancelDetails == ''
                              ? 'Details:  No details added!'
                              : 'Details:  ${selectedOrder.cancelDetails}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    title: 'Cancellation Reason',
                    iconType: FontAwesomeIcons.windowClose),
              ],
              const SizedBox(
                height: 20,
              ),
              CardInfoBuilder(
                  description: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...selectedOrder.products.map((product) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    product.title,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "${product.quantity} x Rs. ${product.price}",
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          color: Colors.black38,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Rs. ${selectedOrder.amount}',
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                  title: 'Payment Info',
                  iconType: FontAwesomeIcons.moneyBill),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (selectedOrder.status != 'order_delivered' &&
                      selectedOrder.status != 'pickup_order' &&
                      selectedOrder.status != 'order_cancelled')
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          side: const BorderSide(
                            color: Colors.redAccent,
                          )),
                      child: const Text(
                        'Cancel Order',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.redAccent,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            CancelOrderScreen.routeName,
                            arguments: orderId);
                      },
                    ),
                  if (selectedOrder.status != 'order_delivered' &&
                      selectedOrder.status != 'order_cancelled' &&
                      locator<AuthProvider>().isAdmin)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 25)),
                      child: Text(
                        OrderHelper.getNextStringAction(selectedOrder.status),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      onPressed: () async {
                        try {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            // false = user must tap button, true = tap outside dialog
                            builder: (BuildContext dialogContext) {
                              return const AlertDialog(
                                title: Text('Updating Order Status'),
                                content: Text(
                                    'Please wait the status is being updated...'),
                              );
                            },
                          );
                          await data.updateOrderStatus(orderId: orderId);
                          Navigator.of(context).pop();
                        } catch (error) {
                          Navigator.of(context).pop();
                          showCustomSnackBar(
                              context: context,
                              isError: true,
                              message: "Sorry! Couldn't update the status.");
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        );
      },
    );
  }
}
