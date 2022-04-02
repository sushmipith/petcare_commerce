import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/constants/constants.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/models/product_model.dart';
import 'package:petcare_commerce/providers/products_provider.dart';
import 'package:petcare_commerce/screens/product/product_item.dart';

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
        actions: [
          IconButton(
              icon: const Icon(
                Icons.search,
                color: blackColor,
              ),
              onPressed: () {})
        ],
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
            return ProductItem(
              id: loadedProducts[index].id,
            );
          }),
    );
  }
}
