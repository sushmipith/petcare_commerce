import 'package:flutter/material.dart';
import '../../core/service/service_locator.dart';
import '../../models/product_model.dart';
import '../../providers/products_provider.dart';
import 'product_item_widget.dart';

/// Screen [ProductListScreen] : ProductListScreen display list of products in the screen
class ProductListScreen extends StatelessWidget {
  static const String routeName = "/product_list_screen";

  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> mapArgument =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final productsProvider = locator<ProductsProvider>();
    List<ProductModel> loadedProducts;
    if (mapArgument['diff'] == "category") {
      loadedProducts = productsProvider.getCategoryProduct(mapArgument['type']);
    } else {
      loadedProducts = mapArgument['type'] == "Flash Sale"
          ? productsProvider.flashSaleProducts
          : productsProvider.newProducts;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mapArgument['type'],
        ),
      ),
      body: GridView.builder(
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
          }),
    );
  }
}
