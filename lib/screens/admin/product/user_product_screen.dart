import 'package:flutter/material.dart';
import 'package:petcare_commerce/providers/products_provider.dart';
import 'package:petcare_commerce/screens/admin/product/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    double mHeight = mediaConst.size.height;
    double mWidth = mediaConst.size.width;
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
                                        title: Text("Success!"),
                                        content: Text("Deleted the item!"),
                                        actions: [
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(dCtx);
                                            },
                                            color: themeConst.primaryColor,
                                            child: Text("Okay"),
                                          )
                                        ],
                                      ));
                            } catch (error) {
                              showDialog(
                                  context: context,
                                  builder: (dCtx) => AlertDialog(
                                        title: Text("Error!"),
                                        content:
                                            Text("Cannot delete the item!"),
                                        actions: [
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(dCtx);
                                            },
                                            child: Text("Okay"),
                                            color: themeConst.primaryColor,
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
