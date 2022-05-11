import 'package:flutter/material.dart';
import '../../../providers/products_provider.dart';
import 'edit_product_screen.dart';
import 'package:provider/provider.dart';

/// Screen [UserProductScreen] : UserProductScreen for viewing all products to add/edit or delete
class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeConst = Theme.of(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final userProducts = productsProvider.products;
    return Consumer<ProductsProvider>(
      builder: (ctx, data, child) {
        return userProducts.isEmpty
            ? Center(
                child: Text(
                "Please add your own products",
                textAlign: TextAlign.center,
                style: themeConst.textTheme.headline6,
              ))
            : ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                itemBuilder: (ctx, index) => ListTile(
                  leading: Image.network(userProducts[index].imageURL),
                  title: Text(userProducts[index].title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon:
                              Icon(Icons.edit, color: themeConst.primaryColor),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, EditProductScreen.routeName,
                                arguments: userProducts[index].id);
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: themeConst.errorColor,
                          ),
                          onPressed: () async {
                            try {
                              await productsProvider
                                  .deleteProduct(userProducts[index].id);
                              showDialog(
                                  context: context,
                                  builder: (dCtx) => AlertDialog(
                                        title: const Text("Success!"),
                                        content:
                                            const Text("Deleted the item!"),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(dCtx);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: themeConst.primaryColor,
                                            ),
                                            child: const Text("Okay"),
                                          )
                                        ],
                                      ));
                            } catch (error) {
                              showDialog(
                                  context: context,
                                  builder: (dCtx) => AlertDialog(
                                        title: const Text("Error!"),
                                        content: const Text(
                                            "Cannot delete the item!"),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(dCtx);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: themeConst.primaryColor,
                                            ),
                                            child: const Text("Okay"),
                                          )
                                        ],
                                      ));
                            }
                          }),
                    ],
                  ),
                ),
                itemCount: userProducts.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              );
      },
    );
  }
}
