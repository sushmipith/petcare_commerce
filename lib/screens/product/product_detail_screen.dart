import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/constants/assets_source.dart';
import '../../core/constants/constants.dart';
import '../../core/service/service_locator.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';

import '../image_preview_screen.dart';

/// Screen [ProductDetailScreen] : ProductDetailScreen display full details of a product
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
          style: themeConst.textTheme.subtitle2
              ?.copyWith(color: greyColor, wordSpacing: 1.5, height: 1.5),
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
    final productProvider = locator<ProductsProvider>();
    final loadedProduct = productProvider.findProductById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
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
                      color: themeConst.colorScheme.secondary,
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
                          await productProvider.toggleFavourite(id);
                        } catch (error) {
                          rethrow;
                        }
                      },
                    );
                  },
                )
              ],
            ),
          ),
          loadedProduct.category != "Toys"
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
          loadedProduct.category != "Toys"
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
          SizedBox(
            height: loadedProduct.category != "Toys" ? 0 : 30,
          ),
          _detailTiles(
            title: "Description",
            desc: loadedProduct.description,
            themeConst: themeConst,
          ),
          const SizedBox(
            height: 20,
          ),
          if (loadedProduct.reviews != null &&
              loadedProduct.reviews!.isNotEmpty)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rating and Reviews',
                        style: themeConst.textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ...loadedProduct.reviews!
                          .map((review) => Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(review.userName),
                                          RatingBarIndicator(
                                            rating: double.parse(
                                                loadedProduct.rating),
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            direction: Axis.horizontal,
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Text(review.review),
                                    leading: const CircleAvatar(
                                      backgroundImage:
                                          AssetImage(AssetsSource.userAvatar),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ))
                          .toList()
                    ])),
        ],
      ),
      floatingActionButton: locator<AuthProvider>().isAdmin
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    primary: Colors.lightGreen,
                  ),
                  onPressed: () {
                    locator<CartProvider>().addToCart(
                        id, loadedProduct.title, loadedProduct.price);
                    showCustomSnackBar(
                        context: context,
                        message: 'Added item to the cart',
                        action: SnackBarAction(
                          label: "UNDO",
                          textColor: Colors.white,
                          onPressed: () {
                            locator<CartProvider>().removeSingleItem(id);
                          },
                        ));
                  },
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  label: const Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
