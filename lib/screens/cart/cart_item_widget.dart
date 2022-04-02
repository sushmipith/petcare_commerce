import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/constants/constants.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/providers/cart_provider.dart';
import 'package:petcare_commerce/providers/products_provider.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final String cartId;

  const CartItemWidget(
      {Key? key,
      required this.id,
      required this.title,
      required this.quantity,
      required this.cartId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeConst = Theme.of(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double mHeight = mediaQueryData.size.height;
    double mWidth = mediaQueryData.size.width;
    final loadedProduct = locator<ProductsProvider>().findProductById(cartId);
    final cartProvider = locator<CartProvider>();
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        cartProvider.removeItem(cartId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (dCtx) => AlertDialog(
                  title: const Text("Are you sure?"),
                  content:
                      const Text("Do you want remove this item from cart?"),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(dCtx, false);
                      },
                      child: const Text("No"),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(dCtx, true);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ));
      },
      child: SizedBox(
        height: mHeight * 0.17,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12)),
                  child: Image.network(
                    loadedProduct.imageURL,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: themeConst.textTheme.subtitle1
                            ?.copyWith(fontSize: 18)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("Rs. ${loadedProduct.price * quantity}",
                        style: themeConst.textTheme.subtitle2?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.minimize,
                        color: themeConst.primaryColor,
                      ),
                      onPressed: () {
                        cartProvider.removeSingleItem(cartId);
                      }),
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: greyColor)),
                      child: Text("$quantity")),
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.add,
                        color: themeConst.primaryColor,
                      ),
                      onPressed: () {
                        cartProvider.addToCart(
                            cartId, title, loadedProduct.price * quantity);
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
