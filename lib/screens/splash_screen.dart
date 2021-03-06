import '../core/service/service_locator.dart';
import 'bottom_overview_screen.dart';

import '../core/constants/assets_source.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';

import 'auth/login_screen.dart';

/// Screen [SplashScreen] : SplashScreen is the loading screen that loads user data
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Future? _getData;
  bool _isInit = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _getData = _fetchData();
    }
    _isInit = false;
  }

  Future _fetchData() async {
    await Future.delayed(const Duration(seconds: 3));
    bool isLogin = await locator<AuthProvider>().tryAutoLogin();
    if (isLogin) {
      Navigator.of(context)
          .pushReplacementNamed(BottomOverviewScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9d73ef),
      body: FutureBuilder(
        future: _getData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Center(
              child: ScaleTransition(
            scale: _animation,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Image.asset(
                AssetsSource.appLogo,
                color: Colors.white,
                height: 200,
              ),
            ),
          ));
        },
      ),
    );
  }
}
