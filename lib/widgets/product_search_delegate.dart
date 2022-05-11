import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/constants/assets_source.dart';
import '../core/service/service_locator.dart';
import '../providers/products_provider.dart';
import '../screens/product/product_item_widget.dart';

/// Widget [ProductSearchDelegate] : ProductSearchDelegate for handling search feature for product
class ProductSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchItems = locator<ProductsProvider>().getSearchItems(query);
    return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10),
        itemCount: searchItems.length,
        itemBuilder: (ctx, index) {
          return ProductItemWidget(
            id: searchItems[index].id,
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchItems = locator<ProductsProvider>().getSearchItems(query);
    return query.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetsSource.appLogo,
                height: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Search product items")
            ],
          )
        : GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10),
            itemCount: searchItems.length,
            itemBuilder: (ctx, index) {
              return ProductItemWidget(
                id: searchItems[index].id,
              );
            });
  }
}
