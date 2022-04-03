import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/constants/constants.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/providers/cart_provider.dart';
import 'package:petcare_commerce/providers/order_provider.dart';
import 'package:petcare_commerce/screens/cart/cart_item_widget.dart';
import 'package:petcare_commerce/widgets/custom_snack_bar.dart';
import 'package:petcare_commerce/widgets/empty_order_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ThemeData? themeConst;
  double? mHeight, mWidth;
  bool _isLoading = false;

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
              ? EmptyOrder(
                  type: "Cart",
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                            child: RaisedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      try {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        await locator<OrderProvider>().addOrder(
                                            cartMap.values.toList(),
                                            data.totalAmount);
                                        showCustomSnackBar(
                                          isError: false,
                                          message:
                                              'Success! Your items have been ordered! Add new items to the cart ',
                                          context: context,
                                        );
                                        data.clearCart();
                                      } catch (error) {
                                        showCustomSnackBar(
                                          isError: true,
                                          message:
                                              'Something went wrong! Couldn\'t order your items',
                                          context: context,
                                        );
                                      } finally {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : const Text(
                                      "Checkout",
                                    ),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: themeConst?.primaryColor,
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
