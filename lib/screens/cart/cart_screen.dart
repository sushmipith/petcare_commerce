import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../providers/cart_provider.dart';
import 'cart_item_widget.dart';
import 'checkout_dialog.dart';
import '../../widgets/empty_order_widget.dart';
import 'package:provider/provider.dart';

/// Screen [CartScreen] : CartScreen shows all the items that are added to cart
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ThemeData? themeConst;
  double? mHeight, mWidth;

  @override
  Widget build(BuildContext context) {
    themeConst = Theme.of(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    mHeight = mediaQueryData.size.height;
    mWidth = mediaQueryData.size.width;
    return Consumer<CartProvider>(builder: (ctx, data, child) {
      final cartMap = data.items;
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          scrollDirection: Axis.vertical,
          child: data.totalCount == 0
              ? const EmptyOrder(
                  type: "Cart",
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: mHeight! * 0.68,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                        ),
                        itemBuilder: (context, i) => CartItemWidget(
                          cartId: cartMap.keys.toList()[i],
                          id: cartMap.values.toList()[i].id,
                          title: cartMap.values.toList()[i].title,
                          quantity: cartMap.values.toList()[i].quantity,
                        ),
                        itemCount: data.totalCount,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: accentColor.withOpacity(0.1),
                        border: Border.all(
                            color: themeConst!.primaryColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Text("Total:",
                                    style: themeConst?.textTheme.subtitle1
                                        ?.copyWith(
                                            fontSize: 15, color: greyColor)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text("Rs. ${data.totalAmount}",
                                    style: themeConst?.textTheme.headline5
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // false = user must tap button, true = tap outside dialog
                                  builder: (BuildContext dialogContext) {
                                    return CheckoutDialog(cartMap: cartMap);
                                  },
                                );
                              },
                              child: const Text(
                                "Checkout",
                              ),
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                primary: themeConst?.primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ),
      );
    });
  }
}
