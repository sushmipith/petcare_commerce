import 'dart:io';

import 'package:flutter/material.dart';
import '../core/constants/assets_source.dart';
import '../core/service/service_locator.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import 'admin/orders/ongoing_order_screen.dart';
import 'admin/product/edit_product_screen.dart';
import 'admin/product/user_product_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';
import '../widgets/badge_widget.dart';
import '../widgets/custom_snack_bar.dart';
import '../widgets/product_search_delegate.dart';
import 'package:provider/provider.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';

/// Screen [BottomOverviewScreen] : BottomOverviewScreen is the main home page with bottom navigation
class BottomOverviewScreen extends StatefulWidget {
  static const String routeName = "/bottom_overview_screen";

  const BottomOverviewScreen({Key? key}) : super(key: key);

  @override
  _BottomOverviewScreenState createState() => _BottomOverviewScreenState();
}

class _BottomOverviewScreenState extends State<BottomOverviewScreen> {
  /// Current Page
  int _selectedPageIndex = 0;
  bool _isAdmin = false;
  late ThemeData themeConst;
  late Future _getAllProducts;

  // Change the index
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  PreferredSizeWidget? _getCurrentAppBar() {
    switch (_selectedPageIndex) {
      case 0:
        return AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AssetsSource.appLogo,
                height: 40,
                color: Colors.white,
              ),
              const SizedBox(
                width: 20,
              ),
              const Text('Pet Care', style: TextStyle(color: Colors.white))
            ],
          ),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  showSearch(
                      context: context, delegate: ProductSearchDelegate());
                })
          ],
          backgroundColor: themeConst.primaryColor,
        );
      case 1:
        return _isAdmin
            ? null
            : AppBar(
                title: const Text("My Cart"),
                backgroundColor: themeConst.primaryColor,
              );
      case 2:
        return _isAdmin
            ? AppBar(
                title: const Text(
                  "Products",
                ),
                actions: [
                  TextButton.icon(
                      label: const Icon(Icons.add),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      icon: const Text(
                        'Add',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, EditProductScreen.routeName);
                      })
                ],
                backgroundColor: themeConst.primaryColor,
              )
            : AppBar(
                title: const Text("My Profile",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: themeConst.primaryColor,
              );
      case 3:
        return AppBar(
          title:
              const Text("My Profile", style: TextStyle(color: Colors.white)),
          backgroundColor: themeConst.primaryColor,
        );
      default:
        return AppBar(title: const Text("My Cart"));
    }
  }

  Future<void> getProducts() async {
    try {
      await locator<ProductsProvider>().fetchAllProducts();
    } on HttpException catch (error) {
      showCustomSnackBar(
        isError: true,
        message: error.message,
        context: context,
      );
      await locator<AuthProvider>().logout();
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } catch (error) {
      showCustomSnackBar(
        isError: true,
        message: 'Something went wrong. Please try again!',
        context: context,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllProducts = getProducts();
    _isAdmin = locator<AuthProvider>().isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    themeConst = Theme.of(context);
    return Scaffold(
      appBar: _getCurrentAppBar(),
      body: FutureBuilder(
        future: _getAllProducts,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : IndexedStack(index: _selectedPageIndex, children: [
                  const HomeScreen(),
                  _isAdmin ? const OngoingOrderScreen() : const CartScreen(),
                  if (_isAdmin) const UserProductScreen(),
                  const ProfileScreen()
                ]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        currentIndex: _selectedPageIndex,
        selectedItemColor: themeConst.primaryColor,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xFF727C8E),
        onTap: (index) => _selectPage(index),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          _isAdmin
              ? const BottomNavigationBarItem(
                  icon: Icon(Icons.business_center_outlined), label: "Orders")
              : BottomNavigationBarItem(
                  icon: Consumer<CartProvider>(builder: (ctx, data, child) {
                    final cartCount = data.totalCount;
                    return cartCount == 0
                        ? const Icon(Icons.shopping_cart)
                        : BadgeWidget(
                            child: const Icon(Icons.shopping_cart),
                            value: '$cartCount');
                  }),
                  label: "Cart"),
          if (_isAdmin)
            const BottomNavigationBarItem(
                icon: Icon(Icons.all_inbox), label: "Products"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: "Profile"),
        ],
      ),
    );
  }
}
