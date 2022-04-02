import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final String home;
  final String imagePath;
  final int duration;
  final Color backGroundColor;
  final double logoSize;

  SplashScreen(
      {Key? key,
      required this.imagePath,
      required this.home,
      required this.duration,
      this.backGroundColor = Colors.white,
      this.logoSize = 250.0})
      : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late String _home;
  late String _imagePath;
  late int _duration;
  late Color _backGroundColor;
  late double _logoSize;

  @override
  void initState() {
    super.initState();
    _home = widget.home;
    _imagePath = widget.imagePath;
    _duration = widget.duration;
    _backGroundColor = widget.backGroundColor;
    _logoSize = widget.logoSize;
    if (_duration < 1000) _duration = 2000;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    _animationController.forward();
    goToHome();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Future<void> goToHome() async {
    await Future.delayed(Duration(milliseconds: _duration));
    Navigator.of(context).pushReplacementNamed(_home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _backGroundColor,
        body: FadeTransition(
            opacity: _animation ,
            child: Center(
                child: SizedBox(
                    height: _logoSize, child: Image.asset(_imagePath)))));
  }
}
