import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:petcare_commerce/providers/cart_provider.dart';
import 'package:petcare_commerce/providers/order_provider.dart';
import 'package:petcare_commerce/providers/products_provider.dart';
import 'package:petcare_commerce/screens/auth/login_screen.dart';
import 'package:petcare_commerce/screens/auth/register_screen.dart';
import 'package:petcare_commerce/screens/bottom_overview_screen.dart';
import 'package:petcare_commerce/screens/image_preview_screen.dart';
import 'package:petcare_commerce/screens/order/order_screen.dart';
import 'package:petcare_commerce/screens/product/product_detail_screen.dart';
import 'package:petcare_commerce/screens/product/product_list_screen.dart';
import 'package:petcare_commerce/screens/profile/favourites_screen.dart';
import 'package:petcare_commerce/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'core/service/service_locator.dart';

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
      ],
      child: MaterialApp(
        title: 'Pet Care Commerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF9d73ef),
          primaryColorLight: const Color(0xFFb38ffa),
          primaryColorDark: const Color(0xFF9d73ef),
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
              primary: const Color(0xFF9d73ef),
              brightness: Brightness.light,
              onPrimary: const Color(0xFF9d73ef),
              secondary: const Color(0xFFF7B733)),
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
        },
      ),
    );
  }
}
