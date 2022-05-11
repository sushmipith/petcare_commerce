import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/constants/constants.dart';
import 'providers/admin_order_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/products_provider.dart';
import 'screens/admin/orders/ongoing_order_details_screen.dart';
import 'screens/admin/product/edit_product_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/bottom_overview_screen.dart';
import 'screens/image_preview_screen.dart';
import 'screens/order/cancel_order_screen.dart';
import 'screens/order/order_details_screen.dart';
import 'screens/order/order_screen.dart';
import 'screens/product/product_detail_screen.dart';
import 'screens/product/product_list_screen.dart';
import 'screens/profile/favourites_screen.dart';
import 'screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'core/service/service_locator.dart';

/// FUNC [main] : main is the function that runs the program
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<AuthProvider>()),
        ChangeNotifierProvider.value(value: locator<ProductsProvider>()),
        ChangeNotifierProvider.value(value: locator<CartProvider>()),
        ChangeNotifierProvider.value(value: locator<OrderProvider>()),
        ChangeNotifierProvider.value(value: locator<AdminOrderProvider>()),
      ],
      child: MaterialApp(
        title: 'Pet Care Commerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
          primaryColorLight: primaryLightColor,
          primaryColorDark: primaryColor,
          canvasColor: Colors.white,
          fontFamily: "Montserrat",
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 20),
            toolbarTextStyle: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 24),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: primaryColor,
              brightness: Brightness.light,
              onPrimary: primaryColor,
              secondary: accentColor),
        ),
        routes: {
          '/': (ctx) => const SplashScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          RegisterScreen.routeName: (ctx) => const RegisterScreen(),
          BottomOverviewScreen.routeName: (ctx) => const BottomOverviewScreen(),
          ProductListScreen.routeName: (ctx) => const ProductListScreen(),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          ImagePreviewScreen.routeName: (ctx) => const ImagePreviewScreen(),
          OrderScreen.routeName: (ctx) => const OrderScreen(),
          FavouritesScreen.routeName: (ctx) => const FavouritesScreen(),
          ForgotPasswordScreen.routeName: (ctx) => const ForgotPasswordScreen(),
          EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          OrderDetailScreen.routeName: (ctx) => const OrderDetailScreen(),
          CancelOrderScreen.routeName: (ctx) => const CancelOrderScreen(),
          OngoingOrderDetailScreen.routeName: (ctx) =>
              const OngoingOrderDetailScreen(),
        },
      ),
    );
  }
}
