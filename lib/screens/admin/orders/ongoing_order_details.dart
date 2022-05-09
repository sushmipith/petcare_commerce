import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:petcare_commerce/core/constants/assets_source.dart';
import 'package:petcare_commerce/core/utils/order_helper.dart';
import 'package:petcare_commerce/providers/admin_order_provider.dart';
import 'package:petcare_commerce/widgets/card_info_builder.dart';
import 'package:petcare_commerce/widgets/text_with_icon.dart';
import 'package:provider/provider.dart';

class OngoingOrderDetailScreen extends StatelessWidget {
  static const String routeName = "/ongoing-detail-screen";

  const OngoingOrderDetailScreen({Key? key}) : super(key: key);

  // =========================== Build Function ===========================
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
              actions: [],
            ),
            body: ListView(
              children: [
                const SizedBox(
                  height: 20,
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
                            horizontal: 20, vertical: 10),
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
                  height: 40,
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
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.black45,
                    thickness: 1.2,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // if (selectedOrder.orderActions != null &&
                //     selectedOrder.orderActions.isNotEmpty) ...[
                //   OrderStatusTimeline(
                //       key: UniqueKey(),
                //       orderActions: selectedOrder.orderActions ?? [],
                //       isInstant: selectedOrder.isInstant),
                //   SizedBox(
                //     height: 20,
                //   ),
                // ],
                const SizedBox(
                  height: 20,
                ),
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
                            height: 20,
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
                          const SizedBox(
                            height: 20,
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
                // if (selectedOrder.status == 'order_cancelled') ...[
                //   SizedBox(
                //     height: 20,
                //   ),
                //   CardInfoBuilder(
                //       description: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Reason:  ${selectedOrder?.cancelReason ?? 'No reason added'}',
                //             style: const TextStyle(
                //               color: Colors.black87,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //           SizedBox(
                //             height: 20,
                //           ),
                //           Text(
                //             selectedOrder?.refundModel?.cancelDetails == null ||
                //                     selectedOrder?.refundModel?.cancelDetails ==
                //                         ''
                //                 ? 'Details:  No details added!'
                //                 : 'Details:  ${selectedOrder.refundModel.cancelDetails}',
                //             style: const TextStyle(
                //               color: Colors.black87,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ],
                //       ),
                //       title: 'Cancellation Reason',
                //       iconType: FontAwesomeIcons.windowClose),
                // ],
                const SizedBox(
                  height: 20,
                ),
                CardInfoBuilder(
                    description: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Payment Method:',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // Image.asset(
                              //   selectedOrder.paymentMethod.toLowerCase() ==
                              //           'cash'
                              //       ? AssetsSource.iconRuppees
                              //       : AssetsSource.esewaLogo,
                              //   height: 50,
                              // ),
                            ],
                          ),
                        ]),
                    title: 'Payment Info',
                    iconType: FontAwesomeIcons.moneyBill),
                const SizedBox(
                  height: 40,
                ),

                // if (selectedOrder.orderStatus != 'trip_completed' &&
                //     selectedOrder.orderStatus != 'order_canceled')
                //   OutlinedButton(
                //     style: OutlinedButton.styleFrom(
                //         padding: EdgeInsets.symmetric(horizontal: 50.w),
                //         shape: const StadiumBorder(),
                //         side: const BorderSide(
                //           color: BujauUserTheme.redColor,
                //         )),
                //     child: Text(
                //       'Cancel Order',
                //       style: TextStyle(
                //         fontSize: 32.sp,
                //         color: BujauUserTheme.redColor,
                //       ),
                //     ),
                //     onPressed: () {
                //       locator<NavigationService>().navigateTo(
                //           routes.CancelBookingScreenRoute,
                //           arguments: orderId);
                //     },
                //   )
                //],
                //),
                const SizedBox(
                  height: 40,
                ),
              ],
            ));
      },
    );
  }
}
