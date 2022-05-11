import 'package:flutter/material.dart';
import '../../core/constants/assets_source.dart';
import '../../core/constants/constants.dart';
import '../../core/service/service_locator.dart';
import '../../providers/products_provider.dart';
import 'product_detail_screen.dart';

/// Widget [ProductItemWidget] : ProductItemWidget display a single product item
class ProductItemWidget extends StatelessWidget {
  final String id;

  const ProductItemWidget({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double mHeight = mediaQuery.size.height;
    double mWidth = mediaQuery.size.width;
    ThemeData themeData = Theme.of(context);
    final loadedProduct = locator<ProductsProvider>().findProductById(id);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductDetailScreen.routeName,
            arguments: id);
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: mHeight * 0.15,
          width: mWidth * 0.35,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'product${loadedProduct.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    child: FadeInImage(
                      placeholder: const AssetImage(AssetsSource.placeholder),
                      fadeInCurve: Curves.bounceInOut,
                      image: NetworkImage(
                        loadedProduct.imageURL,
                      ),
                      fit: BoxFit.contain,
                      height: mHeight * 0.12,
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loadedProduct.title,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: themeData.textTheme.subtitle1?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: greyColor),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Rs. ${loadedProduct.price}",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: themeData.textTheme.subtitle1?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: blackColor),
                        ),
                      ],
                    )),
              ]),
        ),
      ),
    );
  }
}
