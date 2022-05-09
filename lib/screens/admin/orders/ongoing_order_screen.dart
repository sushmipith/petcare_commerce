import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petcare_commerce/core/constants/assets_source.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/providers/admin_order_provider.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:petcare_commerce/providers/order_provider.dart';
import 'package:petcare_commerce/screens/admin/orders/ongoing_order_item.dart';
import 'package:petcare_commerce/screens/admin/orders/top_tab_widget.dart';
import 'package:petcare_commerce/screens/auth/login_screen.dart';
import 'package:petcare_commerce/screens/order/order_item_widget.dart';
import 'package:petcare_commerce/widgets/api_error_widget.dart';
import 'package:petcare_commerce/widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';

enum ButtonStatus { delivered, transit, cancelled }

extension ButtonStatusString on ButtonStatus {
  String get stringValue {
    switch (this) {
      case ButtonStatus.delivered:
        return 'Delivered';
      case ButtonStatus.transit:
        return 'Transit';
      case ButtonStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Transit';
    }
  }
}

class OngoingOrderScreen extends StatefulWidget {
  const OngoingOrderScreen({Key? key}) : super(key: key);

  @override
  _OngoingOrderScreenState createState() => _OngoingOrderScreenState();
}

class _OngoingOrderScreenState extends State<OngoingOrderScreen> {
  Future? _getData;
  ButtonStatus _currentStatus = ButtonStatus.transit;

  @override
  void initState() {
    super.initState();
    _getData = _fetchOrders();
  }

  Future _fetchOrders() async {
    try {
      await locator<AdminOrderProvider>().fetchAllOrders();
    } on HttpException catch (error) {
      showCustomSnackBar(
        isError: true,
        message: error.message,
        context: context,
      );
      await locator<AuthProvider>().logout();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    } catch (error) {
      rethrow;
    }
  }

  void _changeButtonStatus(ButtonStatus status) {
    setState(() {
      _currentStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Orders'),
              actions: [
                snapshot.connectionState == ConnectionState.waiting
                    ? const SizedBox()
                    : IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            _getData = _fetchOrders();
                          });
                        },
                      )
              ],
            ),
            body: snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : snapshot.hasError
                    ? ApiErrorWidget(tryAgain: () {
                        setState(() {
                          _getData = _fetchOrders();
                        });
                      })
                    : NestedScrollView(headerSliverBuilder: (ctx, innerBox) {
                        return [
                          SliverList(
                              delegate: SliverChildListDelegate([
                            TopTabWidget(
                              changeButtonStatus: _changeButtonStatus,
                              currentStatus: _currentStatus,
                            ),
                          ]))
                        ];
                      }, body: Consumer<AdminOrderProvider>(
                        builder: (ctx, data, child) {
                          final orderList =
                              data.getOrderListByStatus(_currentStatus);
                          return orderList.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Lottie.asset(
                                      AssetsSource.emptyOrder,
                                      fit: BoxFit.contain,
                                      height: 200,
                                      repeat: false,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      'There are no any orders\nfor this status',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          height: 1.5,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  itemBuilder: (ctx, index) {
                                    final order = orderList[index];
                                    return OngoingOrderItem(
                                      key: ValueKey(order.id),
                                      selectedOrder: order,
                                    );
                                  },
                                  itemCount: orderList.length,
                                );
                        },
                      )),
          );
        });
  }
}
