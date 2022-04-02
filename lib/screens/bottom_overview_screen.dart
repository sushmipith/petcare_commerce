import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petcare_commerce/core/constants/assets_source.dart';
import 'package:provider/provider.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';

class BottomOverviewScreen extends StatefulWidget {
  static const String routeName = "/bottom_overview_screen";

  @override
  _BottomOverviewScreenState createState() => _BottomOverviewScreenState();
}

class _BottomOverviewScreenState extends State<BottomOverviewScreen> {
  /// Current Page
  int _selectedPageIndex = 0;
  late ThemeData themeConst;

  // Change the index
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  PreferredSizeWidget _getCurrentAppBar() {
    switch (_selectedPageIndex) {
      case 0:
        return AppBar(
          title: Image.asset(
            AssetsSource.appLogo,
            height: 40,
            color: Colors.white,
          ),
          actions: [],
          backgroundColor: themeConst.primaryColor,
        );
      case 1:
        return AppBar(
          title: Text("My Cart"),
          backgroundColor: themeConst.primaryColor,
        );
      case 2:
        return AppBar(
          title: Text(
            "My Products",
          ),
          actions: [],
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

  /// Get the current page
  Widget _getCurrentPage() {
    switch (_selectedPageIndex) {
      case 0:
        return HomeScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeConst = Theme.of(context);
    return Scaffold(
      appBar: _getCurrentAppBar(),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        currentIndex: _selectedPageIndex,
        selectedItemColor: themeConst.primaryColor,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xFF727C8E),
        onTap: (index) => _selectPage(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox), label: "My Products"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: "Profile"),
        ],
      ),
    );
  }
}
