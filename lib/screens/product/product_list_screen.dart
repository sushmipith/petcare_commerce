import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/theme/constants.dart';
import 'package:petcare_commerce/providers/products_provider.dart';
import 'package:petcare_commerce/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  static const String routeName = "/product_list_screen";

  @override
  Widget build(BuildContext context) {
    final themeConst = Theme.of(context);
    final Map<String, dynamic> mapArgument =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final productsProvider = Provider.of<Products>(context, listen: false);
    var loadedProducts;
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
              icon: Icon(
                Icons.search,
                color: blackColor,
              ),
              onPressed: () {})
        ],
      ),
      body: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
