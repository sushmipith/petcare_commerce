import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petcare_commerce/provider/auth_provider.dart';
import 'package:petcare_commerce/screens/auth/login_screen.dart';
import 'package:petcare_commerce/screens/home_screen.dart';
import 'package:petcare_commerce/splash_screen.dart';
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
        home: MainPage(),
        routes: {},
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLogin = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      checkLogin();
    }
    _isInit = false;
  }

  void checkLogin() async {
    _isLogin = await Provider.of<AuthProvider>(context).tryAutoLogin();
    print("the login is $_isLogin");
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      imagePath: "assets/images/app_logo.jpg",
      backGroundColor: Colors.yellowAccent.shade400,
      logoSize: 200,
      duration: 2500,
      home: _isLogin ? HomeScreen.routeName : LoginScreen.routeName,
    );
  }
}
