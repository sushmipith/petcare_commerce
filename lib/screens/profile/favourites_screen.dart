import 'package:flutter/material.dart';
import '../../providers/products_provider.dart';
import '../product/product_item_widget.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatelessWidget {
  static const String routeName = "/favourites_screen";

  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favourites"),
      ),
      body: Consumer<ProductsProvider>(
        builder: (ctx, data, child) {
          final loadedProducts = data.favProducts;
          return GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10),
              itemCount: loadedProducts.length,
              itemBuilder: (ctx, index) {
                return ProductItemWidget(
                  id: loadedProducts[index].id,
                );
              });
        },
      ),
    );
  }
}
