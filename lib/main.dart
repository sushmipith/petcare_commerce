import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:petcare_commerce/providers/products_provider.dart';
import 'package:petcare_commerce/screens/auth/login_screen.dart';
import 'package:petcare_commerce/screens/auth/register_screen.dart';
import 'package:petcare_commerce/screens/bottom_overview_screen.dart';
import 'package:petcare_commerce/screens/home/home_screen.dart';
import 'package:petcare_commerce/screens/product/product_detail_screen.dart';
import 'package:petcare_commerce/screens/product/product_list_screen.dart';
import 'package:petcare_commerce/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return AuthProvider();
        }),
        ChangeNotifierProxyProvider<AuthProvider, Products>(
          create: (BuildContext context) {
            return Products("", "");
          },
          update: (context, AuthProvider auth, Products? updatedProduct) {
            return updatedProduct!..setTokenAndId(auth.token, auth.userId);
          },
        ),
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
          LoginScreen.routeName: (ctx) => LoginScreen(),
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
          BottomOverviewScreen.routeName: (ctx) => BottomOverviewScreen(),
          ProductListScreen.routeName: (ctx) => ProductListScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen()
        },
      ),
    );
  }
}
