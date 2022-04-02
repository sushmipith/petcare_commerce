import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/theme/constants.dart';
import 'package:petcare_commerce/providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../image_preview_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product_detail_screen";
  const ProductDetailScreen({Key? key}) : super(key: key);

  Chip _sizeChips(
      {required String title,
      required Color color,
      required ThemeData themeConst}) {
    return Chip(
      label: Text(
        title,
        style: themeConst.textTheme.subtitle1
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      backgroundColor: color,
    );
  }

  Widget _detailTiles(
      {required String title,
      required String desc,
      required ThemeData themeConst}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: themeConst.textTheme.headline6
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          desc,
          style: themeConst.textTheme.subtitle2?.copyWith(color: greyColor),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final mHeight = mediaQuery.size.height;
    ThemeData themeConst = Theme.of(context);
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    final loadedProduct = provider.findProductById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
        ),
      ),
      body: ListView(
        children: [
          Hero(
            tag: "product${loadedProduct.id}",
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ImagePreviewScreen.routeName,
                    arguments: {
                      'imageTitle': loadedProduct.title,
                      'imageUrl': loadedProduct.imageURL,
                    });
              },
              child: Image.network(
                loadedProduct.imageURL,
                height: mHeight * 0.4,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              loadedProduct.title,
              style: themeConst.textTheme.headline6?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Rs. ${loadedProduct.price}",
              style: themeConst.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            contentPadding: const EdgeInsets.all(16),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: themeConst.accentColor,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                    Text(loadedProduct.rating,
                        style: themeConst.textTheme.subtitle1
                            ?.copyWith(fontSize: 16)),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Consumer<ProductsProvider>(
                  builder: (ctx, product, child) {
                    return IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        loadedProduct.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 30,
                      ),
                      color: themeConst.primaryColor,
                      onPressed: () async {
                        try {
                          await provider.toggleFavourite(id);
                        } catch (error) {
                          print(error);
                        }
                      },
                    );
                  },
                )
              ],
            ),
          ),
          loadedProduct.category == "Electronics"
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 0, bottom: 10),
                  child: Text(
                    "Size",
                    style: themeConst.textTheme.headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
          loadedProduct.category == "Electronics"
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _sizeChips(
                      title: "S",
                      color: Colors.orange.shade200,
                      themeConst: themeConst,
                    ),
                    _sizeChips(
                      title: "M",
                      color: Colors.pink.shade200,
                      themeConst: themeConst,
                    ),
                    _sizeChips(
                      title: "L",
                      color: Colors.lightBlue.shade200,
                      themeConst: themeConst,
                    ),
                    _sizeChips(
                      title: "XL",
                      color: Colors.green.shade200,
                      themeConst: themeConst,
                    ),
                  ],
                ),
          const SizedBox(
            width: 30,
          ),
          _detailTiles(
            title: "Description",
            desc: loadedProduct.description,
            themeConst: themeConst,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16, top: 10, bottom: 10),
            child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: Colors.lightGreen,
                textColor: Colors.white,
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Add to Cart")),
          )
        ],
      ),
    );
  }
}
