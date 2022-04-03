import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petcare_commerce/providers/products_provider.dart';
import 'package:petcare_commerce/screens/product/product_list_screen.dart';
import 'package:petcare_commerce/screens/home/home_carousel_widget.dart';
import 'package:petcare_commerce/screens/product/product_item_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _getCategoryItems(
      {required String title,
      required IconData icon,
      required Function onPress,
      required double mHeight,
      required double mWidth,
      required Color color}) {
    return InkWell(
      onTap: () => onPress(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: mHeight * 0.07,
              width: mWidth * 0.15,
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 10, top: 10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [color.withOpacity(0.7), color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              )),
          SizedBox(
            height: mHeight * 0.01,
          ),
          Text(title)
        ],
      ),
    );
  }

  Widget _getTitleWidget({
    required String title,
    required void Function() onPress,
    required double mHeight,
    required double mWidth,
    required ThemeData themeConst,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: themeConst.textTheme.headline5
                ?.copyWith(fontWeight: FontWeight.w600)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: onPress,
                child: const Text("All", style: TextStyle(fontSize: 15))),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    double mHeight = mediaConst.size.height;
    double mWidth = mediaConst.size.width;
    ThemeData themeConst = Theme.of(context);

    return Consumer<ProductsProvider>(
      builder: (ctx, data, child) {
        final flashSales = data.flashSaleProducts;
        final newSales = data.newProducts;
        return SingleChildScrollView(
          child: Column(
            children: [
              HomeCarouselWidget(),
              SizedBox(
                height: mHeight * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _getCategoryItems(
                            mWidth: mWidth,
                            mHeight: mHeight,
                            color: Colors.redAccent.shade100,
                            icon: FontAwesomeIcons.bone,
                            title: "Food",
                            onPress: () {
                              Navigator.pushNamed(
                                  context, ProductListScreen.routeName,
                                  arguments: {
                                    "type": "Food",
                                    "diff": "category"
                                  });
                            }),
                        _getCategoryItems(
                            mWidth: mWidth,
                            mHeight: mHeight,
                            color: Colors.green,
                            icon: FontAwesomeIcons.dog,
                            title: "Grooming",
                            onPress: () {
                              Navigator.pushNamed(
                                  context, ProductListScreen.routeName,
                                  arguments: {
                                    "type": "Grooming",
                                    "diff": "category"
                                  });
                            }),
                        _getCategoryItems(
                            mWidth: mWidth,
                            mHeight: mHeight,
                            color: Colors.blue,
                            icon: FontAwesomeIcons.baseballBall,
                            title: "Toys",
                            onPress: () {
                              Navigator.pushNamed(
                                  context, ProductListScreen.routeName,
                                  arguments: {
                                    "type": "Toys",
                                    "diff": "category"
                                  });
                            }),
                        _getCategoryItems(
                            mWidth: mWidth,
                            mHeight: mHeight,
                            color: Colors.orange,
                            icon: FontAwesomeIcons.clinicMedical,
                            title: "Veterinary",
                            onPress: () {
                              Navigator.pushNamed(
                                  context, ProductListScreen.routeName,
                                  arguments: {
                                    "type": "Veterinary",
                                    "diff": "category"
                                  });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: mHeight * 0.03,
                    ),
                    _getTitleWidget(
                        mWidth: mWidth,
                        mHeight: mHeight,
                        themeConst: themeConst,
                        title: "Flash Sale",
                        onPress: () {
                          Navigator.pushNamed(
                              context, ProductListScreen.routeName, arguments: {
                            "type": "Flash Sale",
                            "diff": "type"
                          });
                        }),
                    SizedBox(
                      height: mHeight * 0.22,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        scrollDirection: Axis.horizontal,
                        itemCount: flashSales.length,
                        itemBuilder: (ctx, index) {
                          return ProductItemWidget(
                            id: flashSales[index].id,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: mHeight * 0.02,
                    ),
                    _getTitleWidget(
                        mWidth: mWidth,
                        mHeight: mHeight,
                        themeConst: themeConst,
                        title: "New Product",
                        onPress: () {
                          Navigator.pushNamed(
                              context, ProductListScreen.routeName, arguments: {
                            "type": "New Product",
                            "diff": "type"
                          });
                        }),
                    Container(
                      height: mHeight * 0.22,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        scrollDirection: Axis.horizontal,
                        itemCount: newSales.length,
                        itemBuilder: (ctx, index) {
                          return ProductItemWidget(
                            id: newSales[index].id,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: mHeight * 0.04,
              ),
            ],
          ),
        );
      },
    );
  }
}
