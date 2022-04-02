import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:petcare_commerce/screens/auth/login_screen.dart';
import 'package:petcare_commerce/screens/auth/register_screen.dart';
import 'package:petcare_commerce/screens/bottom_overview_screen.dart';
import 'package:petcare_commerce/screens/home/home_screen.dart';
import 'package:petcare_commerce/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return AuthProvider();
        }),
      ],
      child: MaterialApp(
        title: 'Pet Care Commerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
          primaryColorLight: Colors.green,
          primaryColorDark: Colors.green,
          canvasColor: Colors.white,
          fontFamily: "Montserrat",
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            textTheme: TextTheme(
                headline6: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 24)),
          ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xFFF7B733)),
        ),
        routes: {
          '/': (ctx) => const SplashScreen(),
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
          BottomOverviewScreen.routeName: (ctx) => BottomOverviewScreen(),
        },
      ),
    );
  }
}
