import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/constants/assets_source.dart';

/// Widget [EmptyOrder] : EmptyOrder for showing empty order or cart
class EmptyOrder extends StatelessWidget {
  final String type;

  const EmptyOrder({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 75),
      child: Center(
        child: Column(
          children: [
            Lottie.asset(
              type == "Cart" ? AssetsSource.emptyBox : AssetsSource.emptyOrder,
              fit: BoxFit.contain,
              repeat: false,
            ),
            Text(
              type == "Cart"
                  ? "You don't have any items in cart. Please add now!"
                  : "You haven't ordered anything. Start ordering now!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
    );
  }
}
