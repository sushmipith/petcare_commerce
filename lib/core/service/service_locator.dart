import 'package:get_it/get_it.dart';
import 'package:petcare_commerce/core/network/http_service.dart';
import 'package:petcare_commerce/providers/admin_order_provider.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:petcare_commerce/providers/cart_provider.dart';
import 'package:petcare_commerce/providers/order_provider.dart';
import 'package:petcare_commerce/providers/products_provider.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // * Http Service
  locator.registerLazySingleton<HttpService>(() => HttpService());

  // * Auth Provider
  locator.registerLazySingleton<AuthProvider>(() => AuthProvider());

  // * Products Provider
  locator.registerLazySingleton<ProductsProvider>(() => ProductsProvider());

  // * Cart Provider
  locator.registerLazySingleton<CartProvider>(() => CartProvider());

  // * Order Provider
  locator.registerLazySingleton<OrderProvider>(() => OrderProvider());

  // * Admin Order Provider
  locator.registerLazySingleton<AdminOrderProvider>(() => AdminOrderProvider());
}
